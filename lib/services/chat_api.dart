import '../config/api_config.dart';
import '../models/chat_response.dart';
import 'api_client.dart';

/// 对话问答接口封装。
class ChatApi {
  ChatApi(this._client);

  final ApiClient _client;

  Future<ChatResponse> ask({
    required String query,
    required String lang,
  }) async {
    final json = await _client.postJson(ApiConfig.chatUrl, {
      'query': query,
      'lang': lang,
    });
    final response = ChatResponse.fromJson(json);
    if (!response.success) {
      throw ApiException('Chat request failed');
    }
    return response;
  }
}
