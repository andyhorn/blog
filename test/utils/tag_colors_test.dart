import 'package:flutter_test/flutter_test.dart';

import 'package:blog/constants/theme.dart';
import 'package:blog/utils/tag_colors.dart';

void main() {
  group('tagColor', () {
    test('flutter maps to tagFlutterColor', () {
      expect(tagColor('flutter'), tagFlutterColor);
    });

    test('dart maps to tagDartColor', () {
      expect(tagColor('dart'), tagDartColor);
    });

    test('architecture maps to tagArchColor', () {
      expect(tagColor('architecture'), tagArchColor);
    });

    test('open source maps to tagOpenSourceColor', () {
      expect(tagColor('open source'), tagOpenSourceColor);
    });

    test('devx maps to tagDevXColor', () {
      expect(tagColor('devx'), tagDevXColor);
    });

    test('unknown tag falls back to textMuted', () {
      expect(tagColor('something-else'), textMuted);
    });

    test('is case-insensitive', () {
      expect(tagColor('Flutter'), tagFlutterColor);
      expect(tagColor('DART'), tagDartColor);
      expect(tagColor('Architecture'), tagArchColor);
    });
  });

  group('tagBgColor', () {
    test('flutter maps to tagFlutterBg', () {
      expect(tagBgColor('flutter'), tagFlutterBg);
    });

    test('dart maps to tagDartBg', () {
      expect(tagBgColor('dart'), tagDartBg);
    });

    test('architecture maps to tagArchBg', () {
      expect(tagBgColor('architecture'), tagArchBg);
    });

    test('open source maps to tagOpenSourceBg', () {
      expect(tagBgColor('open source'), tagOpenSourceBg);
    });

    test('devx maps to tagDevXBg', () {
      expect(tagBgColor('devx'), tagDevXBg);
    });

    test('unknown tag falls back to borderDefault', () {
      expect(tagBgColor('something-else'), borderDefault);
    });

    test('is case-insensitive', () {
      expect(tagBgColor('Flutter'), tagFlutterBg);
      expect(tagBgColor('DART'), tagDartBg);
    });
  });
}
