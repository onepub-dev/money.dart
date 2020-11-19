/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:math';

import 'package:meta/meta.dart';

import 'money.dart';
import 'pattern_decoder.dart';

// import 'package:meta/meta.dart' show sealed, immutable;

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
/// [Currencies] class which then is able to provides a global directory of
/// [Currency] instances.
///
//@sealed
@immutable
class Currency {
  /// The code of the currency (e.g. 'USD').
  final String code;

  /// The currency symbol (e.g. $)
  final String symbol;

  /// The number of decimals for the currency (zero or more).
  final int minorDigits;

  /// The factor of 10 to divide a minor value by to get the intended
  /// currency value.
  ///  e.g. if minorDigits is 2 then this value will be 100.
  final BigInt minorDigitsFactor;

  /// the default pattern used to format and parse monetary amounts for this
  /// currency.
  final String pattern;

  /// Most western currencies use the period as the decimal separator
  /// and comma for formating.
  // Some other currencies invert the use of periods and commas.
  /// If this value is true the invert version is used.
  final bool invertSeparators;

  /// The character used for the decimal place
  final String decimalSeparator;

  /// The character used for the thousands separator.
  final String thousandSeparator;

  /// Creates a currency with a given [code] and [minorDigits].
  /// * [code] - the currency code e.g. USD
  /// * [minorDigits] - the number of digits after the decimal place the
  /// the currency uses. e.g. 2 for USD as it uses cents to 2 digits.
  /// * [pattern] - the default output format used when you call toString
  /// on a Money instance created with this currency. See [Money.format]
  /// for details on the supported patterns.
  /// * [inverSeparator] - normally the decimal separator is '.' and the
  /// thousands separator is ','. When this value is true (defaults to false)
  /// then the separators are swapped. This is needed for most non English
  /// speaking [Currency]s.
  Currency.create(this.code, this.minorDigits,
      {this.symbol = '\$',
      this.pattern = 'S0.00',
      this.invertSeparators = false})
      : minorDigitsFactor = Currency._calcMinorDigitsFactor(minorDigits),
        decimalSeparator = (invertSeparators ? ',' : '.'),
        thousandSeparator = (invertSeparators ? '.' : ',') {
    if (code.isEmpty) {
      throw ArgumentError.value(code, 'code', 'Must be a non-empty string.');
    }
  }

  ///
  /// Takes a monetary amount encoded as a string
  /// and converts it to a [Money] instance.
  /// You can pass in a [pattern] to define the
  /// format of the [monetaryAmount].
  /// If you don't pass in a [pattern] then the [Currency]s
  /// default pattern is used.
  ///
  /// Currency aud = Currency.create("AUD", 2);
  /// Money audAmount = aud.parse("10.50");
  ///
  /// A [MoneyParseException] is thrown if the [monetarAmount]
  /// doesn't match the [pattern].
  ///
  Money parse(String monetaryAmount, {String? pattern}) {
    pattern ??= this.pattern;
    var decoder = PatternDecoder(this, pattern);
    var moneyData = decoder.decode(monetaryAmount);

    return Money.fromBigInt(moneyData.minorUnits, this);
  }

  ///
  /// @deprecated - use [Money.parse]
  ///
  Money fromString(String monetaryAmount, {String? pattern}) {
    pattern ??= this.pattern;
    var decoder = PatternDecoder(this, pattern);
    var moneyData = decoder.decode(monetaryAmount);

    return Money.fromBigInt(moneyData.minorUnits, this);
  }

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is Currency &&
      code == other.code &&
      minorDigits == other.minorDigits;

  static BigInt _calcMinorDigitsFactor(int minorDigits) {
    if (minorDigits.isNegative) {
      throw ArgumentError.value(
          minorDigits, 'minorDigits', 'Must be a non-negative value.');
    }
    return BigInt.from(pow(10, minorDigits));
  }

  /// Takes a [majorUnits] and a [minorUnits] and returns
  /// a BigInt which represents the two combined values in
  /// [minorUnits].
  BigInt toMinorUnits(BigInt majorUnits, BigInt minorUnits) {
    return majorUnits * minorDigitsFactor + minorUnits;
  }
}
