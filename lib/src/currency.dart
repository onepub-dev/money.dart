/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:math';

import 'package:meta/meta.dart';

import '../money2.dart';
import 'pattern_decoder.dart';

/// Allows you to create a [Currency] which is then used to construct
/// [Money] instances.
///
/// **NOTE: This is a value type, do not extend or re-implement it.**
///
/// Money2 does not create a default set of currencies instead you need
/// to explicitly create each currency type you want to use.
///
/// Normally you create one global currency instance for each currency type.
/// If you wish you can register each [Currency] instance with the
/// [CommonCurrencies] class which then is able to provides a global
/// directory of [Currency] instances.
///
//@sealed
@immutable
class Currency {
  /// Creates a currency with a given [code] and [scale].
  ///
  /// * [code] - the currency code e.g. USD
  /// * [scale] - the number of digits after the decimal place the
  /// the currency uses. e.g. 2 for USD as it uses cents to 2 digits.
  /// * [pattern] - the default output format used when you call toString
  /// on a Money instance created with this currency. See [Money.format]
  /// for details on the supported patterns.
  /// * [invertSeparators] - normally the decimal separator is '.' and the
  /// group separator is ','. When this value is true (defaults to false)
  /// then the separators are swapped. This is needed for most non English
  /// speaking [Currency]s.
  Currency.create(this.code, this.scale,
      {this.symbol = r'$', // TODO remove this imperialist proselitism
      this.pattern = defaultPattern,
      this.invertSeparators = false,
      this.country = '',
      this.unit = '',
      this.name = ''})
      : scaleFactor = Currency._calcPrecisionFactor(scale),
        decimalSeparator = invertSeparators ? ',' : '.',
        groupSeparator = invertSeparators ? '.' : ',' {
    if (code.isEmpty) {
      throw ArgumentError.value(code, 'code', 'Must be a non-empty string.');
    }
  }
  static const String defaultPattern = 'S0.00';

  /// Creates a [Currency] from an existing [Currency] with changes.
  Currency copyWith({
    String? code,
    int? precision,
    String? symbol,
    String? pattern,
    bool? invertSeparators,
  }) =>
      Currency.create(code ?? this.code, precision ?? scale,
          symbol: symbol ?? this.symbol,
          pattern: pattern ?? this.pattern,
          invertSeparators: invertSeparators ?? this.invertSeparators);

  /// Takes a monetary amount encoded as a string
  /// and converts it to a [Money] instance.
  ///
  /// You can pass in a [pattern] to define the
  /// format of the [monetaryAmount].
  /// If you don't pass in a [pattern] then the [Currency]s
  /// default pattern is used.
  ///
  /// If the number of minorUnits in [monetaryAmount]
  /// exceeds the [Currency]s precision then excess digits will be ignored.
  ///
  /// Currency aud = Currency.create('AUD', 2);
  /// Money audAmount = aud.parse('10.50');
  ///
  /// A [MoneyParseException] is thrown if the [monetaryAmount]
  /// doesn't match the [pattern].
  ///
  Money parse(String monetaryAmount, {String? pattern}) {
    if (monetaryAmount.isEmpty) {
      throw MoneyParseException('Empty monetaryAmount passed.');
    }
    pattern ??= this.pattern;
    final decoder = PatternDecoder(this, pattern);
    final moneyData = decoder.decode(monetaryAmount);

    return Money.fromFixedWithCurrency(moneyData.amount, this);
  }

  /// The code of the currency (e.g. 'USD').
  final String code;

  /// The currency symbol (e.g. $)
  final String symbol;

  /// The number of decimals for the currency (zero or more).
  final int scale;

  /// The factor of 10 to divide a minor value by to get the intended
  /// currency value.
  ///
  ///  e.g. if [scale] is 2 then this value will be 100.
  final BigInt scaleFactor;

  /// the default pattern used to format and parse monetary amounts for this
  /// currency.
  final String pattern;

  /// Full name of the currency. e.g. Australian Dollar
  final String
      country; // TODO prefer a broader geographic notion, e.g. territory

  /// The major units of the currency. e.g. 'Dollar'
  final String unit;

  /// The name of the currency. e.g. Australian Dollar
  final String name;

  /// Most western currencies use the period as the decimal separator
  /// and comma for formating.
  ///
  // Some other currencies invert the use of periods and commas.
  /// If this value is true then the use of the period and comma is swapped.
  final bool invertSeparators;

  /// The character used for the decimal place
  final String decimalSeparator;

  /// The character used for the group separator.
  final String groupSeparator;

  @override
  int get hashCode => code.hashCode;

  /// Two currencies are considered equivalent if the
  /// [code] and [scale] are the same.
  ///
  /// Are we breaking the semantics of the == operator?
  /// Maybe we need another method that just compares the code?
  @override
  bool operator ==(covariant Currency other) =>
      identical(this, other) || (code == other.code && scale == other.scale);

  static BigInt _calcPrecisionFactor(int precision) {
    if (precision.isNegative) {
      throw ArgumentError.value(
          precision, 'precision', 'Must be a non-negative value.');
    }
    return BigInt.from(pow(10, precision));
  }

  /// Takes a [majorUnits] and a [minorUnits] and returns
  /// a BigInt which represents the two combined values in
  /// [minorUnits].
  BigInt toMinorUnits(BigInt majorUnits, BigInt minorUnits) =>
      majorUnits * scaleFactor + minorUnits;
}
