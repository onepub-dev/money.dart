/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  Currencies().register(Currency.create('LONG', 2));

  final usd10d25 = Money.fromIntMinUnit(1025, code: 'USD');
  final usd10 = Money.fromIntMinUnit(1000, code: 'USD');
  final long1000d90 = Money.fromIntMinUnit(100090, code: 'LONG');
  final usd20cents = Money.fromIntMinUnit(20, code: 'USD');
  final btc1satoshi = Money.fromIntMinUnit(1, code: 'BTC');

  group('format', () {
    test('Simple Number', () {
      expect(usd10d25.toString(), equals(r'$10.25'));
      expect(usd10.format('#.#0'), equals('10.00'));
      expect(usd10d25.format('#'), equals('10'));
      expect(usd10d25.format('#.#'), equals('10.2'));
      expect(usd10d25.format('0.00'), equals('10.25'));
      expect(usd10d25.format('#,##0.##'), equals('10.25'));
      expect(long1000d90.format('#,##0.00'), equals('1,000.90'));
      expect(usd10d25.format('###,000.##'), equals('010.25'));
      expect(usd10d25.format('##.##'), equals('10.25'));
      expect(usd10d25.format('##'), equals('10'));
      expect(usd20cents.format('#,##0.00'), equals('0.20'));
      expect(btc1satoshi.format('0.00000000'), equals('0.00000001'));
    });

    test('Negative Number', () {
      expect((-usd10d25).toString(), equals(r'$-10.25'));
      expect((-usd10).format('#.#0'), equals('-10.00'));
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

    test('Inverted Decimal Separator', () {
      final eurolarge = Money.fromIntMinUnit(10000000, code: 'EUR');
      final euroSmall = Money.fromIntMinUnit(1099, code: 'EUR');
      expect(eurolarge.toString(), equals('100000,00€'));
      expect(euroSmall.format('S#'), equals('€10'));
      expect(euroSmall.format('#,#'), equals('10,9'));
      expect(euroSmall.format('CCC#,#0'), equals('EUR10,99'));
      expect(euroSmall.format('###.000,##'), equals('010,99'));
      expect(eurolarge.format('###.000,00'), equals('100.000,00'));
      expect(euroSmall.format('##,##'), equals('10,99'));
      expect(euroSmall.format('##'), equals('10'));
    });
    test('Lead zero USD', () {
      expect(Money.fromIntMinUnit(310, code: 'USD').format('000.00'),
          equals('003.10'));
      expect(Money.fromIntMinUnit(310, code: 'USD').format('000.##'),
          equals('003.1'));
      expect(Money.fromIntMinUnit(301, code: 'USD').format('000.00'),
          equals('003.01'));
      expect(Money.fromIntMinUnit(301, code: 'USD').format('000.##'),
          equals('003.01'));
      expect(usd10d25.format('000.##'), equals('010.25'));
      expect(usd10d25.format('000'), equals('010'));
    });

    test('trailing zero USD', () {
      expect(usd10d25.format('##.000'), equals('10.250'));
      expect(usd10d25.format('000'), equals('010'));
      expect(Money.fromIntMinUnit(301, code: 'USD').format('000.000'),
          equals('003.010'));
    });

    test('trailing zero when pattern have trailing symbol', () {
      final usdt = Currency.create('USDT', 2, pattern: '#,##0.## CCC');
      expect(
          Money.fromIntMinUnitWithCurrency(01, usdt).toString(), '0.01 USDT');
      expect(
          Money.fromIntMinUnitWithCurrency(301, usdt).toString(), '3.01 USDT');
      expect(
          Money.fromIntMinUnitWithCurrency(3010, usdt).toString(), '30.1 USDT');
      expect(Money.fromIntMinUnitWithCurrency(100, usdt).toString(), '1 USDT');
      expect(
          Money.fromIntMinUnitWithCurrency(1000, usdt).toString(), '10 USDT');
    });

    test('less than 10 cents USD in minor units', () {
      expect(Money.fromIntMinUnit(01, code: 'USD').toString(), r'$0.01');
      expect(Money.fromIntMinUnit(301, code: 'USD').toString(), r'$3.01');
      expect(Money.fromNum(3.01, code: 'USD').toString(), r'$3.01');
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

      final sendAmount = Money.fromIntMinUnitWithCurrency(123, cur1);
      Currencies().register(cur1);

      expect('$sendAmount', equals(r'$1.23'));

      final receiveCurrency = Currency.create('EXC', 8, pattern: 'S0.00000000');

      Currencies().register(receiveCurrency);

      final exchangeRate = ExchangeRate.fromMinorUnits(
        212345678,
        scale: 8,
        fromCode: 'CUR1',
        toCode: receiveCurrency.code,
      );
      expect('$exchangeRate', equals('2.12345678'));

      final receiveAmount = sendAmount.exchangeTo(exchangeRate);
      expect('$receiveAmount', equals(r'$2.61185184'));

      final exchangeTwoDigits = ExchangeRate.fromMinorUnits(100,
          scale: 2, fromCode: 'EXC', toCode: 'CUR1');

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
      expect(() => usd10d25.format('0.0#'),
          throwsA(const TypeMatcher<IllegalPatternException>()));
    });

    test('Pattern sizes', () {
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('0.01'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('0.10'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('1.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('10.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '0.00'))
              .toString(),
          equals('1000.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));

      expect(
          Money.fromIntMinUnitWithCurrency(
                  1, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.01'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('0.10'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('1.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('10.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 3, pattern: '0.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('100.00'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1000000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));

      expect(
          Money.fromIntMinUnitWithCurrency(
                  1000000, Currency.create('AU', 3, pattern: '#,000.00'))
              .toString(),
          equals('1,000.00'));
    });

    test('large patterns', () {
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('0.010000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('0.100000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('1.000000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  1000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('10.000000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  10000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('100.000000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '0.000000'))
              .toString(),
          equals('1000.000000'));
      expect(
          Money.fromIntMinUnitWithCurrency(
                  100000, Currency.create('AU', 2, pattern: '#,000.000000'))
              .toString(),
          equals('1,000.000000'));

      expect(
          Money.fromIntMinUnitWithCurrency(
                  35231, Currency.create('AU', 6, pattern: '#,##0.000000'))
              .toString(),
          equals('0.035231'));

      expect(
          Money.fromIntMinUnitWithCurrency(
                  35231, Currency.create('AU', 6, pattern: 'S0.000000'))
              .toString(),
          equals(r'$0.035231'));
    });
  });
}
