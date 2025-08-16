/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// import 'package:meta/meta.dart' show sealed, immutable;

import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:fixed/fixed.dart';
import 'package:meta/meta.dart';

import 'common_currencies.g.dart';
import 'currencies.dart';
import 'currency.dart';
import 'encoders.dart';
import 'exceptions.dart' show MoneyParseException, UnknownCurrencyException;
import 'exchange_rates/exchange_rate.dart';
import 'money_data.dart';
import 'pattern_decoder.dart';
import 'pattern_encoder.dart';
import 'percentage.dart';

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
  /// The monetary amount
  final Fixed amount;

  /// The currency the [amount] is stored in.
  final Currency currency;

  const Money._from(this.amount, this.currency);

  /// ******************************************
  /// Money.from
  /// ******************************************

  /// Creates an instance of [Money] from a [num] holding the monetary value.
  /// Unlike [Money.fromBigInt] the amount is in dollars and cents
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
  /// [isoCode] - the currency isoCode of the [amount]. This must be either one
  /// of the [CommonCurrencies] or a currency you have registered
  /// via [Currencies.register].
  /// If the [decimalDigits] is provided then the [Money] instance is
  /// created with the supplied number of [decimalDigits].
  /// If [decimalDigits] isn't provided then the [decimalDigits] is taken
  /// from the [Currency] associated with the [isoCode].
  /// Throws an [UnknownCurrencyException] if the [isoCode] is not a registered
  /// isoCode.
  factory Money.fromNum(num amount,
      {required String isoCode, int? decimalDigits}) {
    final currency = Currencies().find(isoCode);

    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    return Money.fromNumWithCurrency(amount, currency,
        decimalDigits: decimalDigits ?? currency.decimalDigits);
  }

  /// Creates an instance of [Money] from a num holding the monetary value.
  ///
  /// Unlike [Money.fromBigInt] the amount is in dollars and cents
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
  /// and [Money.parse()].
  ///
  /// [amount] - the monetary value.
  /// [currency] - the currency of the [amount].
  /// [decimalDigits] - allows you to set an alternate number of [decimalDigits]
  ///     If not provided then [currency]'s [decimalDigits] are used.
  factory Money.fromNumWithCurrency(num amount, Currency currency,
          {int? decimalDigits}) =>
      Money._from(
          Fixed.fromNum(amount,
              decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);

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
  /// [isoCode] - the currency isoCode of the [minorUnits]. This must be
  /// either one of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  /// Throws an [UnknownCurrencyException] if the [isoCode] is not a registered
  /// isoCode.
  factory Money.fromBigInt(BigInt minorUnits,
      {required String isoCode, int? decimalDigits}) {
    final currency = Currencies().find(isoCode);
    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    return Money.fromBigIntWithCurrency(minorUnits, currency,
        decimalDigits: decimalDigits);
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
  factory Money.fromBigIntWithCurrency(BigInt minorUnits, Currency currency,
          {int? decimalDigits}) =>
      Money._from(
          Fixed.fromBigInt(minorUnits,
              decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);

  /// ******************************************
  /// Money.fromInt
  /// ******************************************

  /// Creates an instance of [Money] from an integer.
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  /// [isoCode] - the currency isoCode of the [minorUnits].
  ///     This must be either one of the [CommonCurrencies] or a currency
  /// you have registered via [Currencies.register].
  /// [decimalDigits] - the number of decimal digits to store.
  ///
  /// Throws an [UnknownCurrencyException] if the [isoCode] is not a registered
  /// isoCode.
  factory Money.fromInt(int minorUnits,
      {required String isoCode, int? decimalDigits}) {
    final currency = Currencies().find(isoCode);
    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    return Money.fromIntWithCurrency(minorUnits, currency,
        decimalDigits: decimalDigits);
  }

  /// Creates an instance of [Money] from an integer.
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  factory Money.fromIntWithCurrency(int minorUnits, Currency currency,
          {int? decimalDigits}) =>
      Money._from(
          Fixed.fromInt(minorUnits,
              decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);

  /// Creates a Money from a [Fixed] [amount].
  ///
  /// The [amount]'s decimal Digits are adjusted to match
  /// the currency selected via [isoCode].
  /// If [isoCode] isn't a valid currency then an [UnknownCurrencyException]
  /// is thrown.
  factory Money.fromFixed(Fixed amount,
      {required String isoCode, int? decimalDigits}) {
    final currency = Currencies().find(isoCode);
    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    return Money.fromFixedWithCurrency(amount, currency,
        decimalDigits: decimalDigits);
  }

  /// Creates a Money from a [Fixed] [amount].
  ///
  /// The [amount]'s decimal digits are adjusted to match the
  /// currency selected via [currency].
  factory Money.fromFixedWithCurrency(Fixed amount, Currency currency,
          {int? decimalDigits}) =>
      Money._from(
          amount.copyWith(
              decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);

  /// Creates a Money from a [Decimal] [amount].
  ///
  /// The [amount]'s decimal digits are adjusted
  /// to match the currency selected via [isoCode].
  /// If [isoCode] isn't a valid currency then an [UnknownCurrencyException]
  /// is thrown.
  factory Money.fromDecimal(Decimal amount,
      {required String isoCode, int? decimalDigits}) {
    final currency = Currencies().find(isoCode);
    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    return Money.fromDecimalWithCurrency(amount, currency,
        decimalDigits: decimalDigits);
  }

  factory Money.fromDecimalWithCurrency(Decimal amount, Currency currency,
          {int? decimalDigits}) =>
      Money._from(
          Fixed.fromDecimal(amount,
              decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);

  /// ******************************************
  /// Money.parse
  /// ******************************************

  /// Parses the passed [amount] and returns a [Money] instance.
  ///
  /// The passed [amount] must match the given [pattern] or
  /// if no pattern is supplied the the default pattern of the
  /// currency indicated by the [isoCode]. The S and C characters
  /// in the pattern are optional.
  ///
  /// See [format] for details on how to construct a [pattern].
  ///
  /// Throws an MoneyParseException if the [amount] doesn't
  /// match the pattern.
  ///
  /// If the number of decimals in [amount] exceeds the [Currency]'s
  /// decimalDigits then excess digits will be ignored.
  ///
  /// [isoCode] - the currency isoCode of the [amount]. This must be either one
  /// of the [CommonCurrencies] or a currency you have
  /// registered via [Currencies.register].
  ///
  /// Throws an [UnknownCurrencyException] if the [isoCode] is not a registered
  /// isoCode.
  factory Money.parse(String amount,
      {required String isoCode, String? pattern, int? decimalDigits}) {
    if (amount.isEmpty) {
      throw MoneyParseException('Empty amount passed.');
    }

    final currency = Currencies().find(isoCode);
    if (currency == null) {
      throw UnknownCurrencyException(isoCode);
    }

    try {
      return Money.parseWithCurrency(amount, currency,
          decimalDigits: decimalDigits, pattern: pattern);
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
  /// If the number of decimals in [amount] exceeds the [Currency]'s
  /// decimalDigits then excess digits will be ignored.
  ///
  /// [currency] - the currency of the [amount].
  factory Money.parseWithCurrency(String amount, Currency currency,
      {String? pattern, int? decimalDigits}) {
    if (amount.isEmpty) {
      throw MoneyParseException('Empty amount passed.');
    }

    try {
      pattern ??= currency.pattern;

      final decoder = PatternDecoder(currency, pattern);

      final data = decoder.decode(amount);

      return Money._from(
          data.amount
              .copyWith(decimalDigits: decimalDigits ?? currency.decimalDigits),
          currency);
    } catch (e) {
      throw MoneyParseException(e.toString());
    }
  }

  /// ******************************************
  /// JSON serialization
  /// ******************************************

  /// Creates a [Money] instance from a JSON representation.
  ///
  /// The JSON representation follows the same format generated by the
  /// [toJson] method.
  factory Money.fromJson(Map<String, dynamic> json) {
    final minorUnits = json['minorUnits'] as String;
    final decimals = json['decimals'] as int;
    final isoCode = json['isoCode'] as String;

    return Money.fromBigInt(BigInt.parse(minorUnits),
        decimalDigits: decimals, isoCode: isoCode);
  }

  /* Instantiation ************************************************************/

  /// Creates a copy of this [Money] object with optional new values
  /// for [amount], [currency] and [decimalDigits].
  /// Changing the [currency] does NOT do an exchange calculation the
  /// [amount] is copied across verbatium (e.g. $1.00 AUD > $1.00 USD).
  /// If you pass an [isoCode] and it is invalid then a
  /// [UnknownCurrencyException] is thrown.
  Money copyWith({Fixed? amount, String? isoCode, int? decimalDigits}) {
    Currency? currency = this.currency;
    if (isoCode != null) {
      currency = Currencies().find(isoCode);
      if (currency == null) {
        throw UnknownCurrencyException(isoCode);
      }
    }
    return Money._from(
        (amount ?? this.amount).copyWith(
            decimalDigits: decimalDigits ?? this.amount.decimalDigits),
        currency);
  }

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
      {required String isoCode, String? pattern, int? decimalDigits}) {
    try {
      return Money.parse(monetaryAmount,
          isoCode: isoCode, pattern: pattern, decimalDigits: decimalDigits);
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
  ///       * CCC - USD - outputs the full currency isoCode regardless
  ///               of length.
  ///   * &#35; denotes a digit.
  ///   * 0 denotes a digit and with the addition of defining leading
  /// and trailing zeros.
  ///   * , (comma) a placeholder for the grouping separator
  ///   * . (period) a place holder for the decimal separator
  ///   * '-' indicates the location to display the '-' character if the amount
  ///         is -ve.
  ///   * '+' indicates the location to display the '-' character if the amount
  ///       is -ve or a '+' if the
  ///       amount is +ve.
  ///
  /// In addition:
  ///   – Currency placeholders (S or C) may appear only as a contiguous prefix
  ///      or suffix (not both)
  ///     and only one occurrence is allowed.
  ///   – A negative symbol '-' or '+' may appear at most once in the numeric
  ///   portion and must be either the first or last character there.
  ///
  /// Group Separators
  ///   - group separators allow you to specify repeating patterns.
  ///   e.g.
  ///      #,### == ###,### == ###,###,####
  ///      ##,### == ##,##,###
  ///
  /// The left most group is treated as the repeating pattern unless
  /// it is a single #, in which case the next group is treated as
  /// the repeating pattern.
  ///
  ///
  /// Note: even if you use the groupSeparator or decimalSeparator
  /// to use alternate separators the pattern must still use ',' and '.'
  /// for the group and decimal separators respectively.
  /// This method allows a single pattern to be used by multiple currencies.
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
  String format([String? pattern]) =>
      encodedBy(PatternEncoder(pattern ?? currency.pattern));

  @override
  String toString() => encodedBy(PatternEncoder(currency.pattern));

  /// Returns a JSON representation of this [Money] instance.
  ///
  /// The JSON representation can be used to recreate this [Money] instance
  /// using the [Money.fromJson] factory.
  Map<String, dynamic> toJson() => {
        'minorUnits': amount.minorUnits.toString(),
        'decimals': amount.decimalDigits,
        'isoCode': currency.isoCode,
      };

  /// The component of the number before the decimal point
  BigInt get integerPart => amount.integerPart;

  /// The component of the number after the decimal point.
  BigInt get decimalPart => amount.decimalPart;

  String decimalPartAsString() => amount.decimalPartAsString();

  int get decimalDigits => amount.decimalDigits;

  // Encoding/Decoding *******************************************************

  /// Returns a [Money] instance decoded from [value] by [decoder].
  ///
  /// Create your own [decoder]s to convert from any type to a [Money] instance.
  ///
  /// `<T>` - the type you are decoding from.
  ///
  /// Throws [FormatException] when the passed value contains an invalid format.
  // ignore: prefer_constructors_over_static_methods
  static Money decoding<T>(T value, MoneyDecoder<T> decoder) {
    final data = decoder.decode(value);

    return Money._from(
        data.amount.copyWith(decimalDigits: data.currency.decimalDigits),
        data.currency);
  }

  /// Encodes a [Money] instance as a `<T>`.
  ///
  /// Create your own encoders to convert a Money instance to
  /// any other type.

  /// You can use this to format a [Money] instance as a string.
  ///
  /// `<T>` - the type you want to encode the [Money]
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

  /// Returns `true` when amount of this money is not zero.
  bool get isNonZero => !amount.isZero;

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
  bool isInCurrency(String isoCode) => currency == Currencies().find(isoCode);
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Money && isInSameCurrencyAs(other) && other.amount == amount);

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

  /// returns the value of the Money as a double.
  /// Becareful as you lose precision using a double
  /// You should store money as a integer and a scale.
  double toDouble() => amount.toDecimal().toDouble();

  /// The value of the money as a [Decimal].
  Decimal toDecimal() => amount.toDecimal();

  /// The value of the money as a [Fixed].
  Fixed toFixed() => amount;

  /// the integer (major part) of the money value as an [int].
  int toInt() => amount.integerPart.toInt();

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
  /// As we have no information about the scale of the [multiplier]
  /// we treated it as if it has 16 decimal places.
  /// Use [multiplyByNum] if want to explicitly control the number of
  /// decimal places considered in [multiplier].
  Money operator *(num multiplier) => _withAmount(amount
      .multiply(multiplier, decimalDigits: 16)
      .copyWith(decimalDigits: decimalDigits));

  Money multiplyByNum(num multiplier, [int? decimalDigits = 16]) =>
      _withAmount(amount
          .multiply(multiplier, decimalDigits: decimalDigits)
          .copyWith(decimalDigits: decimalDigits));

  /// Returns [Money] divided by [divisor], using schoolbook rounding.
  Money operator /(num divisor) => _withAmount(
      amount.divide(divisor).copyWith(decimalDigits: currency.decimalDigits));

  /// Calculates the percentage that this is of [base].
  /// So this:10, base: 100 yeilds 0.1 which is 10%.
  /// The no. of decimal digits of the result is the larger of this and [base]
  Percentage percentageOf(Money base) {
    final scale = max(decimalDigits, base.decimalDigits);
    return Percentage.fromFixed(
        (toFixed() / base.toFixed() * Fixed.fromInt(100, decimalDigits: 0))
            .copyWith(decimalDigits: scale));
  }

  /// Multiples this by the given percentage
  /// $1 * 20% = $0.20
  Money multipliedByPercentage(Percentage percentage) =>
      multiplyByFixed(percentage)
          .divideByFixed(Fixed.fromInt(100, decimalDigits: 0));

  /// Divides this by [divisor] and returns the result as a double
  double dividedBy(Money divisor) {
    _preconditionThatCurrencyTheSameFor(divisor);
    return minorUnits.toDouble() / divisor.minorUnits.toDouble();
  }

  Money multiplyByFixed(Fixed multiplier) =>
      Money.fromFixedWithCurrency(amount * multiplier, currency);

  Money divideByFixed(Fixed divisor) =>
      Money.fromFixedWithCurrency(amount / divisor, currency);

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
