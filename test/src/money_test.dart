/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Money', () {
    group('instantiation', () {
      test('fromInt', () {
        Money.fromIntMinUnit(0, code: 'USD');
        Money.fromIntMinUnit(1, code: 'USD');
        Money.fromIntMinUnit(-1, code: 'USD');
      });

      test('from', () {
        expect(Money.fromNum(0, code: 'USD'),
            equals(Money.fromIntMinUnit(0, code: 'USD')));
        expect(Money.fromNum(1, code: 'USD'),
            equals(Money.fromIntMinUnit(100, code: 'USD')));
        expect(Money.fromNum(-1, code: 'USD'),
            equals(Money.fromIntMinUnit(-100, code: 'USD')));
        expect(Money.fromNum(1.99, code: 'USD'),
            equals(Money.fromIntMinUnit(199, code: 'USD')));
        expect(Money.fromNum(-1.99, code: 'USD'),
            equals(Money.fromIntMinUnit(-199, code: 'USD')));
      });

      test('high precision', () {
        final currency = Currency.create('BIG', 63);
        Currencies().register(currency);
        expect(
            Money.parse(r'$10.0', code: 'BIG').minorUnits /
                currency.scaleFactor,
            equals(10.0));

        expect(
            () =>
                Money.fromNum(10.0, code: 'BIG').minorUnits /
                currency.scaleFactor,
            throwsA(isA<AmountTooLargeException>()));
        expect(
            Money.parse(r'$-10.0', code: 'BIG').minorUnits /
                currency.scaleFactor,
            equals(-10.0));
      });
    });

    test('bigint hash value', () {
      final fiveDollars = Money.fromIntMinUnit(500, code: 'USD');

      expect(fiveDollars.hashCode,
          equals(Money.fromIntMinUnit(500, code: 'USD').hashCode));
    });

    test('int hash value', () {
      final fiveDollars = Money.fromIntMinUnit(500, code: 'USD');

      expect(fiveDollars.hashCode,
          equals(Money.fromIntMinUnit(500, code: 'USD').hashCode));
    });

    test('predicate of currency', () {
      final oneDollars = Money.fromIntMinUnit(100, code: 'USD');

      expect(oneDollars.isInCurrency('USD'), isTrue);
      expect(oneDollars.isInCurrency('EUR'), isFalse);
    });

    test('predicate of currency match', () {
      final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
      final twoDollars = Money.fromIntMinUnit(200, code: 'USD');
      final oneEuro = Money.fromIntMinUnit(100, code: 'EUR');

      expect(oneDollar.isInSameCurrencyAs(twoDollars), isTrue);
      expect(oneDollar.isInSameCurrencyAs(oneEuro), isFalse);
    });

    group('big int amount predicates:', () {
      final zeroCents = Money.fromIntMinUnit(0, code: 'USD');
      final oneCent = Money.fromIntMinUnit(1, code: 'USD');
      final minusOneCent = Money.fromIntMinUnit(-1, code: 'USD');

      moneyAmountPredicates(zeroCents, oneCent, minusOneCent);
    }); // big int amount predicates

    group('int amount predicates:', () {
      final zeroCents = Money.fromIntMinUnit(0, code: 'USD');
      final oneCent = Money.fromIntMinUnit(1, code: 'USD');
      final minusOneCent = Money.fromIntMinUnit(-1, code: 'USD');

      moneyAmountPredicates(zeroCents, oneCent, minusOneCent);
    }); //
    group('comparison', () {
      final fourDollars = Money.fromIntMinUnit(400, code: 'USD');
      final fiveDollars = Money.fromIntMinUnit(500, code: 'USD');
      final sixDollars = Money.fromIntMinUnit(600, code: 'USD');

      final fiveEuros = Money.fromIntMinUnit(500, code: 'EUR');

      test('==()', () {
        expect(fiveDollars, equals(Money.fromIntMinUnit(500, code: 'USD')));
        expect(fiveDollars, isNot(equals(fourDollars)));
        expect(fiveDollars, isNot(equals(sixDollars)));
        expect(fiveDollars, isNot(equals(fiveEuros)));
      });

      test('<()', () {
        expect(fiveDollars < sixDollars, isTrue);
        expect(fiveDollars < fiveDollars, isFalse);
        expect(fiveDollars < fourDollars, isFalse);

        // Cannot compare money in different currencies:
        expect(() => fiveDollars < fiveEuros, throwsArgumentError);
      });

      test('<=()', () {
        expect(fiveDollars <= sixDollars, isTrue);
        expect(fiveDollars <= fiveDollars, isTrue);
        expect(fiveDollars <= fourDollars, isFalse);

        // Cannot compare money in different currencies:
        expect(() => fiveDollars <= fiveEuros, throwsArgumentError);
      });

      test('>()', () {
        expect(fiveDollars > fourDollars, isTrue);
        expect(fiveDollars > fiveDollars, isFalse);
        expect(fiveDollars > sixDollars, isFalse);

        // Cannot compare money in different currencies:
        expect(() => fiveDollars > fiveEuros, throwsArgumentError);
      });

      test('>=()', () {
        expect(fiveDollars >= fourDollars, isTrue);
        expect(fiveDollars >= fiveDollars, isTrue);
        expect(fiveDollars >= sixDollars, isFalse);

        // Cannot compare money in different currencies:
        expect(() => fiveDollars >= fiveEuros, throwsArgumentError);
      });

      test('conformance to Comparable', () {
        expect(fiveDollars, isA<Comparable<Money>>());

        expect(fiveDollars.compareTo(fiveDollars), isZero);
        expect(fiveDollars.compareTo(fourDollars), isPositive);
        expect(fiveDollars.compareTo(sixDollars), isNegative);
        expect(() => fiveDollars.compareTo(fiveEuros), throwsArgumentError);
      });
    }); // comparison

    group('arithmetic:', () {
      test('addition', () {
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final twoDollars = Money.fromIntMinUnit(200, code: 'USD');
        final threeDollars = Money.fromIntMinUnit(300, code: 'USD');

        expect(oneDollar + twoDollars, equals(threeDollars));
      });

      test('addition error for summands in different currencies', () {
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final oneEuro = Money.fromIntMinUnit(100, code: 'EUR');

        expect(() => oneDollar + oneEuro, throwsArgumentError);
      });

      test('unary minus', () {
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final minusOneDollar = Money.fromIntMinUnit(-100, code: 'USD');

        expect(-oneDollar, equals(minusOneDollar));
        expect(-minusOneDollar, equals(oneDollar));
      });

      test('subtraction', () {
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final twoDollars = Money.fromIntMinUnit(200, code: 'USD');
        final threeDollars = Money.fromIntMinUnit(300, code: 'USD');

        expect(threeDollars - oneDollar, equals(twoDollars));
      });

      test('subtraction error for operands in different currencies', () {
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final oneEuro = Money.fromIntMinUnit(100, code: 'EUR');

        expect(() => oneDollar - oneEuro, throwsArgumentError);
      });

      test('multiplication', () {
        final zeroDollars = Money.fromIntMinUnit(0, code: 'USD');
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final twoDollars = Money.fromIntMinUnit(200, code: 'USD');

        // Test integral multiplication:
        expect(oneDollar * 0, equals(zeroDollars));
        expect(oneDollar * 2, equals(twoDollars));
        expect(oneDollar * -2, equals(-twoDollars));

        // Test floating-point multiplication:
        expect(oneDollar * 0.0, equals(zeroDollars));
        expect(oneDollar * -0.0, equals(zeroDollars));
        expect(oneDollar * 1.0, equals(oneDollar));
        expect(oneDollar * -1.0, equals(-oneDollar));

        expect(oneDollar * 0.5, equals(Money.fromIntMinUnit(50, code: 'USD')));
        expect(
            oneDollar * 2.01, equals(Money.fromIntMinUnit(201, code: 'USD')));
        expect(oneDollar * 0.99, equals(Money.fromIntMinUnit(99, code: 'USD')));

        // Test schoolbook rounding:
        expect(oneDollar * 0.094, equals(Money.fromIntMinUnit(9, code: 'USD')));
        expect(
            oneDollar * -0.094, equals(Money.fromIntMinUnit(-9, code: 'USD')));

        expect(
            oneDollar * 0.095, equals(Money.fromIntMinUnit(10, code: 'USD')));
        expect(
            oneDollar * -0.095, equals(Money.fromIntMinUnit(-10, code: 'USD')));
      });

      test('division', () {
        final zeroDollars = Money.fromIntMinUnit(0, code: 'USD');
        final fiftyCents = Money.fromIntMinUnit(50, code: 'USD');
        final oneDollar = Money.fromIntMinUnit(100, code: 'USD');
        final twoDollars = Money.fromIntMinUnit(200, code: 'USD');

        final t1 = twoDollars / 2;
        expect(t1.integerPart, equals(BigInt.one));
        expect(t1.decimalPart, equals(BigInt.zero));
        expect(t1.scale, 2);

        final t2 = -oneDollar;
        expect(t2.integerPart, equals(BigInt.from(-1)));
        expect(t2.decimalPart, equals(BigInt.zero));
        expect(t2.scale, equals(2));

        // Test with integral divisor:
        expect(zeroDollars / 2, equals(zeroDollars));
        expect(twoDollars / 1, equals(twoDollars));

        expect(twoDollars / 2, equals(oneDollar));
        expect(twoDollars / -2, equals(-oneDollar));

        expect(oneDollar / 2, equals(fiftyCents));
        expect(oneDollar / 3, equals(Money.fromIntMinUnit(33, code: 'USD')));

        // Test with floating-point divisor:
        expect(oneDollar / 0.5, equals(twoDollars));
        expect(oneDollar / 0.5, equals(twoDollars));

        expect(
            oneDollar / 1.094, equals(Money.fromIntMinUnit(91, code: 'USD')));
        expect(
            oneDollar / -1.094, equals(Money.fromIntMinUnit(-91, code: 'USD')));

        expect(
            oneDollar / 1.092, equals(Money.fromIntMinUnit(92, code: 'USD')));
        expect(
            oneDollar / -1.092, equals(Money.fromIntMinUnit(-92, code: 'USD')));
      });
    }); // arithmetic

    group('allocation according to ratios', () {
      test('throws an error when list of ratios is empty', () {
        final money = Money.fromIntMinUnit(1, code: 'USD');

        expect(() => money.allocationAccordingTo([]), throwsArgumentError);
      });

      test('throws an error if any of ratios is negative', () {
        final money = Money.fromIntMinUnit(1, code: 'USD');

        expect(() => money.allocationAccordingTo([-1]), throwsArgumentError);
        expect(() => money.allocationAccordingTo([4, -1]), throwsArgumentError);
      });

      test('throws an error if sum of ratios euals zero', () {
        final money = Money.fromIntMinUnit(1, code: 'USD');

        expect(() => money.allocationAccordingTo([0]), throwsArgumentError);
        expect(() => money.allocationAccordingTo([0, 0]), throwsArgumentError);
      });

      test('provides list with allocated money values', () {
        void testAllocation(
            int minorUnits, List<int> ratios, List<int> result) {
          final money = Money.fromIntMinUnit(minorUnits, code: 'USD');

          expect(
              money.allocationAccordingTo(ratios),
              equals(result.map((minorUnits) =>
                  Money.fromIntMinUnit(minorUnits, code: 'USD'))));
        }

        // Allocation of zero amount:
        testAllocation(0, [1], [0]);
        testAllocation(0, [1, 1], [0, 0]);
        testAllocation(0, [1, 0], [0, 0]);

        // Allocation of positive amount:
        testAllocation(100, [50], [100]);
        testAllocation(100, [1, 1], [50, 50]);
        testAllocation(100, [1, 1, 1], [34, 33, 33]);
        testAllocation(101, [1, 1, 1], [34, 34, 33]);
        testAllocation(2, [1, 1, 1], [1, 1, 0]);
        testAllocation(5, [3, 7], [2, 3]);
        testAllocation(5, [7, 3], [4, 1]);
        testAllocation(5, [0, 7, 3], [0, 4, 1]);
        testAllocation(5, [7, 0, 3], [4, 0, 1]);
        testAllocation(5, [7, 3, 0], [4, 1, 0]);
        testAllocation(5, [0, 0, 1], [0, 0, 5]);

        // Allocation of negative amount:
        testAllocation(-100, [50], [-100]);
        testAllocation(-100, [1, 1], [-50, -50]);
        testAllocation(-100, [1, 1, 1], [-34, -33, -33]);
        testAllocation(-101, [1, 1, 1], [-34, -34, -33]);
        testAllocation(-2, [1, 1, 1], [-1, -1, 0]);
        testAllocation(-5, [3, 7], [-2, -3]);
        testAllocation(-5, [7, 3], [-4, -1]);
        testAllocation(-5, [0, 7, 3], [0, -4, -1]);
        testAllocation(-5, [7, 0, 3], [-4, 0, -1]);
        testAllocation(-5, [7, 3, 0], [-4, -1, 0]);
        testAllocation(-5, [0, 0, 1], [0, 0, -5]);
      });
    });

    group('allocation to targets', () {
      test('throws an error if number of targets less than one', () {
        final money = Money.fromIntMinUnit(100, code: 'USD');

        expect(() => money.allocationTo(0), throwsArgumentError);
        expect(() => money.allocationTo(-1), throwsArgumentError);
      });

      test('returns a list with values allocated among N targets', () {
        void testAllocation(int minorUnits, int targets, List<int> result) {
          final money = Money.fromIntMinUnit(minorUnits, code: 'USD');

          expect(
              money.allocationTo(targets),
              equals(result
                  .map((minorUnits) =>
                      Money.fromIntMinUnit(minorUnits, code: 'USD'))
                  .toList()));
        }

        // Allocation of zero amount:
        testAllocation(0, 1, [0]);
        testAllocation(0, 2, [0, 0]);

        // Allocation of positive amount:
        testAllocation(100, 1, [100]);
        testAllocation(100, 2, [50, 50]);
        testAllocation(101, 2, [51, 50]);

        // Allocation of negative amount:
        testAllocation(-100, 1, [-100]);
        testAllocation(-100, 2, [-50, -50]);
        testAllocation(-101, 2, [-51, -50]);
      });
    });

    test('currency property', () {
      expect(Currencies().find('USD'),
          Money.fromIntMinUnit(1000, code: 'USD').currency);
      expect(Currencies().find('EUR'),
          Money.fromIntMinUnit(1000, code: 'EUR').currency);
    });

    test('minorUnits property', () {
      expect(Money.fromIntMinUnit(2000, code: 'USD').minorUnits,
          BigInt.from(2000));
      expect(Money.fromIntMinUnit(1001, code: 'EUR').minorUnits,
          BigInt.from(1001));
    });
  });
}

void moneyAmountPredicates(Money zeroCents, Money oneCent, Money minusOneCent) {
  test('isZero', () {
    expect(zeroCents.isZero, isTrue);
    expect(oneCent.isZero, isFalse);
    expect(minusOneCent.isZero, isFalse);
  });

  test('isPositive', () {
    expect(oneCent.isPositive, isTrue);
    expect(zeroCents.isPositive, isFalse);
    expect(minusOneCent.isPositive, isFalse);
  });

  test('isNegative', () {
    expect(minusOneCent.isNegative, isTrue);
    expect(zeroCents.isNegative, isFalse);
    expect(oneCent.isNegative, isFalse);
  });
}
