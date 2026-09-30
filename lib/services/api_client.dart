import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// 业务异常：接口返回 success=false 或 HTTP 非 2xx。
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// 统一 HTTP 客户端：超时、JSON 解析、错误包装。
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: const {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      return _decodeJsonMap(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<http.Response> postMultipart(
    String url,
    List<http.MultipartFile> files, {
    Map<String, String>? fields,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      if (fields != null) {
        request.fields.addAll(fields);
      }
      request.files.addAll(files);
      final streamed =
          await _client.send(request).timeout(ApiConfig.timeout);
      return http.Response.fromStream(streamed).timeout(ApiConfig.timeout);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<List<int>> postJsonBytes(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: const {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': '*/*',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.body}',
          statusCode: response.statusCode,
        );
      }
      return response.bodyBytes;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Map<String, dynamic> _decodeJsonMap(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'HTTP ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map) {
      throw ApiException('Invalid JSON response');
    }
    final map = Map<String, dynamic>.from(decoded);
    if (map.containsKey('success') && map['success'] == false) {
      throw ApiException(
        (map['message'] ?? map['error'] ?? 'Request failed').toString(),
      );
    }
    return map;
  }

  void close() => _client.close();
}
