import 'package:educational_platform/core/utils/functions.dart';
import 'package:educational_platform/core/utils/text_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatDuration', () {
    expect(formatDuration(const Duration(seconds: 95)), '1:35');
    expect(formatDuration(const Duration(seconds: 5)), '0:05');
    expect(formatDuration(const Duration(hours: 1, minutes: 2, seconds: 3)), '1:02:03');
    expect(formatDuration(const Duration(seconds: -4)), '0:00');
  });

  test('Arabic search normalization folds hamza, taa marbuta and diacritics', () {
    expect(normalizeForSearch('أساسيات'), normalizeForSearch('اساسيات'));
    expect(normalizeForSearch('مادة'), normalizeForSearch('ماده'));
    expect(normalizeForSearch('التَّشْرِيح'), 'التشريح');
    expect(normalizeForSearch('  Anatomy '), 'anatomy');
  });
}
