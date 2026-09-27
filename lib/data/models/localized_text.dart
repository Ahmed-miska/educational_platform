class LocalizedText {
  final String ar;
  final String en;

  const LocalizedText({required this.ar, this.en = ''});

  factory LocalizedText.fromJson(dynamic json) {
    if (json is String) return LocalizedText(ar: json, en: json);
    if (json is Map) {
      final ar = json['ar']?.toString() ?? '';
      final en = json['en']?.toString() ?? '';
      return LocalizedText(ar: ar.isNotEmpty ? ar : en, en: en);
    }
    return const LocalizedText(ar: '');
  }

  String of(String languageCode) => languageCode == 'en' && en.isNotEmpty ? en : ar;

  Iterable<String> get values => [ar, en].where((e) => e.isNotEmpty);
}
