/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:math';

import 'package:fixed/fixed.dart';

import 'currency.dart';
import 'encoders.dart';
import 'exceptions.dart';
import 'money_data.dart';
import 'pattern_encoder.dart';

/// Parses a String containing a monetary amount based on a pattern.
class PatternDecoder implements MoneyDecoder<String> {
  /// the currency we discovered
  final Currency currency;

  /// the pattern used to decode the amount.
  final String pattern;

  static const numerics = '0123456789+-,.';

  /// ctor
  PatternDecoder(
    this.currency,
    this.pattern,
  ) {
    ArgumentError.checkNotNull(currency, 'currency');
    ArgumentError.checkNotNull(pattern, 'pattern');
  }

  @override
  MoneyData decode(String monetaryValue) {
    final patterns = _splitPattern(pattern);
    if (patterns.length == 1) {
      return _decodeWithPattern(monetaryValue, patterns.first);
    }

    final preferNegative = monetaryValue.contains('-');
    final ordered = preferNegative
        ? [patterns[1], patterns[0]]
        : [patterns[0], patterns[1]];

    MoneyParseException? lastError;
    for (final candidate in ordered) {
      try {
        return _decodeWithPattern(monetaryValue, candidate);
      } on MoneyParseException catch (e) {
        lastError = e;
      }
    }

    throw lastError!;
  }

  MoneyData _decodeWithPattern(String monetaryValue, String localPattern) {
    var majorUnits = BigInt.zero;

    var minorUnits = BigInt.zero;

    final isoCode = currency.isoCode;

    var compressedPattern = compressDigits(localPattern);

    compressedPattern = compressWhitespace(compressedPattern);

    final compressedMonetaryValue = compressWhitespace(monetaryValue);

    var codeIndex = 0;

    var isNegative = false;
    var seenSign = false;

    var seenMajor = false;

    var seenDecimal = false;

    var valueForQueue = compressedMonetaryValue;

    final hasExplicitSign =
        localPattern.contains('-') || localPattern.contains('+');
    if (!hasExplicitSign &&
        valueForQueue.isNotEmpty &&
        !(compressedPattern.startsWith('S') &&
            currency.symbol.isNotEmpty &&
            valueForQueue.startsWith(currency.symbol)) &&
        (valueForQueue[0] == '-' || valueForQueue[0] == '+')) {
      isNegative = valueForQueue[0] == '-';
      seenSign = true;

      valueForQueue = valueForQueue.substring(1);
    }

    var decimalSeparator = currency.decimalSeparator;

    final groupSeparator = currency.groupSeparator;

    final valueQueue =
        ValueQueue(valueForQueue, groupSeparator, decimalSeparator);

    for (var i = 0; i < compressedPattern.length; i++) {
      switch (compressedPattern[i]) {
        case 'S':
          final possibleSymbol = valueQueue.peekN(currency.symbol.length);

          if (possibleSymbol == currency.symbol) {
            valueQueue.takeN(currency.symbol.length);
          }

        case 'C':
          if (codeIndex >= isoCode.length) {
            throw MoneyParseException(
                'The pattern has more currency isoCode "C" characters '
                '($codeIndex + 1) than the length of the passed currency.');
          }

          // Like the encoder, the third C represents the rest of the code,
          // including custom currency codes longer than three characters.
          final expectedCode =
              codeIndex == 2 ? isoCode.substring(2) : isoCode[codeIndex];
          final char = valueQueue.peek();

          if (valueQueue.peekN(expectedCode.length) != expectedCode) {
            if (!isNumeric(char) && !_isSymbolForPattern(char, localPattern)) {
              throw MoneyParseException.fromValue(
                  compressedPattern: compressedPattern,
                  patternIndex: i,
                  compressedValue: compressedMonetaryValue,
                  monetaryIndex: valueQueue.index,
                  monetaryValue: monetaryValue);
            }
          } else {
            valueQueue.takeN(expectedCode.length);

            codeIndex++;
          }

        case '#':
          if (!seenMajor) {
            final char = valueQueue.peek();

            if (!hasExplicitSign && !seenSign && (char == '-' || char == '+')) {
              valueQueue.takeOne();
              isNegative = char == '-';
              seenSign = true;
            }
          }

          if (seenMajor) {
            if (seenDecimal) {
              minorUnits = valueQueue.takeMinorDigits(currency);
            }
          } else {
            valueQueue.inferSeparators();
            decimalSeparator = valueQueue.decimalSeparator;
            majorUnits = valueQueue.takeMajorDigits();
          }

        case '.':
          if (valueQueue.startsWith(decimalSeparator)) {
            valueQueue.takeN(decimalSeparator.length);
            seenDecimal = true;
          }

          seenMajor = true;

        case ' ':
          break;

        case '-':
          if (!seenSign && valueQueue.isNotEmpty && valueQueue.peek() == '-') {
            valueQueue.takeOne();
            isNegative = true;
            seenSign = true;
          } else {
            throw MoneyParseException.fromValue(
                compressedPattern: compressedPattern,
                patternIndex: i,
                compressedValue: compressedMonetaryValue,
                monetaryIndex: valueQueue.index,
                monetaryValue: monetaryValue);
          }

        case '+':
          if (!seenSign &&
              valueQueue.isNotEmpty &&
              (valueQueue.peek() == '-' || valueQueue.peek() == '+')) {
            final char = valueQueue.takeOne();
            seenSign = true;
            if (char == '-') {
              isNegative = true;
            }
          } else {
            throw MoneyParseException.fromValue(
                compressedPattern: compressedPattern,
                patternIndex: i,
                compressedValue: compressedMonetaryValue,
                monetaryIndex: valueQueue.index,
                monetaryValue: monetaryValue);
          }

        default:
          throw MoneyParseException(
              'Invalid character "${compressedPattern[i]}" found in pattern.');
      }
    }

    if (valueQueue.isNotEmpty ||
        valueQueue.digitsTaken == 0 ||
        (codeIndex != 0 &&
            codeIndex != 'C'.allMatches(compressedPattern).length)) {
      throw MoneyParseException(
          'Invalid or incomplete monetary amount: $monetaryValue');
    }

    // Combine absolute major and minor units
    final combinedAbsoluteValue =
        majorUnits * currency.decimalDigitsFactor + minorUnits;

    BigInt finalValue;

    if (isNegative) {
      finalValue = combinedAbsoluteValue * BigInt.from(-1);
    } else {
      finalValue = combinedAbsoluteValue;
    }

    final result = MoneyData.from(
        Fixed.fromBigInt(finalValue, decimalDigits: currency.decimalDigits),
        currency);

    return result;
  }

