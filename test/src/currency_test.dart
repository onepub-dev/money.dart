/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:convert';

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('A currency', () {
    test('has an isoCode and a precision', () {
      var currency = Currency.create('JPY', 0);
      expect(currency.isoCode, equals('JPY'));
      expect(currency.decimalDigits, equals(0));

      currency = Currency.create('USD', 2);
      expect(currency.isoCode, equals('USD'));
      expect(currency.decimalDigits, equals(2));
    });

    test('cannot be instantiated with empty isoCode', () {
      expect(() => Currency.create('', 0), throwsArgumentError);
    });

    test('cannot be instantiated with negative precision', () {
      expect(() => Currency.create('SOME', -1), throwsArgumentError);
      expect(() => Currency.create('SOME', -2), throwsArgumentError);
    });

    test('is equatable', () {
      final usd = Currency.create('USD', 2);

      expect(usd, equals(Currency.create('USD', 2)));
      expect(usd, isNot(equals(Currency.create('EUR', 2))));
      expect(usd, isNot(equals(Currency.create('USD', 0))));
      expect(usd, isNot(equals(Currency.create('JPY', 0))));
    });

    test('is hashable', () {
      final usd = Currency.create('USD', 2);

      expect(usd.hashCode, equals(Currency.create('USD', 2).hashCode));
    });

    test('btc', () {
      /// proposed
      final t2 = Currency.create('BTC', 8, symbol: '₿', pattern: 'S0.########');

      expect(Money.parseWithCurrency('1', t2).toString(), equals('₿1'));
      expect(Money.parseWithCurrency('1.1', t2).toString(), equals('₿1.1'));
      expect(Money.parseWithCurrency('1.11', t2).toString(), equals('₿1.11'));
      expect(Money.parseWithCurrency('1.01', t2).toString(), equals('₿1.01'));
    });

    group('JSON serialization', () {
      final custom = Currency.create(
        'USD',
        2,
        symbol: r'US$',
        pattern: r'US$ 0.00',
        groupSeparator: '_',
        decimalSeparator: ',',
        country: 'United States',
        unit: 'dollar',
        name: 'US Dollar',
      );

      final expectedJson = <String, dynamic>{
        'isoCode': 'USD',
        'decimalDigits': 2,
        'symbol': r'US$',
        'pattern': r'US$ 0.00',
        'groupSeparator': '_',
        'decimalSeparator': ',',
        'country': 'United States',
        'unit': 'dollar',
        'name': 'US Dollar',
        'isIso': true,
        'isDeprecated': false,
        'replacedBy': null
      };

      test('works correctly', () {
        expect(custom.toJson(), equals(expectedJson));
        expect(Currency.fromJson(expectedJson), equals(custom));
        expect(Currency.fromJson(custom.toJson()), equals(custom));
      });

      test('encodes as string correctly', () {
        final customJsonString = jsonEncode(custom);
        final expectedJsonString = jsonEncode(expectedJson);
        expect(customJsonString, equals(expectedJsonString));
      });

      test('decodes correctly from string', () {
        final customJsonString = jsonEncode(custom);
        final decodedCustom = Currency.fromJson(
          jsonDecode(customJsonString) as Map<String, dynamic>,
        );
        expect(decodedCustom, equals(custom));
      });

      test('works both ways (serialization and deserialization)', () {
        expect(custom, equals(Currency.fromJson(custom.toJson())));
      });

      test('full round trip is equal to original', () {
        final customJsonString = jsonEncode(custom);
        final decodedCustom = Currency.fromJson(
          jsonDecode(customJsonString) as Map<String, dynamic>,
        );
        expect(decodedCustom, equals(custom));
      });
    });
  });
}
