/// 气象引用来源，兼容 String / Map 多种后端字段。
class WeatherSource {
  final String title;
  final String? url;
  final String? snippet;

  const WeatherSource({
    required this.title,
    this.url,
    this.snippet,
  });

  factory WeatherSource.fromJson(dynamic json) {
    if (json is String) {
      return WeatherSource(title: json);
    }
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      final title = _pickString(map, const ['title', 'name', 'source', 'id']) ??
          'Source';
      final url = _pickString(map, const ['url', 'link', 'href']);
      final snippet = _pickString(
        map,
        const ['snippet', 'content', 'text', 'data', 'description', 'body'],
      );
      return WeatherSource(title: title, url: url, snippet: snippet);
    }
    return WeatherSource(title: json.toString());
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (url != null) 'url': url,
        if (snippet != null) 'snippet': snippet,
      };

  static String? _pickString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }
}
