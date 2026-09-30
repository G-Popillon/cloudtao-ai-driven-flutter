import 'weather_source.dart';

/// POST /api/chat 响应。
class ChatResponse {
  final String answer;
  final List<WeatherSource> sources;
  final bool success;

  const ChatResponse({
    required this.answer,
    required this.sources,
    required this.success,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawSources = json['source'];
    final sources = <WeatherSource>[];
    if (rawSources is List) {
      for (final item in rawSources) {
        sources.add(WeatherSource.fromJson(item));
      }
    }
    return ChatResponse(
      answer: (json['answer'] ?? '').toString(),
      sources: sources,
      success: json['success'] == true || json['success'] == null,
    );
  }
}
