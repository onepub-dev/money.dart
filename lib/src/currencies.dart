/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'common_currencies.g.dart';
import 'currency.dart';
import 'exceptions.dart';
import 'money.dart';
import 'pattern_decoder.dart';

/// A factory for registering, parsing and finding [Currency] instances.
///
/// Money2 registers a default set of[CommonCurrencies] with the [Currencies]
/// class. This allows you to use the [Currencies.parse] method to parse
/// a Money amount with a currency isoCode.
///
/// You can add additional [Currency] or replace existing [Currency]s
/// by calling [Currencies.register].
///
/// You don't need to register [Currency]s, you can just create [Currency]s
/// and use them as needed.
///
/// see:
///   [Currency]
///   [CommonCurrencies]

class Currencies {
  static final _self = Currencies._internal();

  /// Maps a currency 'isoCode' to its associated currency.
  final Map<String, Currency> _directory = {};

  factory Currencies() => _self;

  Currencies._internal() {
    for (final currency in CommonCurrencies().asList()) {
      _directory[currency.isoCode] = currency;
    }
  }

  /// Register a Currency.
  ///
  /// Once a Currency has been registered the
  /// [Currencies.parse] method will be able to recognize
  /// the currencey isoCode in String and return the correct type.
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currencies().register(usd);
  /// final usdAmount = Currencies().parse(r'$USD1500.0');
  /// ```
  /// See:
  /// [Currencies.parse]
  /// [Currencies.registerList]
  /// [Currencies.find]
  void register(Currency currency) {
    _self._directory[currency.isoCode] = currency;
  }

  /// Register a list of currencies.
  ///
  /// Once a Currency has been registered the
  /// [Currencies.parse] method will be able to recognize
  /// the currencey isoCode in String and return the correct type.
  ///
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currency aud = Currency.create('AUD', 2);
  /// Currencies().registerList([usd, aud]);
  /// final usdAmount = Currencies.parse(r'$USD1500.0');
  /// ```
  /// See:
  /// [Currencies.parse]
  /// [Currencies.register]
  /// [Currencies.find]
  void registerList(Iterable<Currency> currencies) {
    for (final currency in currencies) {
      _self._directory[currency.isoCode] = currency;
    }
  }

  /// Parses a string containing a money amount including a currency isoCode.
  ///
  /// Provided the passed currency isoCode is a [Currency] listed in
  /// [CommonCurrencies] or belongs to a [Currency]
  /// that has been registered via [Currencies.register] or
  /// [Currencies.registerList] then this method will return a
  /// [Money] instance of that [Currency] type.
  ///
  /// An [UnknownCurrencyException] is thrown if the [monetaryAmountWithIsoCode]
  /// does not contain a known currency.
  ///
  /// [monetaryAmountWithIsoCode] is the monetary value that you want parsed.
  ///
  /// The [pattern] is the pattern to use when parsing
  ///   the [monetaryAmountWithIsoCode].
  /// The [pattern] is optional and if not passed then the default pattern
  /// registered with the [Currency] will be used to parse
  ///   the [monetaryAmountWithIsoCode].
  ///
  /// If the number of minorUnits in [monetaryAmountWithIsoCode]
  /// exceeds the [Currency]s precision then excess digits will be ignored.
  ///
  /// A [MoneyParseException] is thrown if the [monetaryAmountWithIsoCode]
  /// doesn't match the [pattern].
  ///
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currency aud = Currency.create('AUD', 2);
  /// Currencies().registerList([usd, aud]);
  /// final usdAmount = Currencies().parse(r'$USD1500.0');
  /// ```
  ///
  /// See:
  /// [Currencies.register]
  /// [Currencies.registerList]
  /// [Currencies.find]
  Money parse(String monetaryAmountWithIsoCode, {String? pattern}) {
    Currency? currency;
    if (pattern == null) {
      /// No pattern? so find the currency based on the currency
      /// isoCode in the [monetaryAmount].
      currency = findByCode(monetaryAmountWithIsoCode);
    } else {
      final codeLength = _getCodeLength(pattern);

      if (codeLength < 2) {
        throw MoneyParseException(
            'The Country IsoCode length (e.g. CC) must be at '
            'least 2 characters long');
      }

      final isoCode = _extractIsoCode(monetaryAmountWithIsoCode, codeLength);

      currency = find(isoCode);
    }

    if (currency == null) {
      throw UnknownCurrencyException(monetaryAmountWithIsoCode);
    }

    pattern ??= currency.pattern;

    var monetaryAmount = monetaryAmountWithIsoCode;

    if (!_containsCode(pattern)) {
      /// The default patterns often don't contain a currency
      /// isoCode so as a conveniencce we strip the isoCode out of the
      /// [monetaryAmount]. I hope this is a good idea :)
      monetaryAmount = _stripCode(currency, monetaryAmountWithIsoCode);
    }

    final decoder = PatternDecoder(currency, pattern);
    final moneyData = decoder.decode(monetaryAmount);

    return Money.fromFixedWithCurrency(moneyData.amount, currency);
  }

