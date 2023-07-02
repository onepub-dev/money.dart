/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:decimal/decimal.dart';
import 'package:money2/money2.dart';
// ignore_for_file: avoid_print

void main() {
  /// Create money from Fixed amount

  final fixed = Fixed.fromInt(100);
  Money.parse('1.23', code: 'AUD');

  Money.fromFixed(fixed, code: 'AUD');

  Money.fromDecimal(Decimal.parse('1.23'), code: 'EUR');

  ///
  /// Create a money which stores $USD 10.00
  ///
  /// Note: we use the minor unit (e.g. cents) when passing in the
  ///   monetary value.
  /// So $10.00 is 1000 cents.
  ///
  final costPrice = Money.fromIntMinUnit(1000, code: 'USD');

  print(costPrice);
  // > $10.00

  ///
  /// Create a [Money] instance from a String
  /// using [Currency.parse]
  /// The [Currency] of salePrice is USD.
  ///
  final salePrice = CommonCurrencies().usd.parse(r'$10.50');
  print(salePrice.format('SCC 0.0'));
  // > $US 10.50

  ///
  /// Create a [Money] instance from a String
  /// using [Money.parse]
  ///
  final taxPrice = Money.parse(r'$1.50', code: 'USD');
  print(taxPrice.format('CC 0.0 S'));
  // > US 1.50 $

  ///
  /// Create a [Money] instance from a String
  /// with an embedded Currency Code
  /// using [Currencies.parse]
  ///
  /// Create a custom currency
  /// USD currency uses 2 decimals, we need 3.
  ///
  final usd = Currency.create('USD', 3);

  final cheapIPhone = Currencies().parse(r'$USD1500.0', pattern: 'SCCC0.0');
  print(cheapIPhone.format('SCC0.0'));
  // > $US1500.00

  final expensiveIPhone = Currencies().parse(r'$AUD2000.0', pattern: 'SCCC0.0');
  print(expensiveIPhone.format('SCC0.0'));
  // > $AUD2000.00

  /// Register a non-common currency (dogecoin)
  Currencies().register(Currency.create('DODGE', 5, symbol: 'Ð'));
  final dodge = Currencies().find('DODGE');
  Money.fromNumWithCurrency(0.1123, dodge!);
  Money.fromNum(0.1123, code: 'DODGE');

  ///
  /// Do some maths
  ///
  final taxInclusive = costPrice * 1.1;

  ///
  /// Output the result using the default format.
  ///
  print(taxInclusive);
  // > $11.00

  ///
  /// Do some custom formatting of the ouput
  /// S - the symbol e.g. $
  /// CC - first two digits of the currency code provided when creating
  ///     the currency.
  /// # - a digit if required
  /// 0 - a digit or the zero character as padding.
  print(taxInclusive.format('SCC #.00'));
  // > $US 11.00

  ///
  /// Explicitly define the symbol and the default pattern to be used
  ///    when calling [Money.toString()]
  ///
  /// JPY - code for japenese yen.
  /// 0 - the number of minor units (e.g cents) used by the currency.
  ///     The yen has no minor units.
  /// ¥ - currency symbol for the yen
  /// S0 - the default pattern for [Money.toString()].
  ///      S output the symbol.
  ///      0 - force at least a single digit in the output.
  ///
  final jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');
  final jpyMoney = Money.fromIntMinUnitWithCurrency(500, jpy);
  print(jpyMoney);
  // > ¥500

  ///
  /// Define a currency that has inverted separators.
  /// i.e. The USD uses '.' for the integer/fractional separator
  ///      and ',' for the group separator.
  ///      -> 1,000.00
  /// The EURO use ',' for the integer/fractional separator
  ///      and '.' for the group separator.
  ///      -> 1.000,00
  ///
  final euro = Currency.create('EUR', 2,
      symbol: '€', invertSeparators: true, pattern: '#.##0,00 S');

  final bmwPrice = Money.fromIntMinUnitWithCurrency(10025090, euro);
  print(bmwPrice);
  // > 100.250,90 €

  ///
  /// Formatting examples
  ///
  ///

  // 100,345.30 usd
  final teslaPrice = Money.fromIntMinUnit(10034530, code: 'USD');

  print(teslaPrice.format('###,###'));
  // > 100,345

  print(teslaPrice.format('S###,###.##'));
  // > $100,345.3

  print(teslaPrice.format('CC###,###.#0'));
  // > US100,345.30

  // 100,345.30 EUR
  final euroCostPrice = Money.fromIntMinUnit(10034530, code: 'EUR');
  print(euroCostPrice.format('###.###'));
  // > 100.345

  print(euroCostPrice.format('###.###,## S'));
  // > 100.345,3 €

  print(euroCostPrice.format('###.###,#0 CC'));
  // > 100.345,30 EU

  ///
  /// Make the currencies available globally by registering them
  ///     with the [Currencies] singleton factory.
  ///
  Currencies().register(usd);
  Currencies().register(euro);
  Currencies().register(jpy);

  // use a registered currency by finding it in the registry using
  // the currency code that the currency was created with.
  final usDollar = Currencies().find('USD');

  final invoicePrice = Money.fromIntMinUnitWithCurrency(1000, usDollar!);

  ///
  print(invoicePrice.format('SCCC 0.00'));
  // $USD 10.00

  // Do some maths
  final taxInclusivePrice = invoicePrice * 1.1;
  print(taxInclusivePrice);
  // $11.00

  print(taxInclusivePrice.format('SCC 0.00'));
  // $US 11.00

  // retrieve all registered currencies
  final registeredCurrencies = Currencies().getRegistered();
  final codes = registeredCurrencies.map((c) => c.code);
  print(codes);
  // (USD, AUD, EUR, JPY)
}
