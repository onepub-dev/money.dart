import 'package:characters/characters.dart';

extension Strings on String {
  String reverse() {
    if (length < 2) {
      return this;
    }

    final characters = Characters(this);
    return characters.toList().reversed.join();
  }

  static String padRight(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padRight(width, padding);
}
