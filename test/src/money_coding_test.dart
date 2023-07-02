/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

class _TestEncoder implements MoneyEncoder<String> {
  @override
  String encode(MoneyData data) =>
      '${data.currency.code} ${data.amount.minorUnits}';
}

class _TestDecoder implements MoneyDecoder<MoneyData> {
  @override
  MoneyData decode(MoneyData encoded) => encoded;
}

class _FailingDecoder implements MoneyDecoder<String> {
  @override
  MoneyData decode(String encoded) {
    throw const FormatException();
  }
}

void main() {
  final usd = Currency.create('USD', 2);

  group('MoneyData', () {
    test('has properties: minorUnits, currency', () {
      final minorUnits = BigInt.from(100);

      final data = MoneyData.from(Fixed.fromBigInt(minorUnits), usd);
      expect(data.amount.minorUnits, equals(minorUnits));
      expect(data.amount.scale, equals(2));
      expect(data.currency, equals(usd));
    });
  });

  group('Money', () {
    test('encoding', () {
      final fiveDollars = Money.fromIntMinUnitWithCurrency(500, usd);

      expect(fiveDollars.encodedBy(_TestEncoder()), equals('USD 500'));
    });

    test('decoding', () {
      final money = Money.decoding(
          MoneyData.from(Fixed.fromNum(500, scale: 2), usd), _TestDecoder());

      expect(money, equals(Money.fromIntMinUnitWithCurrency(50000, usd)));
    });

    group('round trip', () {
      test('single-character symbol', () {
        final m1 = Money.fromNumWithCurrency(0, CommonCurrencies().aud);
        final m2 =
            Money.parseWithCurrency(m1.toString(), CommonCurrencies().aud);

        expect(m1, m2);
      });

      test('multi-character symbol', () {
        final m1 = Money.fromIntMinUnitWithCurrency(0, CommonCurrencies().brl);
        final m2 =
            Money.parseWithCurrency(m1.toString(), CommonCurrencies().brl);

        expect(m1, m2);
      });
    });

    test('decoding exception', () {
      expect(() => Money.decoding('invalid data', _FailingDecoder()),
          throwsFormatException);
    });
  });
}
