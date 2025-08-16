import 'currency.dart';
import 'exchange_rates/exchange_rate.dart';
import 'money.dart';

/// Thrown if an exchange is attempted with a [Money] has a [Currency] which
/// doesn't match the exchange rate.
class MismatchedCurrencyException extends MoneyException {
  late final String message;

  /// Thrown if an exchange is attempted with a [Money] has a [Currency] which
  /// doesn't match the exchange rate.
  MismatchedCurrencyException(
      {required String expected, required String actual}) {
    message = "The exchange rate 'fromCurrency' of $expected is not the "
        "same as the Money's currency $actual";
  }
}

/// Thrown if the currency is not registered.
class UnknownCurrencyException implements MoneyException {
  /// The [isoCode] or monetary amount that contained the unknow currency
  String isoCode;

  /// Thrown if the currency is not registered.
  UnknownCurrencyException(this.isoCode);

  @override
  String toString() =>
      "An unknown currency '$isoCode' was passed. Register the currency"
      ' via [Currencies().register()] and try again.';
}

/// Exception thrown when a parse fails.
class MoneyParseException implements MoneyException {
  /// The error message
  String message;

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

  @override
  String toString() => message;
}

/// Exception thrown for an illegal pattern.
class IllegalPatternException implements Exception {
  final String message;

  IllegalPatternException(this.message);

  @override
  String toString() => message;
}

/// Thrown if an attempt is made to calcuate the value of a [Money] amount
/// in another currency for which there isn't a registered exchange rate.
class UnknownExchangeRateException implements MoneyException {
  /// The from currency isoCode in the unknown exchange
  CurrencyIsoCode from;

  /// The to  currency isoCode in the unknown exchange
  CurrencyIsoCode to;

  /// Thrown if no exchange rate exists between [from] and [to]
  UnknownExchangeRateException(this.from, this.to);

  @override
  String toString() =>
      "An unknown currency exchange was attempted from: '$from' to: '$to'. "
      'Register the ExchangeRate'
      ' via [ExchangePlatform.register()] and try again.';
}

/// Base class of all exceptions thrown from Money2.
class MoneyException implements Exception {}