  List<String> _splitPattern(String pattern) {
    final parts = pattern.split(';');
    if (parts.length > 2) {
      throw MoneyParseException(
          'The pattern contained more than one ";" separator.');
    }
    if (parts.length == 2) {
      if (parts[0].isEmpty || parts[1].isEmpty) {
        throw MoneyParseException(
            'The pattern must include both positive and negative sections.');
      }
    }
    return parts;
  }

  ///
  /// Compresses all 0 # , . characters into a single #.#
  ///
  String compressDigits(String pattern) {
    var result = '';

    const regExPattern =
        '([#|0|$patternGroupSeparator]+)(?:$patternDecimalSeparator([#|0]+))?';

    final regEx = RegExp(regExPattern);

    final matches = regEx.allMatches(pattern);

    if (matches.isEmpty) {
      throw MoneyParseException(
          'The pattern did not contain a valid pattern such as "0.00"');
    }

    if (matches.length != 1) {
      throw MoneyParseException(
          'The pattern contained more than one numeric pattern.'
          " Check you don't have spaces in the numeric parts of the pattern.");
    }

    final Match match = matches.first;

    if (match.group(1) != null && match.group(2) != null) {
      // we have minor and major units
      result = pattern.replaceFirst(regEx, '#.#');
    } else if (match.group(1) != null) {
      // we have only major units
      result = pattern.replaceFirst(regEx, '#');

      /// We force the capture of all minor units by ensuring the
      /// pattern always contains a .#.
      final decimalLocation = result.indexOf(patternDecimalSeparator);
      if (decimalLocation == -1) {
        final majorLocation = result.indexOf('#');
        result = '${result.substring(0, majorLocation + 1)}.'
            '#${result.substring(majorLocation + 1)}';
      } else {
        // decimal but no minor units
        // e.g. #.
        result = '${result.substring(0, decimalLocation + 1)}'
            '#${result.substring(decimalLocation + 1)}';
      }
    } else if (match.group(2) != null) {
      // we have only minor units
      result = pattern.replaceFirst(regEx, '.#');
    }

    return result;
  }

  /// Removes all whitespace from a pattern or a value
  /// as when we are parsing we ignore whitespace.
  String compressWhitespace(String value) {
    final regEx = RegExp(r'\s+');
    return value.replaceAll(regEx, '');
  }

  bool isIsoCode(String value) {
    final isoCode = currency.isoCode;
    for (final char in value.codeUnits) {
      if (!isoCode.contains(char.toString())) {
        return false;
      }
    }
    return true;
  }

  /// true if the pass value is one of the characters used
  /// to represent a number as defined by [numerics]
  bool isNumeric(String value) {
    for (final char in value.codeUnits) {
      if (!numerics.codeUnits.contains(char)) {
        return false;
      }
    }
    return true;
  }

  /// true if [value] is composed only of the currency symbol characters and
  /// the pattern contains an `S` symbol placeholder.
  bool isSymbol(String value) {
    /// If the pattern doesn't contain an S
    /// then the value may not have a symbol.
    if (!pattern.contains('S')) {
      return false;
    }
    for (final char in value.codeUnits) {
      if (!currency.symbol.codeUnits.contains(char)) {
        return false;
      }
    }
    return true;
  }

