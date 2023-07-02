/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// import 'package:meta/meta.dart' show sealed, immutable;

import 'package:decimal/decimal.dart';
import 'package:fixed/fixed.dart';
import 'package:meta/meta.dart';

import 'common_currencies.dart';
import 'currencies.dart';
import 'currency.dart';
import 'encoders.dart';
import 'exchange_rates/exchange_rate.dart';
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
  /* Internal constructor *****************************************************/
  const Money._from(this.amount, this.currency);
  /* Instantiation ************************************************************/

  /// ******************************************
  /// Money.from
  /// ******************************************

  /// Creates an instance of [Money] from a [num] holding the monetary value.
  /// Unlike [Money.fromBigIntMinUnit] the amount is in dollars and cents
  ///   (not just cents).
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
  /// of the [CommonCurrencies] or a currency you have registered
  /// via [Currencies.register].
  /// If the [scale] is provided then the [Money] instance is created with the
  /// supplied [scale]. If [scale] isn't provided then the scale
  /// from the [Currency]
  /// associated with the [code]
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.fromNum(num amount, {required String code, int? scale}) {
    final currency = Currencies().find(code);

    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromNumWithCurrency(amount, currency,
        scale: scale ?? currency.scale);
  }

  /// Creates an instance of [Money] from a num holding the monetary value.
  ///
  /// Unlike [Money.fromBigIntMinUnit] the amount is in dollars and cents
  ///   (not just cents).
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
  factory Money.fromNumWithCurrency(num amount, Currency currency,
          {int? scale}) =>
      Money._from(
          Fixed.fromNum(amount, scale: scale ?? currency.scale), currency);

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
  /// let fiveDollars = Money.fromBigInt(BigInt.from(500), usd);
  ///
  /// [code] - the currency code of the [minorUnits]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.fromBigIntMinUnit(BigInt minorUnits,
      {required String code, int? scale}) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromBigIntMinUnitWithCurrency(minorUnits, currency,
        scale: scale);
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
  /// let fiveDollars = Money.fromBigIntWithCurrency(BigInt.from(500), usd);
  ///
  factory Money.fromBigIntMinUnitWithCurrency(
          BigInt minorUnits, Currency currency, {int? scale}) =>
      Money._from(Fixed.fromBigInt(minorUnits, scale: scale ?? currency.scale),
          currency);

  /// ******************************************
  /// Money.fromInteger
  /// ******************************************

  /// Creates an instance of [Money] from an integer.
  /// And I mean real int, not a confusing minorUnit punk *** convertor
  /// [code] - the currency code of the [minorUnits]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.fromInteger(int val, {required String code}) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromIntegerWithCurrency(val, currency);
  }

  /// Creates an instance of [Money] from an integer.
  /// The amount passed is like in real life
  /// When I need 2 dollars, I mean 2 and not 200
  /// So just use 2
  factory Money.fromIntegerWithCurrency(int val, Currency currency) =>
      // reverting the computation to keep money from int simple
      Money._from(
          Fixed.fromInt(val * BigInt.from(10).pow(currency.scale).toInt()),
          currency);

  ///
  /// ******************************************
  /// Money.fromIntMinUnit
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
  factory Money.fromIntMinUnit(int minorUnits,
      {required String code, int? scale}) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromIntMinUnitWithCurrency(minorUnits, currency, scale: scale);
  }

  /// Creates an instance of [Money] from an integer.
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  factory Money.fromIntMinUnitWithCurrency(int minorUnits, Currency currency,
          {int? scale}) =>
      Money._from(
          Fixed.fromInt(minorUnits, scale: scale ?? currency.scale), currency);

  /// Creates a Money from a [Fixed] [amount].
  ///
  /// The [amount] is scaled to match the currency selected via
  /// [code].
  /// If [code] isn't a valid currency then an [UnknownCurrencyException]
  /// is thrown.
  factory Money.fromFixed(Fixed amount, {required String code, int? scale}) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromFixedWithCurrency(amount, currency, scale: scale);
  }

  /// Creates a Money from a [Fixed] [amount].
  ///
  /// The [amount] is scaled to match the currency selected via
  /// [currency].
  factory Money.fromFixedWithCurrency(Fixed amount, Currency currency,
          {int? scale}) =>
      Money._from(
          Fixed.copyWith(amount, scale: scale ?? currency.scale), currency);

  /// Creates a Money from a [Decimal] [amount].
  ///
  /// The [amount] is scaled to match the currency selected via
  /// [code].
  /// If [code] isn't a valid currency then an [UnknownCurrencyException]
  /// is thrown.
  factory Money.fromDecimal(Decimal amount,
      {required String code, int? scale}) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return Money.fromDecimalWithCurrency(amount, currency, scale: scale);
  }

  factory Money.fromDecimalWithCurrency(Decimal amount, Currency currency,
          {int? scale}) =>
      Money._from(
          Fixed.fromDecimal(amount, scale: scale ?? currency.scale), currency);

  /// ******************************************
  /// Money.parse
  /// ******************************************

  /// Parses the passed [amount] and returns a [Money] instance.
  ///
  /// The passed [amount] must match the given [pattern] or
  /// if no pattern is supplied the the default pattern of the
  /// currency indicated by the [code]. The S and C characters
  /// in the pattern are optional.
  ///
  /// See [format] for details on how to construct a [pattern].
  ///
  /// Throws an MoneyParseException if the [amount] doesn't
  /// match the pattern.
  ///
  /// If the number of decimals in [amount] exceeds the [Currency]s scale
  ///  then excess digits will be ignored.
  ///
  /// [code] - the currency code of the [amount]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  ///
  /// Throws an [UnknownCurrencyException] if the [code] is not a registered
  /// code.
  factory Money.parse(String amount,
      {required String code, String? pattern, int? scale}) {
    if (amount.isEmpty) {
      throw MoneyParseException('Empty amount passed.');
    }

    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    try {
      return Money.parseWithCurrency(amount, currency,
          scale: scale, pattern: pattern);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw MoneyParseException(e.toString());
    }
  }

  /// Parses the passed [amount] and returns a [Money] instance.
  ///
  /// The passed [amount] must match the given [pattern] or
  /// if no pattern is supplied the the default pattern of the
  /// currency indicated by the [currency]. The S and C characters
  /// in the pattern are optional.
  ///
  /// See [format] for details on how to construct a pattern.
  ///
  /// Throws an MoneyParseException if the [amount] doesn't
  /// match the pattern.
  ///
  /// If the number of decimals in [amount] exceeds the [Currency]s scale
  ///  then excess digits will be ignored.
  ///
  /// [currency] - the currency of the [amount].
  factory Money.parseWithCurrency(String amount, Currency currency,
      {String? pattern, int? scale}) {
    if (amount.isEmpty) {
      throw MoneyParseException('Empty amount passed.');
    }

    try {
      pattern ??= currency.pattern;

      final decoder = PatternDecoder(currency, pattern);

      final data = decoder.decode(amount);

      return Money._from(
          Fixed.copyWith(data.amount, scale: scale ?? currency.scale),
          currency);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw MoneyParseException(e.toString());
    }
  }

  /// The monetary amount
  final Fixed amount;

  /// The currency the [amount] is stored in.
  final Currency currency;

  /// Returns the underlying minorUnits
  /// for this monetary amount.
  /// e.g. $10.10 is returned as 1010
  BigInt get minorUnits => amount.minorUnits;

  ///
  /// Converts a [Money] instance into a new [Money] instance
  /// with its [Currency] defined by the [exchangeRate].
  ///
  /// The current [Money] amount is multiplied by the exchange rate to arrive
  /// at the  converted currency.
  ///
  /// e.g.
  /// US$0.68 = AU$1.00 * US$0.6800
  ///
  /// Where US$0.68 is the exchange rate.
  ///
  ///
  /// In the below example we do the following conversion:
  /// $10.00 * 0.68 = $6.8000
  ///
  /// To do the above conversion:
  /// ```dart
  /// Currency aud = Currency.create('AUD', 2);
  /// Currency usd = Currency.create('USD', 2);
  /// Money invoiceAmount = Money.fromInt(1000, aud);
  /// Money auToUsExchangeRate = Money.fromInt(68, usd);
  /// Money usdAmount = invoiceAmount.exchangeTo(auToUsExchangeRate);
  /// ```
  Money exchangeTo(ExchangeRate exchangeRate) => exchangeRate.applyRate(this);

  /// The same as [Money.parse]  but returns null if we are unable to
  /// [Money.parse] the [monetaryAmount]
  static Money? tryParse(String monetaryAmount,
      {required String code, String? pattern, int? scale}) {
    try {
      return Money.parse(monetaryAmount,
          code: code, pattern: pattern, scale: scale);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }

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
  /// Note: if [Currency.invertSeparators] is true then the meaning of comma
  ///   and period are swapped.
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
  String format(String pattern) => encodedBy(PatternEncoder(this, pattern));

  @override
  String toString() => encodedBy(PatternEncoder(this, currency.pattern));

  /// The component of the number before the decimal point
  BigInt get integerPart => amount.integerPart;

  /// The component of the number after the decimal point.
  BigInt get decimalPart => amount.decimalPart;

  int get scale => amount.scale;

  // Encoding/Decoding *******************************************************

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

    return Money._from(
        Fixed.copyWith(data.amount, scale: data.currency.scale), data.currency);
  }

  /// Encodes a [Money] instance as a <T>.
  ///
  /// Create your own encoders to convert a Money instance to
  /// any other type.

  /// You can use this to format a [Money] instance as a string.
  ///
  /// <T> - the type you want to encode the [Money]
  /// Returns this money representation encoded by [encoder].
  T encodedBy<T>(MoneyEncoder<T> encoder) =>
      encoder.encode(MoneyData.from(amount, currency));

  // Amount predicates ********************************************************

  /// Returns the sign of this [Fixed] amount.
  /// Returns 0 for zero, -1 for values less than zero and +1 for values
  /// greater than zero.
  int get sign => amount.sign;

  /// Returns `true` when amount of this money is zero.
  bool get isZero => amount.isZero;

  /// Returns `true` when amount of this money is negative.
  bool get isNegative => amount.isNegative;

  /// Returns `true` when amount of this money is positive (greater than zero).
  ///
  /// **TIP:** If you need to check that this value is zero or greater,
  /// use expression `!money.isNegative` instead.
  bool get isPositive => amount.isPositive;

  /* Hash Code ****************************************************************/

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + amount.hashCode;
    result = 37 * result + currency.hashCode;

    return result;
  }

  /* Comparison ***************************************************************/

  /// Returns `true` if this money value is in the specified [currency].
  bool isInCurrency(String code) => currency == Currencies().find(code);
  bool isInCurrencyWithCurrency(Currency other) => currency == other;

  /// Returns `true` if this money value is in same currency as [other].
  bool isInSameCurrencyAs(Money other) =>
      isInCurrencyWithCurrency(other.currency);

  /// Compares this to [other].
  ///
  /// [other] has to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  @override
  int compareTo(Money other) {
    _preconditionThatCurrencyTheSameFor(other);

    return amount.compareTo(other.amount);
  }

  /// Returns `true` if [other] is the same amount of money in
  /// the same currency.
  @override
  bool operator ==(covariant Money other) =>
      identical(this, other) ||
      (isInSameCurrencyAs(other) && other.amount == amount);

  /// Returns `true` when this money is less than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return amount < other.amount;
  }

  /// Returns `true` when this money is less than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return amount <= other.amount;
  }

  /// Returns `true` when this money is greater than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return amount > other.amount;
  }

  /// Returns `true` when this money is greater than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return amount >= other.amount;
  }

  /* Allocation ***************************************************************/

  /// Returns allocation of this money according to `ratios`.
  ///
  /// A value of the parameter [ratios] must be a non-empty list, with
  /// not negative values and sum of these values must be greater than zero.
  List<Money> allocationAccordingTo(List<int> ratios) =>
      amount.allocationAccordingTo(ratios).map(_withAmount).toList();

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

    return _withAmount(amount + summand.amount);
  }

  /// unary minus operator.
  Money operator -() => _withAmount(-amount);

  /// Subtracts right operand from the left one.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator -(Money subtrahend) {
    _preconditionThatCurrencyTheSameFor(subtrahend);

    return _withAmount(amount - subtrahend.amount);
  }

  /// Returns [Money] multiplied by [multiplier], using schoolbook rounding.
  Money operator *(num multiplier) => _withAmount(
      Fixed.copyWith(amount.multiply(multiplier), scale: currency.scale));

  /// Returns [Money] divided by [divisor], using schoolbook rounding.
  Money operator /(num divisor) => _withAmount(
      Fixed.copyWith(amount.divide(divisor), scale: currency.scale));

  /// Divides this by [divisor] and returns the result as a double
  double dividedBy(Money divisor) {
    _preconditionThatCurrencyTheSameFor(divisor);
    return minorUnits.toDouble() / divisor.minorUnits.toDouble();
  }

  Money multiplyByFixed(Fixed multiplier) =>
      Money.fromFixedWithCurrency(amount * multiplier, currency);

  Money divideByFixed(Fixed multiplier) =>
      Money.fromFixedWithCurrency(amount / multiplier, currency);

  Money modulusFixed(Fixed other) =>
      Money.fromFixedWithCurrency(amount % other, currency);

  /* ************************************************************************ */

  /// Creates new instance with the same currency and given [amount].
  Money _withAmount(Fixed amount) => Money._from(amount, currency);

  void _preconditionThatCurrencyTheSameFor(Money other,
      [String Function()? message]) {
    String defaultMessage() =>
        'Cannot operate with money values in different currencies.';

    if (!isInSameCurrencyAs(other)) {
      throw ArgumentError((message ?? defaultMessage)());
    }
  }
}

/// Exception thrown when a parse fails.
class MoneyParseException implements MoneyException {
  ///
  MoneyParseException(this.message);

  ///
  factory MoneyParseException.fromValue(
      {required String compressedPattern,
      required int patternIndex,
      required String compressedValue,
      required int monetaryIndex,
      required String monetaryValue}) {
    final message = '''
$monetaryValue contained an unexpected character '${compressedValue[monetaryIndex]}' at pos $monetaryIndex 
        when a match for pattern character ${compressedPattern[patternIndex]} at pos $patternIndex was expected.''';
    return MoneyParseException(message);
  }

  /// The error message
  String message;

  @override
  String toString() => message;
}

/// Base class of all exceptions thrown from Money2.
class MoneyException implements Exception {}
