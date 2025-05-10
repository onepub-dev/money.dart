import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  const maxDecimalDigits = 100;
  const maxInts = 100;

  test('decimalDigits 0-$maxDecimalDigits test', () {
    for (var decimalDigits = 0;
        decimalDigits <= maxDecimalDigits;
        decimalDigits++) {
      final str = decimalDigits == 0 ? '1' : '1.${'0' * (decimalDigits - 1)}1';
      final fmt = decimalDigits == 0 ? 'S#' : '#.${'#' * decimalDigits}';
      expect(Fixed.parse(str, decimalDigits: decimalDigits).format(fmt), str,
          reason: 'Failed with $decimalDigits decimal digits');
    }
  });

  test('integers 0-$maxInts test', () {
    for (var ints = 0; ints <= maxInts; ints++) {
      final str = ints == 0 ? '0' : '9' * ints;
      const fmt = '#';
      expect(Fixed.parse(str, decimalDigits: 0).format(fmt), str,
          reason: 'Failed with $ints ints');
    }
  });

  test('decimal Digites 0-$maxDecimalDigits and integers 0-$maxInts test', () {
    for (var decimalDigits = 0;
        decimalDigits <= maxDecimalDigits;
        decimalDigits++) {
      for (var ints = 0; ints <= maxInts; ints++) {
        final intsStr = ints == 0 ? '0' : '9' * ints;
        final str = decimalDigits == 0
            ? intsStr
            : '$intsStr.${'0' * (decimalDigits - 1)}1';

        // Fixed doesn't like leading zeroes!
        final expectIntsStr = (ints == 0 && decimalDigits == 0)
            ? '0'
            : ints == 0
                ? ''
                : '9' * ints;
        final expectStr = decimalDigits == 0
            ? expectIntsStr
            : '$expectIntsStr.${'0' * (decimalDigits - 1)}1';

        final fmt = decimalDigits == 0 ? '#' : '#.${'#' * decimalDigits}';

        expect(Fixed.parse(str, decimalDigits: decimalDigits).format(fmt),
            expectStr,
            reason: 'Failed with $decimalDigits decimal Digits, $ints ints');
      }
    }
  });
}