  /// true if [value] is composed only of the currency symbol characters and
  /// the provided [localPattern] contains an `S` symbol placeholder.
  bool _isSymbolForPattern(String value, String localPattern) {
    if (!localPattern.contains('S')) {
      return false;
    }
    for (final char in value.codeUnits) {
      if (!currency.symbol.codeUnits.contains(char)) {
        return false;
      }
    }
    return true;
  }
}

/// Takes a monetary value and turns it into a queue
/// of digits which can be taken one at a time.
class ValueQueue {
  /// Number of digits consumed, including truncated fractional digits.
  var digitsTaken = 0;

  /// the amount we are queuing the digits of.
  String monetaryValue;

  /// current index into the [monetaryValue]
  var index = 0;

  /// the group seperator used in this [monetaryValue]
  String groupSeparator;

  /// the decimal seperator used in this [monetaryValue]
  String decimalSeparator;

  /// The last character we took from the queue.
  String? lastTake;

  ///
  ValueQueue(this.monetaryValue, this.groupSeparator, this.decimalSeparator);

  /// Infer US/European separators only from the numeric portion, after the
  /// optional currency markers and sign have been consumed.
  void inferSeparators() {
    if (!{'.', ','}.contains(decimalSeparator) ||
        !{'.', ','}.contains(groupSeparator)) {
      return;
    }
    var end = index;
    while (end < monetaryValue.length &&
        (_isDigit(monetaryValue[end]) ||
            monetaryValue[end] == '.' ||
            monetaryValue[end] == ',')) {
      end++;
    }
    final numeric = monetaryValue.substring(index, end);
    final dot = numeric.lastIndexOf('.');
    final comma = numeric.lastIndexOf(',');
    if (dot != -1 && comma != -1) {
      decimalSeparator = dot > comma ? '.' : ',';
      groupSeparator = dot > comma ? ',' : '.';
    }
  }

  /// returns the next character from the queue without
  /// removing it.
  String peek() => isEmpty ? '' : monetaryValue[index];

  bool startsWith(String token) =>
      token.isNotEmpty && monetaryValue.startsWith(token, index);

  /// returns the next [n] character from the queue
  /// without removing them..
  String peekN(int n) {
    var end = index + n;

    end = min(end, monetaryValue.length);
    final peek = lastTake = monetaryValue.substring(index, end);

    return peek;
  }

  bool get isEmpty => index == monetaryValue.length;
  bool get isNotEmpty => !isEmpty;

  /// takes the next character from the value.
  String takeOne() => lastTake = monetaryValue[index++];

  /// takes the next [n] character from the value.
  String takeN(int n) {
    final take = peekN(n);

    index += n;

    return take;
  }

  /// return all of the digits from the current position
  /// until we find a non-digit.
  BigInt takeMajorDigits() {
    final majorDigits = _takeDigits(isMajor: true);
    return majorDigits.isEmpty ? BigInt.zero : BigInt.parse(majorDigits);
  }

  /// Takes any remaining digits as minor digits.
  /// If there are less digits than [Currency.decimalDigits]
  /// then we pad the number with zeros before we convert it to an it.
  ///
  /// e.g.
  /// 1.2 -> 1.20
  /// 1.21 -> 1.21
  BigInt takeMinorDigits(Currency currency) {
    var digits = _takeDigits(isMajor: false);
    if (digits.isEmpty) {
      throw MoneyParseException(
          'A decimal separator must be followed by digits.');
    }

    if (digits.length < currency.decimalDigits) {
      digits += '0' * max(0, currency.decimalDigits - digits.length);
    }

    if (digits.length > currency.decimalDigits) {
      digits = digits.substring(0, currency.decimalDigits);
    }

    return digits.isEmpty ? BigInt.zero : BigInt.parse(digits);
  }

  String _takeDigits({required bool isMajor}) {
    final digits = StringBuffer();
    var previousWasDigit = false;
    while (index < monetaryValue.length) {
      final char = monetaryValue[index];
      if (_isDigit(char)) {
        digits.write(char);
        digitsTaken++;
        previousWasDigit = true;
        index++;
      } else if (startsWith(decimalSeparator)) {
        // Stop, this is the decimal separator. DO NOT CONSUME.
        break;
      } else if (startsWith(groupSeparator) && isMajor) {
        final next = index + groupSeparator.length;
        if (!previousWasDigit ||
            next >= monetaryValue.length ||
            !_isDigit(monetaryValue[next])) {
          throw MoneyParseException(
              'Group separators must occur between digits.');
        }
        index = next;
        previousWasDigit = false;
      } else {
        // Stop, not a digit or expected separator. DO NOT CONSUME.
        break;
      }
    }
    return digits.toString();
  }

  bool _isDigit(String char) =>
      char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
      char.codeUnitAt(0) <= '9'.codeUnitAt(0);

  /// returns true if the value queue still contains [char]
  bool contains(String char) {
    final remaining = monetaryValue.substring(index);
    return remaining.contains(char);
  }
}
