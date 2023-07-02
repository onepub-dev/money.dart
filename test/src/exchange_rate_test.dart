/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      final aud = Currency.create('AUD', 2);
      final usd = Currency.create('USD', 2);
      final invoiceAmount = Money.fromIntMinUnitWithCurrency(1000, aud);
      final auToUsExchangeRate = ExchangeRate.fromMinorUnits(68,
          scale: 2, fromCode: 'AUD', toCode: 'USD');
      final us680 = Money.fromIntMinUnitWithCurrency(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });

    test('Exchange Rates - precision 1', () {
      final twd = Currency.create('TWD', 0, symbol: r'NT$');
      //final Currency usd = Currency.create('USD', 2);

      final twdM = Money.fromIntMinUnitWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToUsdRate = ExchangeRate.fromMinorUnits(3,
          scale: 2, fromCode: 'TWD', toCode: 'USD'); // 1 TWD = 0.03 USD
      expect(twdToUsdRate.toString(), equals('0.03'));

      final usdM = twdM.exchangeTo(twdToUsdRate);
      expect(usdM.toString(), equals(r'$30.00'));

      // final Currency usdExchange =
      //     Currency.create('USD', 6, pattern: 'S0.000000');

      final acurateTwdToUsdRate = ExchangeRate.fromMinorUnits(35231,
          scale: 6,
          fromCode: 'TWD',
          toCode: 'USD',
          toScale: 6); // 1 TWD = 0.035231 USD
      expect(acurateTwdToUsdRate.toString(), equals('0.035231'));

      expect(acurateTwdToUsdRate.format('0.00'), equals('0.03'));

      final usdMaccurate = twdM.exchangeTo(acurateTwdToUsdRate);
      expect(usdMaccurate.format('S#.000000'), equals(r'$35.231000'));
    });

    test('Exchange Rates - precision 2', () {
      //    final jpy = Currency.create('JPY', 0, symbol: '¥');
      final twd = Currency.create('TWD', 0, symbol: r'NT$');

      final twdM = Money.fromNumWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToJpyRate = ExchangeRate.fromMinorUnits(3,
          scale: 0, fromCode: 'TWD', toCode: 'JPY');
      expect(twdToJpyRate.toString(), equals('3'));

      final jpyM = twdM.exchangeTo(twdToJpyRate);
      expect(jpyM.toString(), equals('¥3000'));
    });

    test('rub', () {
      final price = Money.fromNum(28000, code: 'RUB');
      final rubToUsExchangeRate = ExchangeRate.fromNum(0.013445,
          scale: 6, fromCode: 'RUB', toCode: 'USD');
      expect(price.exchangeTo(rubToUsExchangeRate).format('###,###.## S'),
          equals(r'376.46 $'));
    });
  });
}
