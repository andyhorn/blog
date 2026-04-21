import 'package:jaspr/dom.dart';

import '../constants/theme.dart';

Color tagColor(String tag) => switch (tag.toLowerCase()) {
  'flutter' => tagFlutterColor,
  'dart' => tagDartColor,
  'architecture' => tagArchColor,
  'open source' => tagOpenSourceColor,
  'devx' => tagDevXColor,
  _ => textMuted,
};

Color tagBgColor(String tag) => switch (tag.toLowerCase()) {
  'flutter' => tagFlutterBg,
  'dart' => tagDartBg,
  'architecture' => tagArchBg,
  'open source' => tagOpenSourceBg,
  'devx' => tagDevXBg,
  _ => borderDefault,
};
