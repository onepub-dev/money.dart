/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  Currencies().register(Currency.create('LONG', 2));

  final usd10d25 = Money.fromInt(1025, isoCode: 'USD');
  final usd10d5c = Money.fromInt(1005, isoCode: 'USD');
  final usd10 = Money.fromInt(1000, isoCode: 'USD');
  final long1000d90 = Money.fromInt(100090, isoCode: 'LONG');
  final used5M = Money.fromNum(5000000.90, isoCode: 'USD');
  final usd20cents = Money.fromInt(20, isoCode: 'USD');
  final btc1satoshi = Money.fromInt(1, isoCode: 'BTC');

  group('format', () {
    test('Simple Number', () {
      expect(usd10d25.toString(), equals(r'$10.25'));
      expect(usd10.format('#.0#'), equals('10.0'));
      expect(usd10d5c.format('#.0#'), equals('10.05'));
      expect(usd10d25.format('#'), equals('10'));
      expect(usd10d25.format('#.#'), equals('10.2'));
      expect(usd10d25.format('0.00'), equals('10.25'));
      expect(usd10d25.format('#,##0.##'), equals('10.25'));
      expect(used5M.format('###,##0.00'), equals('5,000,000.90'));
      expect(used5M.format('#,##0.00'), equals('5,000,000.90'));
      expect(long1000d90.format('#,##0.00'), equals('1,000.90'));
      expect(usd10d25.format('###,000.##'), equals('010.25'));
      expect(usd10d25.format('##.##'), equals('10.25'));
      expect(usd10d25.format('##'), equals('10'));
      expect(usd20cents.format('#,##0.00'), equals('0.20'));
      expect(btc1satoshi.format('0.00000000'), equals('0.00000001'));
    });

    test('Negative Number', () {
      expect((-usd10d25).format('#'), equals('-10'));
      expect((-usd10d25).format('#.#'), equals('-10.2'));
      expect((-usd10d25).format('0.00'), equals('-10.25'));
      expect((-usd10d25).format('#,##0.##'), equals('-10.25'));
      expect((-long1000d90).format('#,##0.00'), equals('-1,000.90'));
      expect((-usd10d25).format('###,000.##'), equals('-010.25'));
      expect((-usd10d25).format('##.##'), equals('-10.25'));
      expect((-usd10d25).format('##'), equals('-10'));
      expect((-usd20cents).format('#,##0.00'), equals('-0.20'));
      expect((-usd20cents).format('S#,##0.00'), equals(r'$-0.20'));
    });

    test('Trailing Negative', () {
      expect((-usd10d25).format('#-'), equals('10-'));
      expect((-usd10d25).format('#.#-'), equals('10.2-'));
      expect((-usd10d25).format('0.00-'), equals('10.25-'));
      expect((-usd10d25).format('#,##0.##-'), equals('10.25-'));
      expect((-long1000d90).format('#,##0.00-'), equals('1,000.90-'));
      expect((-usd10d25).format('###,000.##-'), equals('010.25-'));
      expect((-usd10d25).format('##.##-'), equals('10.25-'));
      expect((-usd10d25).format('##-'), equals('10-'));
      expect((-usd20cents).format('#,##0.00-'), equals('0.20-'));
      expect((-usd20cents).format('S#,##0.00-'), equals(r'$0.20-'));
    });

    test('Plus Pattern', () {
      expect(usd10d25.format('+#.0#'), equals('+10.25'));
      expect(usd10.format('+#.0#'), equals('+10.0'));
      expect(usd10d5c.format('+#.0#'), equals('+10.05'));
      expect((-usd10d25).format('+#'), equals('-10'));
      expect((-usd10d25).format('+#.#'), equals('-10.2'));
      expect((-usd10d25).format('+0.00'), equals('-10.25'));
      expect((-usd10d25).format('+#,##0.##'), equals('-10.25'));
      expect((-long1000d90).format('+#,##0.00'), equals('-1,000.90'));
      expect((-usd10d25).format('+###,000.##'), equals('-010.25'));
      expect((-usd10d25).format('+##.##'), equals('-10.25'));
      expect((-usd10d25).format('+##'), equals('-10'));
      expect((-usd20cents).format('+#,##0.00'), equals('-0.20'));
      expect((-usd20cents).format('S+#,##0.00'), equals(r'$-0.20'));
    });

    test('Trailing Plus Pattern', () {
      expect(usd10d25.format('#.0#+'), equals('10.25+'));
      expect(usd10.format('#.0#+'), equals('10.0+'));
      expect(usd10d5c.format('+#.0#+'), equals('+10.05+'));
      expect((-usd10d25).format('#+'), equals('10-'));
      expect((-usd10d25).format('#.#+'), equals('10.2-'));
      expect((-usd10d25).format('0.00+'), equals('10.25-'));
      expect((-usd10d25).format('#,##0.##+'), equals('10.25-'));
      expect((-long1000d90).format('#,##0.00+'), equals('1,000.90-'));
      expect((-usd10d25).format('###,000.##+'), equals('010.25-'));
      expect((-usd10d25).format('##.##+'), equals('10.25-'));
      expect((-usd10d25).format('##+'), equals('10-'));
      expect((-usd20cents).format('#,##0.00+'), equals('0.20-'));
      expect((-usd20cents).format('S#,##0.00+'), equals(r'$0.20-'));
    });

    test('Inverted Decimal Separator', () {
      final eurolarge = Money.fromInt(10000000, isoCode: 'EUR');
      final euroSmall = Money.fromInt(1099, isoCode: 'EUR');
      expect(eurolarge.toString(), equals('100.000,00€'));
      expect(euroSmall.format('S#'), equals('€10'));
      expect(euroSmall.format('#.#'), equals('10,9'));
      expect(euroSmall.format('CCC#.0#'), equals('EUR10,99'));
      expect(euroSmall.format('###,000.##'), equals('010,99'));
      expect(eurolarge.format('###,000.00'), equals('100.000,00'));
      expect(euroSmall.format('##.##'), equals('10,99'));
      expect(euroSmall.format('##'), equals('10'));
    });

    test('Custom Separators', () {
      final test = Currency.create('TEST', 3,
          groupSeparator: 'g',
          decimalSeparator: 'd',
          symbol: 'T',
          pattern: 'S###,###.000');
      Currencies().register(test);
      final eurolarge = Money.fromInt(100000000, isoCode: 'TEST');
      final euroSmall = Money.fromInt(10999, isoCode: 'TEST');
      expect(eurolarge.toString(), equals('T100g000d000'));
      expect(euroSmall.format('S#'), equals('T10'));
      expect(euroSmall.format('#.#'), equals('10d9'));
      expect(euroSmall.format('CCC#.0##'), equals('TEST10d999'));
      expect(euroSmall.format('###,000.###'), equals('010d999'));
      expect(eurolarge.format('###,000.000'), equals('100g000d000'));
      expect(euroSmall.format('##.###'), equals('10d999'));
      expect(euroSmall.format('##'), equals('10'));
    });

    test('decimal separator as slash', () {
      final euroCurrency = Currency.create('EUR', 2,
          decimalSeparator: '/',
          groupSeparator: ' ',
          symbol: '€',
          pattern: '#,###,###.##S');

      final amount =
          Money.fromIntWithCurrency(1234567890, euroCurrency, decimalDigits: 3);
      final formatted = amount.toString();
      expect(formatted, '1 234 567/89€');
    });

    test('Lead zero USD', () {
      expect(Money.fromInt(310, isoCode: 'USD').format('000.00'),
          equals('003.10'));
      expect(
          Money.fromInt(310, isoCode: 'USD').format('000.##'), equals('003.1'));
      expect(Money.fromInt(301, isoCode: 'USD').format('000.00'),
          equals('003.01'));
      expect(Money.fromInt(301, isoCode: 'USD').format('000.##'),
          equals('003.01'));
      expect(usd10d25.format('000.##'), equals('010.25'));
      expect(usd10d25.format('000'), equals('010'));
    });

    test('trailing zero USD', () {
      expect(usd10d25.format('##.000'), equals('10.250'));
      expect(usd10d25.format('000'), equals('010'));
      expect(Money.fromInt(301, isoCode: 'USD').format('000.000'),
          equals('003.010'));
    });

    test('trailing zero when pattern have trailing symbol', () {
      final usdt = Currency.create('USDT', 2, pattern: '#,##0.## CCC');
      expect(Money.fromIntWithCurrency(01, usdt).toString(), '0.01 USDT');
      expect(Money.fromIntWithCurrency(301, usdt).toString(), '3.01 USDT');
      expect(Money.fromIntWithCurrency(3010, usdt).toString(), '30.1 USDT');
      expect(Money.fromIntWithCurrency(100, usdt).toString(), '1 USDT');
      expect(Money.fromIntWithCurrency(1000, usdt).toString(), '10 USDT');
    });

    test('less than 10 cents USD in minor units', () {
      expect(Money.fromInt(01, isoCode: 'USD').toString(), r'$0.01');
      expect(Money.fromInt(301, isoCode: 'USD').toString(), r'$3.01');
      expect(Money.fromNum(3.01, isoCode: 'USD').toString(), r'$3.01');
    });

    test('Symbol tests', () {
      expect(usd10d25.format('S##.##'), equals(r'$10.25'));
      expect(usd10.format('S##.00'), equals(r'$10.00'));
      expect(usd10.format('##.00 S'), equals(r'10.00 $'));
      expect(usd10d25.format('S##'), equals(r'$10'));
      expect(usd10d25.format('S##'), equals(r'$10'));
      expect(usd10d25.format('S ##'), equals(r'$ 10'));
      expect(usd10d25.format('## S'), equals(r'10 $'));
    });

    test('Currency tests', () {
      expect(usd10d25.format('C##.##'), equals('U10.25'));
      expect(usd10d25.format('CC##.##'), equals('US10.25'));
      expect(usd10d25.format('CCC##.##'), equals('USD10.25'));
      expect(usd10d25.format('##.##CCC'), equals('10.25USD'));
      expect(usd10d25.format('##.## CCC'), equals('10.25 USD'));
      expect(long1000d90.format('CCC S#,###.00'), equals(r'LONG $1,000.90'));
    });

    test('USD combos', () {
      expect(usd10d25.format('SCCC 000,000.##'), equals(r'$USD 000,010.25'));
      expect(usd10d25.format('CCC S##.##'), equals(r'USD $10.25'));
      expect(usd10d25.format('S ##.## CCC'), equals(r'$ 10.25 USD'));
    });

    test('Exchange rates', () {
      final cur1 = Currency.create('CUR1', 2);

      final sendAmount = Money.fromIntWithCurrency(123, cur1);
      Currencies().register(cur1);

      expect('$sendAmount', equals(r'$1.23'));

      final receiveCurrency = Currency.create('EXC', 8, pattern: 'S0.00000000');

      Currencies().register(receiveCurrency);

      final exchangeRate = ExchangeRate.fromMinorUnits(
        212345678,
        decimalDigits: 8,
        fromIsoCode: 'CUR1',
        toIsoCode: receiveCurrency.isoCode,
      );
      expect('$exchangeRate', equals('2.12345678'));

      final receiveAmount = sendAmount.exchangeTo(exchangeRate);
      expect('$receiveAmount', equals(r'$2.61185184'));

      final exchangeTwoDigits = ExchangeRate.fromMinorUnits(100,
          decimalDigits: 2, fromIsoCode: 'EXC', toIsoCode: 'CUR1');

      final receiveAmountTwoDigits =
          receiveAmount.exchangeTo(exchangeTwoDigits);
      expect('$receiveAmountTwoDigits', equals(r'$2.61'));
    });

    test('Invalid Patterns', () {
      expect(() => usd10d25.format('0##'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('000,'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('000#'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('0#'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('0.#0'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
    });

    test('Pattern sizes', () {
      expect(
          Money.fromIntWithCurrency(
                  1, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('0.01'));
      expect(
          Money.fromIntWithCurrency(
                  10, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('0.10'));
      expect(
          Money.fromIntWithCurrency(
                  100, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('1.00'));
      expect(
          Money.fromIntWithCurrency(
                  1000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('10.00'));
      expect(
          Money.fromIntWithCurrency(
                  10000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('1000.00'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));

      expect(
          Money.fromIntWithCurrency(
                  1, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.00'));
      expect(
          Money.fromIntWithCurrency(
                  10, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.01'));
      expect(
          Money.fromIntWithCurrency(
                  100, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.10'));
      expect(
          Money.fromIntWithCurrency(
                  1000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('1.00'));
      expect(
          Money.fromIntWithCurrency(
                  10000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('10.00'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntWithCurrency(
                  1000000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));

      expect(
          Money.fromIntWithCurrency(
                  1000000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));
    });

    test('large patterns', () {
      expect(
          Money.fromIntWithCurrency(
                  1, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('0.010000'));
      expect(
          Money.fromIntWithCurrency(
                  10, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('0.100000'));
      expect(
          Money.fromIntWithCurrency(
                  100, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('1.000000'));
      expect(
          Money.fromIntWithCurrency(
                  1000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('10.000000'));
      expect(
          Money.fromIntWithCurrency(
                  10000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('100.000000'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('1000.000000'));
      expect(
          Money.fromIntWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '#,000.000000'))
              .toString(),
          equals('1,000.000000'));

      expect(
          Money.fromIntWithCurrency(
                  35231, Currency.create('AU', 6, pattern: '#,##0.000000'))
              .toString(),
          equals('0.035231'));

      expect(
          Money.fromIntWithCurrency(
                  35231, Currency.create('AU', 6, pattern: 'S0.000000'))
              .toString(),
          equals(r'$0.035231'));
    });

    test('group separators', () {
      // none
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#'))
              .toString(),
          equals('31234567'));

      // leading
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: ',###'))
              .toString(),
          equals('31,234,567'));

      // indian
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '##,###'))
              .toString(),
          equals('3,12,34,567'));

      // single
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,#,###'))
              .toString(),
          equals('3,1,2,3,4,567'));
      // default
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,###'))
              .toString(),
          equals('31,234,567'));
    });
    test('space', () {
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: 'S #,###.##'))
              .toString(),
          equals(r'$ 31,234,567'));

      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: 'C #,###.##'))
              .toString(),
          equals('A 31,234,567'));

      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AUD', 6, pattern: 'CCC #,###.##'))
              .toString(),
          equals('AUD 31,234,567'));

      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,###.## S'))
              .toString(),
          equals(r'31,234,567 $'));

      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,###.## C'))
              .toString(),
          equals('31,234,567 A'));

      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AUD', 6, pattern: '#,###.## CCC'))
              .toString(),
          equals('31,234,567 AUD'));

      expect(
          Money.fromIntWithCurrency(
                  33900000,
                  decimalDigits: 0,
                  Currency.create('AUD', 0, pattern: r'$#,###'))
              .toString(),
          equals(r'$33,900,000'));

      expect(
          Money.fromIntWithCurrency(
                  33900000, decimalDigits: 0, CommonCurrencies().usd)
              .toString(),
          equals(r'$33,900,000.00'));
    });
  });
}
