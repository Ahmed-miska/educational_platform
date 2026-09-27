final RegExp _arabicDiacritics = RegExp('[ً-ٰٟـ]');

String normalizeForSearch(String input) {
  return input.toLowerCase().replaceAll(_arabicDiacritics, '').replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ة', 'ه').replaceAll('ى', 'ي').trim();
}
