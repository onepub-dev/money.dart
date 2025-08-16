/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:fixed/fixed.dart';
import 'package:money2/src/common_currencies.g.dart';
import 'package:money2/src/exceptions.dart';
import 'package:money2/src/money.dart';
import 'package:money2/src/pattern_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('pattern decoder unexpected minor units', ()  {
    final btc = CommonCurrencies().btc;
    final btcDecoder = PatternDecoder(btc, btc.pattern);

    var moneyData = btcDecoder.decode('₿1');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.decimalPart.toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100000000));

    moneyData = btcDecoder.decode('₿1.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));

    expect(moneyData.decimalPart.toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(119990000));

    moneyData = btcDecoder.decode('₿.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(0));

    expect(moneyData.getMinorUnits().toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(019990000));

    moneyData = btcDecoder.decode('₿0.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(0));

    expect(moneyData.getMinorUnits().toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(019990000));

    final euro = CommonCurrencies().euro;
    final euroDecoder = PatternDecoder(euro, euro.pattern);
    moneyData = euroDecoder.decode('1€');
    expect(moneyData.currency, equals(euro));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.decimalPart.toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100));

    moneyData = euroDecoder.decode('1,1999€');
    expect(moneyData.currency, equals(euro));
    expect(moneyData.integerPart.toInt(), equals(1));

    expect(moneyData.decimalPart.toInt(), equals(19));
    expect(moneyData.amount.minorUnits.toInt(), equals(119));
  });

  test('Optional Symbol', () {
    final btc = CommonCurrencies().btc;
    final btcDecoder = PatternDecoder(btc, btc.pattern);

    /// Missing Symbol
    final moneyData = btcDecoder.decode('₿1');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.decimalPart.toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100000000));
  });

  test('Optional isoCode', () {
    final btc = CommonCurrencies().btc;
    final btcDecoder = PatternDecoder(btc, 'CCC#.#');

    /// Missing isoCode
    expect(() => btcDecoder.decode('₿1'), throwsA(isA<MoneyParseException>()));
    final moneyData = btcDecoder.decode('1');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.decimalPart.toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100000000));
  });

  test('Optional isoCode and Symbol', () {
    final btc = CommonCurrencies().btc;
    final btcDecoder = PatternDecoder(btc, 'CCCS#.#');

    /// Missing Symbol
    final moneyData = btcDecoder.decode('₿1');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.decimalPart.toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100000000));

    final t2 = btcDecoder.decode('BTC₿1');
    expect(t2.currency, equals(btc));
    expect(t2.integerPart.toInt(), equals(1));
    expect(t2.decimalPart.toInt(), equals(0));
    expect(t2.amount.minorUnits.toInt(), equals(100000000));

    final t3 = btcDecoder.decode('1');
    expect(t3.currency, equals(btc));
    expect(t3.integerPart.toInt(), equals(1));
    expect(t3.decimalPart.toInt(), equals(0));
    expect(t3.amount.minorUnits.toInt(), equals(100000000));
  });

  test('More optional tests', () {
    expect(Money.parse('1.23', isoCode: 'USD', pattern: 'SCCC#.#').amount,
        equals(Fixed.parse('1.23')));
    expect(Money.parse(r'$12.34', isoCode: 'USD', pattern: 'SCCC#.#').amount,
        equals(Fixed.parse('12.34')));
    expect(Money.parse(r'$USD12.34', isoCode: 'USD', pattern: 'SCCC#.#').amount,
        equals(Fixed.parse('12.34')));
  });

  test('Issue #53', () {
    final money = Money.parseWithCurrency('₿1.99', CommonCurrencies().btc);
    expect(money.format('#.000'), '1.990');
  });
}
