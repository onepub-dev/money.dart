/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  test('example 1', () {
    final t2 = Currency.create('BTC', 8, symbol: '₿', pattern: 'S0.########');

    expect(Money.parseWithCurrency('1', t2).toString(), equals('₿1'));
  });

  test('example 1', () {
    final usdCurrency = Currency.create('USD', 2);

// Create money from an int.
    final costPrice = Money.fromIntMinUnitWithCurrency(1000, usdCurrency);
    expect(costPrice.toString(), equals(r'$10.00'));

    final taxInclusive = costPrice * 1.1;
    expect(taxInclusive.toString(), equals(r'$11.00'));

    expect(taxInclusive.format('SCC #.00'), equals(r'$US 11.00'));

// Create money from an String using the `Currency` instance.
    final parsed = usdCurrency.parse(r'$10.00');
    expect(parsed.format('SCCC 0.00'), equals(r'$USD 10.00'));

// Create money from an int which contains the MajorUnit (e.g dollars)
    final buyPrice = Money.fromNum(10, code: 'AUD');
    expect(buyPrice.toString(), equals(r'$10.00'));

// Create money from a double which contains Major and Minor units
//  (e.g. dollars and cents)
// We don't recommend transporting money as a double as you will get
//    rounding errors.
    final sellPrice = Money.fromNum(10.50, code: 'AUD');
    expect(sellPrice.toString(), equals(r'$10.50'));
  });
}
