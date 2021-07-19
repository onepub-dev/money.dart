/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// import 'package:meta/meta.dart' show sealed, immutable;

import 'package:meta/meta.dart';
import 'currencies.dart';

import 'currency.dart';
import 'encoders.dart';
import 'minor_units.dart';
import 'money_data.dart';
import 'pattern_decoder.dart';
import 'pattern_encoder.dart';

/// Allows you to store, print and perform mathematically operations on money
/// whilst maintaining precision.
///
/// **NOTE: This is a value type, do not extend or re-implement it.**
///
/// The [Money] class works with the [Currency] class to provide a simple
///  means to define monetary values.
///
/// e.g.
///
/// ```dart
/// Currency aud = Currency.create('AUD', 2, pattern:r'$0.00');
/// Money costPrice = Money.fromInt(1000, aud);
/// costPrice.toString();
/// > $10.00
///
/// Money taxInclusive = costPrice * 1.1;
/// taxInclusive.toString();
/// > $11.00
///
/// taxInclusive.format('SCCC0.00');
/// > $AUD11.00
///
/// taxInclusive.format('SCCC0');
/// > $AUD11
/// ```
///
/// Money uses  [BigInt] internally to represent an amount in minorUnits
///  (e.g. cents)
///

// @sealed
@immutable
class Money implements Comparable<Money> {
  final MinorUnits _minorUnits;
  final Currency _currency;

  /// Returns the currency for this monetary amount.
  Currency get currency => _currency;

  /// Returns the underlying minorUnits
  /// for this monetary amount.
  /// e.g. $10.10 is returned as 1010
  BigInt get minorUnits => _minorUnits.toBigInt();

  /* Instantiation ************************************************************/

  /// ******************************************
  /// Money.from
  /// ******************************************

  /// Creates an instance of [Money] from a [num] holding the monetary value.
  /// Unlike [fromBigInt] the amount is in dollars and cents (not just cents).
  ///
  /// This means that you can intiate a Money value from a double or int
  /// as follows:
  /// ```dart
  /// Money buyPrice = Money.from(10);
  /// print(buyPrice.toString());
  ///  > $10.00
  /// Money sellPrice = Money.from(10.50);
  /// print(sellPrice.toString());
  ///  > $10.50
  /// ```
  /// NOTE: be very careful using doubles to transport money as you are
  /// guarenteed to get rounding errors!!!  You should use a [String]
  /// with [Money.parse()].
  ///
  /// [amount] - the monetary value.
  /// [code] - the currency code of the [amount]. This must be either one
  /// of the [CommonCurrencies] or a currency you have registered via [Currencies.register].
  ///
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.from(num amount, {required String code}) {
    final currency = Currencies().find(code);

    if (currency == null) throw UnknownCurrencyException(code);

    return Money.fromWithCurrency(amount, currency);
  }

  /// Creates an instance of [Money] from a num holding the monetary value.
  /// Unlike [fromBigInt] the amount is in dollars and cents (not just cents).
  /// This means that you can intiate a Money value from a double or int
  /// as follows:
  /// ```dart
  /// Money buyPrice = Money.from(10);
  /// print(buyPrice.toString());
  ///  > $10.00
  /// Money sellPrice = Money.from(10.50);
  /// print(sellPrice.toString());
  ///  > $10.50
  /// ```
  /// NOTE: be very careful using doubles to transport money as you are
  /// guarenteed to get rounding errors!!!  You should use a [String]
  /// with [Money.parse()].
  ///
  /// [amount] - the monetary value.
  /// [currency] - the currency code of the [amount].
  factory Money.fromWithCurrency(num amount, Currency currency) {
    final minorUnits = BigInt.from(
        (amount * currency.precisionFactor.toInt() + (amount >= 0 ? 0.5 : -0.5))
            .toInt());

    return Money._from(MinorUnits.from(minorUnits), currency);
  }

  /// ******************************************
  /// Money.fromBigInt
  /// ******************************************

