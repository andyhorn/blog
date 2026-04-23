import 'package:flutter_test/flutter_test.dart';

import 'package:blog/utils/format_date.dart';

void main() {
  group('formatDate', () {
    test('formats each month name correctly', () {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      for (var i = 0; i < 12; i++) {
        final date = DateTime(2024, i + 1, 1);
        expect(formatDate(date), startsWith(months[i]));
      }
    });

    test('includes day and year', () {
      expect(formatDate(DateTime(2025, 3, 14)), 'March 14, 2025');
    });

    test('does not zero-pad day', () {
      expect(formatDate(DateTime(2024, 1, 5)), 'January 5, 2024');
    });

    test('formats leap day correctly', () {
      expect(formatDate(DateTime(2024, 2, 29)), 'February 29, 2024');
    });
  });
}
