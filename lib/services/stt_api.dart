import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../config/api_config.dart';
import 'api_client.dart';

/// 云端语音识别（STT）：上传录音文件，返回识别文本。
class SttApi {
  SttApi(this._client);

  final ApiClient _client;

  Future<String> transcribe({
    required File audioFile,
    required String lang,
  }) async {
    final file = await http.MultipartFile.fromPath(
      ApiConfig.sttFileField,
      audioFile.path,
      filename: p.basename(audioFile.path),
    );
    final response = await _client.postMultipart(
      ApiConfig.sttUrl,
      [file],
      fields: {'lang': lang},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'HTTP ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map) {
      throw ApiException('Invalid STT response');
    }
    final map = Map<String, dynamic>.from(decoded);
    if (map['success'] == false) {
      throw ApiException(
        (map['message'] ?? map['error'] ?? 'STT failed').toString(),
      );
    }
    return (map['text'] ?? '').toString().trim();
  }
}