  /// Searches the list of registered [Currency]s.
  ///
  /// Returns the [Currency] that matches [isoCode] or `null` if
  /// no matching [isoCode] is found.
  /// ```dart
  /// final usdAmount = Currencies().parse(r'$USD1500.0');
  /// ```
  ///
  /// See:
  /// [Currencies.register]
  /// [Currencies.registerList]
  Currency? find(String isoCode) => _directory[isoCode];

  /// Short hand method to [find] a currency based on its isoCode.
  /// Throw [UnknownCurrencyException] if the [isoCode] hasn't been
  /// registered and is not one of the [CommonCurrencies].
  /// ```dart
  /// final usd = Currencies()['USD'];
  /// ```
  Currency? operator [](String isoCode) => find(isoCode);

  /// Short hand method to [register] a [Currency].
  ///
  /// ```dart
  /// Currencies['USD'] = Currency.create('USD', ....);
  /// ```
  void operator []=(String isoCode, Currency currency) => register(currency);

  /// Returns all currently registered [Currency]s
  ///
  /// ```dart
  /// final usd = Currency.create('USD', 2);
  /// final eur = Currency.create('EUR', 2);
  /// Currencies().registerList([usd, eur]);
  /// expect(Currencies().getRegistered(), [usd, eur]);
  /// expect(Currencies().getRegistered().map((c) => c.isoCode)
  ///     , ['USD', 'EUR']);
  /// ```
  ///
  /// see:
  /// [Currencies.register]
  /// [Currencies.registerList]
  Iterable<Currency> getRegistered() => _directory.values;

  /// Searches for the matching registered Currency by comparing
  /// the currency codes in a monetaryAmount.
  Currency? findByCode(String monetaryAmount) {
    Currency? match;
    var longToShort = <Currency>[];

    longToShort = _directory.values.toList()
      ..sort((lhs, rhs) => lhs.isoCode.length - rhs.isoCode.length);

    for (final currency in longToShort) {
      if (monetaryAmount.contains(currency.isoCode)) {
        match = currency;
        break;
      }
    }
    return match;
  }

  /// tests a pattern to see if it contains a currency isoCode.
  bool _containsCode(String pattern) => pattern.contains('C');

  /// Strips the currency isoCode out of a [monetaryAmountWithIsoCode]
  /// e.g.
  /// $USD10.00 becomes $10.00
  String _stripCode(Currency? currency, String monetaryAmountWithIsoCode) {
    String monetaryAmount;
    if (currency != null && !_containsCode(currency.pattern)) {
      final isoCode =
          _extractIsoCode(monetaryAmountWithIsoCode, currency.isoCode.length);

      /// Remove the currency isoCode
      monetaryAmount = monetaryAmountWithIsoCode.replaceFirst(isoCode, '');
    } else {
      monetaryAmount = monetaryAmountWithIsoCode;
    }
    return monetaryAmount;
  }

  /// Counts the number of 'C' in a pattern
  int _getCodeLength(String pattern) {
    var count = 0;
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i] == 'C') {
        count++;
      }
    }
    return count;
  }

  /// Extracts the currency isoCode from a [monetaryValue] on that
  /// assumption that it is [codeLength] long.
  String _extractIsoCode(String monetaryValue, int codeLength) {
    final regEx = RegExp('[A-Za-z]' * codeLength);

    final matches = regEx.allMatches(monetaryValue);
    if (matches.isEmpty) {
      throw MoneyParseException(
          'No currency isoCode found in the pattern: $monetaryValue');
    }

    if (matches.length > 1) {
      throw MoneyParseException(
          '''More than one currency isoCode found in the pattern: $monetaryValue''');
    }

    return monetaryValue.substring(matches.first.start, matches.first.end);
  }
}
