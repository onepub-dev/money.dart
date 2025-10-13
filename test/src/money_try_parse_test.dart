import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Money.tryParse', () {
    test('Default Currency Pattern', () {
      expect(Money.tryParse(r'$10.25', isoCode: 'USD'),
          equals(Money.fromInt(1025, isoCode: 'USD')));
      expect(Money.tryParse('10.25', isoCode: 'USD', pattern: '#.#'),
          equals(Money.fromInt(1025, isoCode: 'USD')));
      expect(Money.tryParse('USD10.25', isoCode: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, isoCode: 'USD')));
      expect(Money.tryParse(r'$USD10.25', isoCode: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, isoCode: 'USD')));
      expect(Money.tryParse('1,000.25', isoCode: 'USD', pattern: '#.#'),
          equals(Money.fromInt(100025, isoCode: 'USD')));
    });

    test('Default Currency Pattern with negative number', () {
      expect(Money.tryParse(r'$-10.25', isoCode: 'USD'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));
      expect(Money.tryParse(r'-$10.25', isoCode: 'USD'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));

      expect(Money.tryParse('-10.25', isoCode: 'USD', pattern: '#.#'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));
      expect(Money.tryParse('USD-10.25', isoCode: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));
      expect(Money.tryParse('-USD10.25', isoCode: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));
      expect(Money.tryParse(r'$USD-10.25', isoCode: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));
      expect(Money.tryParse(r'-$USD10.25', isoCode: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromInt(-1025, isoCode: 'USD')));

      expect(Money.tryParse('-1,000.25', isoCode: 'USD', pattern: '#.#'),
          equals(Money.fromInt(-100025, isoCode: 'USD')));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(Money.tryParse('10,25', isoCode: 'EUR', pattern: '#.#'),
          equals(Money.fromInt(1025, isoCode: 'EUR')));
      expect(Money.tryParse('€10,25', isoCode: 'EUR', pattern: 'S0.0'),
          equals(Money.fromInt(1025, isoCode: 'EUR')));
      expect(Money.tryParse('EUR10,25', isoCode: 'EUR', pattern: 'CCC0.0'),
          equals(Money.fromInt(1025, isoCode: 'EUR')));
      expect(Money.tryParse('€EUR10,25', isoCode: 'EUR', pattern: 'SCCC0.0'),
          equals(Money.fromInt(1025, isoCode: 'EUR')));
      expect(Money.tryParse('1.000,25', isoCode: 'EUR', pattern: '#,###.00'),
          equals(Money.fromInt(100025, isoCode: 'EUR')));
      expect(Money.tryParse('1.000,25', isoCode: 'EUR', pattern: '#,###.00'),
          equals(Money.fromInt(100025, isoCode: 'EUR')));
    });

    test('Inverted Decimal Separator with pattern with negative number', () {
      expect(Money.tryParse('-10,25', isoCode: 'EUR', pattern: '#.#'),
          equals(Money.fromInt(-1025, isoCode: 'EUR')));
      expect(Money.tryParse('€-10,25', isoCode: 'EUR', pattern: 'S0.0'),
          equals(Money.fromInt(-1025, isoCode: 'EUR')));
      expect(Money.tryParse('EUR-10,25', isoCode: 'EUR', pattern: 'CCC0.0'),
          equals(Money.fromInt(-1025, isoCode: 'EUR')));
      expect(Money.tryParse('€EUR-10,25', isoCode: 'EUR', pattern: 'SCCC0.0'),
          equals(Money.fromInt(-1025, isoCode: 'EUR')));
      expect(Money.tryParse('-1.000,25', isoCode: 'EUR', pattern: '#,###.00'),
          equals(Money.fromInt(-100025, isoCode: 'EUR')));
      expect(Money.tryParse('-1.000,25', isoCode: 'EUR', pattern: '#,###.00'),
          equals(Money.fromInt(-100025, isoCode: 'EUR')));
    });

    test('Invalid monetary amount', () {
      expect(Money.tryParse('XYZ', isoCode: 'USD'), equals(null));
      expect(Money.tryParse('abc', isoCode: 'USD', pattern: 'CCC#.#'),
          equals(null));
      expect(Money.tryParse('>0', isoCode: 'USD', pattern: 'SCCC#.#'),
          equals(null));
      expect(Money.tryParse(' ', isoCode: 'USD', pattern: '#.#'), equals(null));
      expect(Money.tryParse('', isoCode: 'USD', pattern: '#.#'), equals(null));
    });

    group('tryParse methods', () {
      test('Money', () {
        expect(Money.tryParse(r'$10.25', isoCode: 'USD'),
            equals(Money.fromInt(1025, isoCode: 'USD')));
      });
    });
  });
}
