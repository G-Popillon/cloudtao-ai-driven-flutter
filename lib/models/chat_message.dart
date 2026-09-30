import 'weather_source.dart';

enum MessageRole { user, assistant }

/// 单条对话消息（本地持久化用）。
class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final List<WeatherSource> sources;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.sources = const [],
    required this.createdAt,
  });

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'sources': sources.map((s) => s.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final roleName = (json['role'] ?? 'user').toString();
    final role = roleName == MessageRole.assistant.name
        ? MessageRole.assistant
        : MessageRole.user;
    final rawSources = json['sources'];
    final sources = <WeatherSource>[];
    if (rawSources is List) {
      for (final item in rawSources) {
        sources.add(WeatherSource.fromJson(item));
      }
    }
    return ChatMessage(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString())
          .toString(),
      role: role,
      content: (json['content'] ?? '').toString(),
      sources: sources,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
