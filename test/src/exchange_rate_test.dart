/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:convert';

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      final aud = Currency.create('AUD', 2);
      final usd = Currency.create('USD', 2);
      final invoiceAmount = Money.fromIntWithCurrency(1000, aud);
      final auToUsExchangeRate = ExchangeRate.fromMinorUnits(68,
          decimalDigits: 2, fromIsoCode: 'AUD', toIsoCode: 'USD');
      final us680 = Money.fromIntWithCurrency(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });

    test('Exchange Rates - precision 1', () {
      final twd = Currency.create('TWD', 0, symbol: r'NT$');
      //final Currency usd = Currency.create('USD', 2);

      final twdM = Money.fromIntWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1,000.00'));

      final twdToUsdRate = ExchangeRate.fromMinorUnits(3,
          decimalDigits: 2,
          fromIsoCode: 'TWD',
          toIsoCode: 'USD'); // 1 TWD = 0.03 USD
      expect(twdToUsdRate.toString(), equals('0.03'));

      final usdM = twdM.exchangeTo(twdToUsdRate);
      expect(usdM.toString(), equals(r'$30.00'));

      // final Currency usdExchange =
      //     Currency.create('USD', 6, pattern: 'S0.000000');

      final acurateTwdToUsdRate = ExchangeRate.fromMinorUnits(35231,
          decimalDigits: 6,
          fromIsoCode: 'TWD',
          toIsoCode: 'USD',
          toDecimalDigits: 6); // 1 TWD = 0.035231 USD
      expect(acurateTwdToUsdRate.toString(), equals('0.035231'));

      expect(acurateTwdToUsdRate.format('0.00'), equals('0.03'));

      final usdMaccurate = twdM.exchangeTo(acurateTwdToUsdRate);
      expect(usdMaccurate.format('S#.000000'), equals(r'$35.231000'));
    });

    test('Exchange Rates - precision 2', () {
      //    final jpy = Currency.create('JPY', 0, symbol: '¥');
      final twd = Currency.create('TWD', 0, symbol: r'NT$');

      final twdM = Money.fromNumWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1,000.00'));

      final twdToJpyRate = ExchangeRate.fromMinorUnits(3,
          decimalDigits: 0, fromIsoCode: 'TWD', toIsoCode: 'JPY');
      expect(twdToJpyRate.toString(), equals('3'));

      final jpyM = twdM.exchangeTo(twdToJpyRate);
      expect(jpyM.toString(), equals('¥3,000'));
    });

    test('rub', () {
      final price = Money.fromNum(28000, isoCode: 'RUB');
      final rubToUsExchangeRate = ExchangeRate.fromNum(0.013445,
          decimalDigits: 6, fromIsoCode: 'RUB', toIsoCode: 'USD');
      expect(price.exchangeTo(rubToUsExchangeRate).format('###,###.## S'),
          equals(r'376.46 $'));
    });

    group('JSON serialization', () {
      final exchangeRate = ExchangeRate.fromNum(
        0.75312,
        decimalDigits: 5,
        fromIsoCode: 'AUD',
        toIsoCode: 'USD',
      );

      final expectedJson = <String, dynamic>{
        'minorUnits': '75312',
        'decimals': 5,
        'fromIsoCode': 'AUD',
        'toIsoCode': 'USD',
        'toDecimals': null,
      };

      test('works correctly', () {
        expect(exchangeRate.toJson(), equals(expectedJson));
        // Can not compare instances directly because they are not immutable.
        expect(
          ExchangeRate.fromJson(expectedJson).toJson(),
          equals(exchangeRate.toJson()),
        );
      });

      test('encodes as string correctly', () {
        final customJsonString = jsonEncode(exchangeRate);
        final expectedJsonString = jsonEncode(expectedJson);
        expect(customJsonString, equals(expectedJsonString));
      });

      test('decodes correctly from string', () {
        final customJsonString = jsonEncode(exchangeRate);
        final decodedCustom = ExchangeRate.fromJson(
          jsonDecode(customJsonString) as Map<String, dynamic>,
        );
        expect(decodedCustom.toJson(), equals(exchangeRate.toJson()));
      });

      test('works both ways (serialization and deserialization)', () {
        expect(
          exchangeRate.toJson(),
          equals(ExchangeRate.fromJson(exchangeRate.toJson()).toJson()),
        );
      });

      test('full round trip is equal to original', () {
        final customJsonString = jsonEncode(exchangeRate);
        final decodedCustom = ExchangeRate.fromJson(
          jsonDecode(customJsonString) as Map<String, dynamic>,
        );
        expect(decodedCustom.toJson(), equals(exchangeRate.toJson()));
      });
    });
  });
}
