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
    var majorUnits = BigInt.zero;

    var minorUnits = BigInt.zero;

    final isoCode = currency.isoCode;

    var compressedPattern = compressDigits(pattern);

    compressedPattern = compressWhitespace(compressedPattern);

    final compressedMonetaryValue = compressWhitespace(monetaryValue);

    var codeIndex = 0;

    var isNegative = false;

    var seenMajor = false;

    var seenDecimal = false;

    var valueForQueue = compressedMonetaryValue;

    if (valueForQueue.isNotEmpty &&
        (valueForQueue[0] == '-' || valueForQueue[0] == '+')) {
      isNegative = valueForQueue[0] == '-';

      valueForQueue = valueForQueue.substring(1);
    }

    var decimalSeparator = currency.decimalSeparator;

    var groupSeparator = currency.groupSeparator;

    // Heuristic for robust decimal/group separator detection based on input format
    final lastDotIndex = valueForQueue.lastIndexOf('.');
    final lastCommaIndex = valueForQueue.lastIndexOf(',');
    if (lastDotIndex != -1 && lastCommaIndex != -1) {
      if (lastDotIndex > lastCommaIndex) {
        decimalSeparator = '.';
        groupSeparator = ',';
      } else {
        decimalSeparator = ',';
        groupSeparator = '.';
      }
    }

    // End heuristic

    final valueQueue =
        ValueQueue(valueForQueue, groupSeparator, decimalSeparator);

    for (var i = 0; i < compressedPattern.length; i++) {
      switch (compressedPattern[i]) {
        case 'S':
          final possibleSymbol = valueQueue.peekN(currency.symbol.length);

          if (possibleSymbol == currency.symbol) {
            valueQueue.takeN(currency.symbol.length);
          } else {
            if (!isNumeric(possibleSymbol) && !isIsoCode(possibleSymbol)) {
              throw MoneyParseException.fromValue(
                  compressedPattern: compressedPattern,
                  patternIndex: i,
                  compressedValue: compressedMonetaryValue,
                  monetaryIndex: valueQueue.index,
                  monetaryValue: monetaryValue);
            }
          }

        case 'C':
          if (codeIndex >= isoCode.length) {
            throw MoneyParseException(
                'The pattern has more currency isoCode "C" characters '
                '($codeIndex + 1) than the length of the passed currency.');
          }

          final char = valueQueue.peek();

          if (char != isoCode[codeIndex]) {
            if (!isNumeric(char) && !isSymbol(char)) {
              throw MoneyParseException.fromValue(
                  compressedPattern: compressedPattern,
                  patternIndex: i,
                  compressedValue: compressedMonetaryValue,
                  monetaryIndex: valueQueue.index,
                  monetaryValue: monetaryValue);
            }
          } else {
            valueQueue.takeOne();

            codeIndex++;
          }

        case '#':
          if (!seenMajor) {
            final char = valueQueue.peek();

            if (char == '-') {
              valueQueue.takeOne();

              isNegative = true;
            }
          }

          if (seenMajor) {
            if (seenDecimal) {
              minorUnits = valueQueue.takeMinorDigits(currency);
            }
          } else {
            majorUnits = valueQueue.takeMajorDigits();
          }

        case '.':
          if (valueQueue.isNotEmpty && valueQueue.contains(decimalSeparator)) {
            final char = valueQueue.takeOne();

            if (char != decimalSeparator) {
              throw MoneyParseException.fromValue(
                  compressedPattern: compressedPattern,
                  patternIndex: i,
                  compressedValue: compressedMonetaryValue,
                  monetaryIndex: valueQueue.index,
                  monetaryValue: monetaryValue);
            }

            seenDecimal = true;
          }

          seenMajor = true;

        case ' ':
          break;

        default:
          throw MoneyParseException(
              'Invalid character "${compressedPattern[i]}" found in pattern.');
      }
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
}

/// Takes a monetary value and turns it into a queue
/// of digits which can be taken one at a time.
class ValueQueue {
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

  /// returns the next character from the queue without
  /// removing it.
  String peek() => monetaryValue[index];

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

    if (digits.length < currency.decimalDigits) {
      digits += '0' * max(0, currency.decimalDigits - digits.length);
    }

    if (digits.length > currency.decimalDigits) {
      digits = digits.substring(0, currency.decimalDigits);
    }

    return BigInt.parse(digits);
  }

  String _takeDigits({required bool isMajor}) {
    var digits = '';
    while (index < monetaryValue.length) {
      final char = monetaryValue[index];
      if (_isDigit(char)) {
        digits += char;
        index++;
      } else if (char == groupSeparator && isMajor) {
        // Skip group separator. Consume it.
        index++;
      } else if (char == decimalSeparator) {
        // Stop, this is the decimal separator. DO NOT CONSUME.
        break;
      } else {
        // Stop, not a digit or expected separator. DO NOT CONSUME.
        break;
      }
    }
    return digits;
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
