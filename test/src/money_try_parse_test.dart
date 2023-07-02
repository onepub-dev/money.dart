import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Money.tryParse', () {
    test('Default Currency Pattern', () {
      expect(Money.tryParse(r'$10.25', code: 'USD'),
          equals(Money.fromIntMinUnit(1025, code: 'USD')));
      expect(Money.tryParse('10.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromIntMinUnit(1025, code: 'USD')));
      expect(Money.tryParse('USD10.25', code: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromIntMinUnit(1025, code: 'USD')));
      expect(Money.tryParse(r'$USD10.25', code: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromIntMinUnit(1025, code: 'USD')));
      expect(Money.tryParse('1,000.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromIntMinUnit(100025, code: 'USD')));
    });

    test('Default Currency Pattern with negative number', () {
      expect(Money.tryParse(r'$-10.25', code: 'USD'),
          equals(Money.fromIntMinUnit(-1025, code: 'USD')));
      expect(Money.tryParse('-10.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromIntMinUnit(-1025, code: 'USD')));
      expect(Money.tryParse('USD-10.25', code: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromIntMinUnit(-1025, code: 'USD')));
      expect(Money.tryParse(r'$USD-10.25', code: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromIntMinUnit(-1025, code: 'USD')));
      expect(Money.tryParse('-1,000.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromIntMinUnit(-100025, code: 'USD')));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(Money.tryParse('10,25', code: 'EUR', pattern: '#,#'),
          equals(Money.fromIntMinUnit(1025, code: 'EUR')));
      expect(Money.tryParse('€10,25', code: 'EUR', pattern: 'S0,0'),
          equals(Money.fromIntMinUnit(1025, code: 'EUR')));
      expect(Money.tryParse('EUR10,25', code: 'EUR', pattern: 'CCC0,0'),
          equals(Money.fromIntMinUnit(1025, code: 'EUR')));
      expect(Money.tryParse('€EUR10,25', code: 'EUR', pattern: 'SCCC0,0'),
          equals(Money.fromIntMinUnit(1025, code: 'EUR')));
      expect(Money.tryParse('1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromIntMinUnit(100025, code: 'EUR')));
      expect(Money.tryParse('1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromIntMinUnit(100025, code: 'EUR')));
    });

    test('Inverted Decimal Separator with pattern with negative number', () {
      expect(Money.tryParse('-10,25', code: 'EUR', pattern: '#,#'),
          equals(Money.fromIntMinUnit(-1025, code: 'EUR')));
      expect(Money.tryParse('€-10,25', code: 'EUR', pattern: 'S0,0'),
          equals(Money.fromIntMinUnit(-1025, code: 'EUR')));
      expect(Money.tryParse('EUR-10,25', code: 'EUR', pattern: 'CCC0,0'),
          equals(Money.fromIntMinUnit(-1025, code: 'EUR')));
      expect(Money.tryParse('€EUR-10,25', code: 'EUR', pattern: 'SCCC0,0'),
          equals(Money.fromIntMinUnit(-1025, code: 'EUR')));
      expect(Money.tryParse('-1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromIntMinUnit(-100025, code: 'EUR')));
      expect(Money.tryParse('-1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromIntMinUnit(-100025, code: 'EUR')));
    });

    test('Invalid monetary amount', () {
      expect(Money.tryParse('XYZ', code: 'USD'), equals(null));
      expect(
          Money.tryParse('abc', code: 'USD', pattern: 'CCC#.#'), equals(null));
      expect(
          Money.tryParse('>0', code: 'USD', pattern: 'SCCC#.#'), equals(null));
      expect(Money.tryParse(' ', code: 'USD', pattern: '#.#'), equals(null));
      expect(Money.tryParse('', code: 'USD', pattern: '#.#'), equals(null));
    });

    group('tryParse methods', () {
      test('Money', () {
        expect(Money.tryParse(r'$10.25', code: 'USD'),
            equals(Money.fromIntMinUnit(1025, code: 'USD')));
      });
    });
  });
}
