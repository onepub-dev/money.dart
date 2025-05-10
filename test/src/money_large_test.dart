import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  const maxScale = 100;
  const maxInts = 100;

  setUp(() {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currency.create('C$scale', scale, symbol: '=$scale=');
      Currencies().register(c);
    }
  });

  test('test default currency formatting', () {
    final roflWithDefaultFormatting =
        Currency.create('ROFL', 9, symbol: 'ROFL');
    expect(
      Money.parseWithCurrency('2.0', roflWithDefaultFormatting).format(),
      'ROFL2.00',
      reason: 'Failed default formatting',
    );
  });

  test('test custom currency formatting', () {
    final roflWithDefaultFormatting =
        Currency.create('ROFL', 9, symbol: 'ROFL', pattern: '0.000000000 S');
    expect(
      Money.parseWithCurrency('2.0', roflWithDefaultFormatting).format(),
      '2.000000000 ROFL',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom currency formatting 2', () {
    final roflWithDefaultFormatting =
        Currency.create('ROFL', 9, symbol: 'ROFL', pattern: '0.000000000 S');
    expect(
      Money.parseWithCurrency('2.01', roflWithDefaultFormatting).format(),
      '2.010000000 ROFL',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom currency formatting 3 (trim zeros)', () {
    final roflWithDefaultFormatting =
        Currency.create('ROFL', 9, symbol: 'ROFL', pattern: '0.######### S');
    expect(
      Money.parseWithCurrency('2.01', roflWithDefaultFormatting).format(),
      '2.01 ROFL',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom explicit formatting', () {
    final roflWithDefaultFormatting =
        Currency.create('ROFL', 9, symbol: 'ROFL', pattern: '0.######### S');
    expect(
      Money.parseWithCurrency('2.01', roflWithDefaultFormatting)
          .format('S 0.#########'),
      'ROFL 2.01',
      reason: 'Failed custom formatting',
    );
  });

  test('scale 0-$maxScale test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currencies().find('C$scale');
      expect(c, isNotNull);
      final str = scale == 0 ? '0' : '0.${'0' * (scale - 1)}1';
      final fmt = scale == 0 ? '0' : '0.${'#' * scale}';
      expect(
        Money.parseWithCurrency(str, c!).format(fmt),
        str,
        reason: 'Failed with $scale scale',
      );
    }
  });

  test('integers 0-$maxInts test', () {
    final c = Currencies().find('C0');
    expect(c, isNotNull);
    for (var ints = 0; ints <= maxInts; ints++) {
      final str = ints == 0 ? '0' : '9' * ints;
      const fmt = '0';
      expect(
        Money.parseWithCurrency(str, c!).format(fmt),
        str,
        reason: 'Failed with $ints ints',
      );
    }
  });

  test('scale 0-$maxScale and integers 0-$maxInts test', () {
    for (var scale = 19; scale <= maxScale; scale += 10) {
      for (var ints = 1; ints <= maxInts; ints += 10) {
        final c = Currencies().find('C$scale');
        expect(c, isNotNull);
        final intsStr = ints == 0 ? '0' : '9' * ints;
        final str = scale == 0 ? intsStr : '$intsStr.${'0' * (scale - 1)}1';
        final fmt = scale == 0 ? '0' : '0.${'0' * scale}';

        expect(
          Money.parseWithCurrency(str, c!).format(fmt),
          str,
          reason: 'Failed with $scale scale, $ints ints',
        );
      }
    }
  });

  test(
      'scale 0-$maxScale and integers 0-$maxInts addition and subtraction test',
      () {
    for (var scale = 0; scale <= maxScale; scale += 10) {
      for (var ints = 0; ints <= maxInts; ints += 10) {
        final c = Currencies().find('C$scale');
        expect(c, isNotNull);
        final intsStr = ints == 0 ? '1' : '9' * ints;
        const str0 = '1';
        final str1 =
            scale == 0 ? '${intsStr}1' : '${intsStr}1.${'0' * (scale - 1)}1';
        final str2 =
            scale == 0 ? '${intsStr}2' : '${intsStr}2.${'0' * (scale - 1)}1';

        final m0 = Money.fromFixedWithCurrency(
            Fixed.parse(str0, decimalDigits: scale), c!);
        final m1 = Money.fromFixedWithCurrency(
            Fixed.parse(str1, decimalDigits: scale), c);
        final m2 = Money.fromFixedWithCurrency(
            Fixed.parse(str2, decimalDigits: scale), c);
        final mDiff = m2 - m1;
        final mSum = m1 + m0;

        expect(
          mDiff.amount,
          Fixed.one,
          reason: 'Failed with $scale scale, $ints ints',
        );
        expect(
          mSum.amount,
          m2.amount,
          reason: 'Failed with $scale scale, $ints ints',
        );
      }
    }
  });
}
