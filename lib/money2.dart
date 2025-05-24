/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

/// Money2 stores, parses, formats and allows precision mathematical operations
/// on monetary amounts and their associated currency.
///
///
/// The [Currency] class allows you to define the key attributes of a currency
/// such as Symbol, isoCode, precision and a default format.
///
/// The [Money] class stores the underlying values using a BigInt. The value
/// is stored using the currencies 'minor' units (e.g. cents).
///
/// This allows for precise calculations as required when handling money.
///
/// The [ExchangePlatform] allows you to set up a table of exchange rates
/// for converting between currencies.
///
/// Key features of Money2:
/// * simple and expressive formating.
/// * simple parsing of monetary amounts.
/// * multi-currency support.
/// * intuitive maths operations.
/// * fixed precision storage to ensure precise calcuation.
/// * detailed documentation and extensive examples to get you up and running.
/// * pure dart implementation.
/// * Open Source MIT license.
/// * Using Money2 will make you taller.
///
/// The package use the following terms:
/// * Minor Units - the smallest unit of a currency e.g. cents.
/// * Major Units - the integer component of a currency - e.g. dollars
/// * isoCode - the currency isoCode. e.g. USD
/// * symbol - the currency symbol. e.g. '$'. It should be noted that not
///    every currency has a symbol.
/// * pattern - a pattern used to control the display format.
/// * precision - the number of decimal places assumed when a minor unit value
///      (e.g. cents) is passed.
/// * decimal separator - the character that separates the fraction part
///    from the integer of a number e.g. '10.99'. This defaults to '.'
///    but can be changed to ','
/// * group separator - the character that is used to format
///   groups (e.g. 100,000). This can be changed to '.'
///
///  Using the [Money] and [Currency] classes is easy.
///
/// ```dart
/// import 'money2.dart';
/// Currency aud = Currency.create('AUD', 2, pattern:r'$0.00');
/// Money costPrice = Money.fromInt(1000, aud);
/// print(costPrice.toString());
///   > $10.00
///
/// Money spareChange = Money.parse('$10.50', aud);
///
/// Money lunchMoney = aud.parse('$11.50');
///
/// Money taxInclusive = costPrice * 1.1;
/// print(taxInclusive.toString());
///   > $11.00
///
/// print(taxInclusive.format('SCCC0.00'));
///   > $AUD11.00
///
/// print(taxInclusive.format('SCCC0'));
///   > $AUD11
/// ```

library;

import 'src/currency.dart';
import 'src/exchange_rates/exchange_platform.dart';
import 'src/money.dart';

export 'package:fixed/fixed.dart';

export 'src/common_currencies.g.dart';
export 'src/currencies.dart';
export 'src/currency.dart';
export 'src/encoders.dart';
export 'src/exceptions.dart';
export 'src/exchange_rates/exchange_platform.dart';
export 'src/exchange_rates/exchange_rate.dart';
export 'src/money.dart';
export 'src/money_data.dart';
export 'src/percentage.dart';