  /// Creates an instance of [Money] from an amount represented by
  /// [minorUnits] which is in the minorUnits of the [currency], e.g (cents).
  ///
  /// e.g.
  /// USA dollars with 2 decimal places.
  ///
  /// final usd = Currency.create('USD', 2);
  ///
  /// 500 cents is $5 USD.
  /// let fiveDollars = Money.fromMinorUnits(BigInt.from(500), usd);
  ///
  /// [code] - the currency code of the [minorUnits]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.fromBigInt(BigInt minorUnits, {required String code}) {
    final currency = Currencies().find(code);
    if (currency == null) throw UnknownCurrencyException(code);

    return Money._from(MinorUnits.from(minorUnits), currency);
  }

  /// Creates an instance of [Money] from an amount represented by
  /// [minorUnits] which is in the minorUnits of the [currency], e.g (cents).
  ///
  /// e.g.
  /// USA dollars with 2 decimal places.
  ///
  /// final usd = Currency.create('USD', 2);
  ///
  /// 500 cents is $5 USD.
  /// let fiveDollars = Money.fromMinorUnits(BigInt.from(500), usd);
  ///
  factory Money.fromBigIntWitCurrency(BigInt minorUnits, Currency currency) {
    return Money._from(MinorUnits.from(minorUnits), currency);
  }

  /// ******************************************
  /// Money.fromInt
  /// ******************************************

  /// Creates an instance of [Money] from an integer.
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  /// [code] - the currency code of the [minorUnits]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  ///
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.fromInt(int minorUnits, {required String code}) {
    final currency = Currencies().find(code);
    if (currency == null) throw UnknownCurrencyException(code);

    return Money._from(MinorUnits.from(BigInt.from(minorUnits)), currency);
  }

  /// Creates an instance of [Money] from an integer.
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  factory Money.fromIntWithCurrency(int minorUnits, Currency currency) {
    return Money._from(MinorUnits.from(BigInt.from(minorUnits)), currency);
  }

  /// ******************************************
  /// Money.parse
  /// ******************************************

  ///
  /// Parses the passed [monetaryAmount] and returns a [Money] instance.
  ///
  /// The passed [monetaryAmount] must match the given [pattern] or
  /// if no pattern is supplied the the default pattern of the
  /// currency indicated by the [code].
  ///
  /// Throws an MoneyParseException if the [monetaryAmount] doesn't
  /// match the pattern.
  ///
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  ///
  /// [code] - the currency code of the [minorUnits]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  ///
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.parse(String monetaryAmount,
      {required String code, String? pattern}) {
    final currency = Currencies().find(code);
    if (currency == null) throw UnknownCurrencyException(code);

    pattern ??= currency.pattern;

    final decoder = PatternDecoder(currency, pattern);

    final data = decoder.decode(monetaryAmount);

    return Money._from(MinorUnits.from(data.minorUnits), currency);
  }

  ///
  /// Parses the passed [monetaryAmount] and returns a [Money] instance.
  ///
  /// The passed [monetaryAmount] must match the given [pattern] or
  /// if no pattern is supplied the the default pattern of the
  /// passed [currency].
  ///
  /// Throws an MoneyParseException if the [monetaryAmount] doesn't
  /// match the pattern.
  ///
  factory Money.parseWithCurrency(String monetaryAmount, Currency currency,
      {String? pattern}) {
    pattern ??= currency.pattern;

    final decoder = PatternDecoder(currency, pattern);

    final data = decoder.decode(monetaryAmount);

    return Money._from(MinorUnits.from(data.minorUnits), currency);
  }

  ///
  /// Converts a [Money] instance into a new [Money] instance with its [Currency]
  /// defined by the [exchangeRate].
  ///
  /// The current [Money] amount is multiplied by the exchange rate to arrive at the
  /// converted currency.
  ///
  /// e.g.
  /// US$0.68 = AU$1.00 * US$0.68
  ///
  /// Where US$0.68 is the exchange rate.
  ///
  ///
  /// In the below example we do the following conversion:
  /// $10.00 * 0.68 = $6.80
  ///
  /// To do the above conversion:
  /// ```dart
  /// Currency aud = Currency.create('AUD', 2);
  /// Currency usd = Currency.create('USD', 2);
  /// Money invoiceAmount = Money.fromInt(1000, aud);
  /// Money auToUsExchangeRate = Money.fromInt(68, usd);
  /// Money usdAmount = invoiceAmount.exchangeTo(auToUsExchangeRate);
  /// ```
  Money _exchangeTo(Money exchangeRate) {
    /// convertedUnits now has this.precision + exchangeRate.precision
    /// precision.
    var convertedUnits =
        _minorUnits.toBigInt() * exchangeRate._minorUnits.toBigInt();

    /// reduce minor digits back to the exchangeRates no. of minor digits
    final round = convertedUnits.isNegative ? -0.5 : 0.5;
    convertedUnits =
        BigInt.from((convertedUnits / _currency.precisionFactor) + round);

    return Money._from(MinorUnits.from(convertedUnits), exchangeRate._currency);
  }

  Money exchangeTo(String to) => _exchangeTo(Currencies().getExchangeRate(
    from: this._currency.code,
    to: to,
  ));

  // todo: Money exchangeToWithCurrency(Currency currency) => 

  /* Internal constructor *****************************************************/

  const Money._from(this._minorUnits, this._currency);

  ///
  /// Provides a simple means of formating a [Money] instance as a string.
  ///
  /// [pattern] supports the following characters
  ///   * S outputs the currencies symbol e.g. $.
  ///   * C outputs part of the currency symbol e.g. USD.
  /// You can specify 1,2 or 3 C's
  ///       * C - U
  ///       * CC - US
  ///       * CCC - USD - outputs the full currency code regardless of length.
  ///   * &#35; denotes a digit.
  ///   * 0 denotes a digit and with the addition of defining leading
  /// and trailing zeros.
  ///   * , (comma) a placeholder for the grouping separtor
  ///   * . (period) a place holder fo rthe decimal separator
  ///
  /// Note: if [Currency.invertSeparators] is true then the meaning of comma and period are swapped.
  ///
  /// Example:
  /// ```dart
  /// Currency aud = Currency.create('AUD', 2, pattern:r'$0.00');
  /// Money costPrice = Money.fromInt(1000, aud);
  /// costPrice.toString();
  /// > $10.00
  ///
  /// Money taxInclusive = costPrice * 1.1;
  /// taxInclusive.toString();
  /// > $11.00
  ///
  /// taxInclusive.format('SCCC0.00');
  /// > $AUD11.00
  ///
  /// taxInclusive.format('SCCC0');
  /// > $AUD11
  /// ```
  ///
  String format(String pattern) {
    return encodedBy(PatternEncoder(this, pattern));
  }

  @override
  String toString() {
    return encodedBy(PatternEncoder(this, _currency.pattern));
  }

  /* Encoding/Decoding ********************************************************/

  /// Returns a [Money] instance decoded from [value] by [decoder].
  ///
  /// Create your own [decoder]s to convert from any type to a [Money] instance.
  ///
  /// <T> - the type you are decoding from.
  ///
  /// Throws [FormatException] when the passed value contains an invalid format.
  // ignore: prefer_constructors_over_static_methods
  static Money decoding<T>(T value, MoneyDecoder<T> decoder) {
    final data = decoder.decode(value);

    return Money._from(MinorUnits.from(data.minorUnits), data.currency);
  }

  /// Encodes a [Money] instance as a <T>.
  ///
  /// Create your own encoders to convert a Money instance to
  /// any other type.

  /// You can use this to format a [Money] instance as a string.
  ///
  /// <T> - the type you want to encode the [Money]
  /// Returns this money representation encoded by [encoder].
  T encodedBy<T>(MoneyEncoder<T> encoder) {
    return encoder.encode(MoneyData.from(_minorUnits.toBigInt(), _currency));
  }

  /* Amount predicates ********************************************************/

  /// Returns `true` when amount of this money is zero.
  bool get isZero => _minorUnits.isZero;

  /// Returns `true` when amount of this money is negative.
  bool get isNegative => _minorUnits.isNegative;

  /// Returns `true` when amount of this money is positive (greater than zero).
  ///
  /// **TIP:** If you need to check that this value is zero or greater,
  /// use expression `!money.isNegative` instead.
  bool get isPositive => _minorUnits.isPositive;

  /* Hash Code ****************************************************************/

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _minorUnits.hashCode;
    result = 37 * result + _currency.hashCode;

    return result;
  }

  /* Comparison ***************************************************************/

  /// Returns `true` if this money value is in the specified [currency].
  bool isInCurrency(String code) => _currency == Currencies().find(code);
  bool isInCurrencyWithCurrency(Currency currency) => _currency == currency;

  /// Returns `true` if this money value is in same currency as [other].
  bool isInSameCurrencyAs(Money other) =>
      isInCurrencyWithCurrency(other._currency);

  /// Compares this to [other].
  ///
  /// [other] has to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  @override
  int compareTo(Money other) {
    _preconditionThatCurrencyTheSameFor(other);

    return _minorUnits.compareTo(other._minorUnits);
  }

  /// Returns `true` if [other] is the same amount of money in
  /// the same currency.
  @override
  bool operator ==(covariant Money other) =>
      identical(this, other) ||
      (isInSameCurrencyAs(other) && other._minorUnits == _minorUnits);

  /// Returns `true` when this money is less than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits < other._minorUnits;
  }

  /// Returns `true` when this money is less than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits <= other._minorUnits;
  }

  /// Returns `true` when this money is greater than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits > other._minorUnits;
  }

  /// Returns `true` when this money is greater than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits >= other._minorUnits;
  }

  /* Allocation ***************************************************************/

  /// Returns allocation of this money according to `ratios`.
  ///
  /// A value of the parameter [ratios] must be a non-empty list, with
  /// not negative values and sum of these values must be greater than zero.
  List<Money> allocationAccordingTo(List<int> ratios) =>
      _minorUnits.allocationAccordingTo(ratios).map(_withAmount).toList();

  /// Returns allocation of this money to N `targets`.
  ///
  /// A value of the parameter [targets] must be greater than zero.
  List<Money> allocationTo(int targets) {
    if (targets < 1) {
      throw ArgumentError.value(
          targets,
          'targets',
          'Number of targets must not be less than one, '
              'cannot allocate to nothing.');
    }

    return allocationAccordingTo(List<int>.filled(targets, 1));
  }

  /* Arithmetic ***************************************************************/

  /// Adds operands.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator +(Money summand) {
    _preconditionThatCurrencyTheSameFor(summand);

    return _withAmount(_minorUnits + summand._minorUnits);
  }

  /// unary minus operator.
  Money operator -() => _withAmount(-_minorUnits);

  /// Subtracts right operand from the left one.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator -(Money subtrahend) {
    _preconditionThatCurrencyTheSameFor(subtrahend);

    return _withAmount(_minorUnits - subtrahend._minorUnits);
  }

  /// Returns [Money] multiplied by [multiplier], using schoolbook rounding.
  Money operator *(num multiplier) {
    return _withAmount(_minorUnits * multiplier);
  }

  /// Returns [Money] divided by [divisor], using schoolbook rounding.
  Money operator /(num divisor) {
    return _withAmount(_minorUnits / divisor);
  }

  /// Divides this by [divisor] and returns the result as a double
  double dividedBy(Money divisor) {
    _preconditionThatCurrencyTheSameFor(divisor);
    return minorUnits.toDouble() / divisor.minorUnits.toDouble();
  }

  /* ************************************************************************ */

  /// Creates new instance with the same currency and given [amount].
  Money _withAmount(MinorUnits amount) => Money._from(amount, _currency);

  void _preconditionThatCurrencyTheSameFor(Money other,
      [String Function()? message]) {
    String defaultMessage() =>
        'Cannot operate with money values in different currencies.';

    if (!isInSameCurrencyAs(other)) {
      throw ArgumentError((message ?? defaultMessage)());
    }
  }
}

/// Exception thrown we a parse fails.
class MoneyParseException implements Exception {
  /// The error message
  String message;

  ///
  MoneyParseException(this.message);

  ///
  factory MoneyParseException.fromValue(
      String pattern, int i, String monetaryValue, int monetaryIndex) {
    final message = '''
monetaryValue contained an unexpected character '${monetaryValue[monetaryIndex]}' at pos $monetaryIndex 
        when a match for pattern character ${pattern[i]} at pos $i was expected.''';
    return MoneyParseException(message);
  }

  @override
  String toString() => message;
}
