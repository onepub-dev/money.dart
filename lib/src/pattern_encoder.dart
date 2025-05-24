import 'package:strings/strings.dart';

import 'currency.dart';
import 'encoders.dart';
import 'exceptions.dart';
import 'money_data.dart';

/// Patterns must always use these separators
/// regardless of the currency’s own separators.
const String patternDecimalSeparator = '.';
const String patternGroupSeparator = ',';

/// Formatter that converts a MoneyData into a String based on a
///   supplied pattern.
///
/// Supported pattern characters:
///
///   • S – Inserts the currency symbol (e.g. "$").
///   • C – Inserts part of the currency ISO code:
///         - C: first letter,
///         - CC: first two letters,
///         - CCC: the full ISO code.
///   • '#' is an optional digit placeholder.
///   • '0' is a required digit placeholder (pads with zeros).
///   • ',' is a grouping separator placeholder. The comma is
///         inserted exactly where it appears.
///   • '.' is the decimal separator (only one allowed).
///   • '-' indicates the location to display the '-' character if the amount
///         is -ve.
///   • '+' indicates the location to display the '-' character if the amount
///       is -ve or a '+' if the
///       amount is +ve.
///
///
/// In addition:
///   – Currency placeholders (S or C) may appear only as a contiguous prefix
///      or suffix (not both)
///     and only one occurrence is allowed.
///   – A negative symbol '-' or '+' may appear at most once in the numeric
///     portion and must be either the first or last character there.
///
/// This implementation processes the major part by iterating right-to-left
///   and the minor part left-to-right.
class PatternEncoder implements MoneyEncoder<String> {
  PatternEncoder(this.pattern);

  /// The full pattern string.
  String pattern;

  @override
  String encode(MoneyData data) {
    final regex = RegExp(RegExp.escape(patternDecimalSeparator));
    final decimalSeparators = regex.allMatches(pattern);
    if (decimalSeparators.length > 1) {
      throw IllegalPatternException('''
A pattern may only have a single decimal separator $patternDecimalSeparator''');
    }
    final String patternBeforeSeparator;
    final String patternAfterSeparator;

    if (decimalSeparators.isEmpty) {
      patternBeforeSeparator = pattern;
      patternAfterSeparator = '';
    } else {
      final start = decimalSeparators.first.start;
      final end = decimalSeparators.first.end;
      patternBeforeSeparator = pattern.substring(0, start);
      patternAfterSeparator = pattern.substring(end);
    }

    /// If there is no explicit + or - pattern in either the decimal
    /// or integer pattern then we impliciitly add one in the integer pattern.
    final implicitNegative =
        data.amount.isNegative && !containsPlusOrMinus(pattern);

    final before = _processMajorPart(patternBeforeSeparator, data,
        implicitNegative: implicitNegative);
    final after = _processMinorPart(patternAfterSeparator, data);

    var result = before;

    if (_containsDigits(after)) {
      result = '$result${data.currency.decimalSeparator}$after';
    } else {
      /// the decimal section may have currency, symbols or =-
      /// but no digits, in which case we don't want the decimal
      /// separator
      result = '$result$after';
    }

    return result;
  }

  /// Process integer component
  String _processMajorPart(String pattern, MoneyData data,
      {required bool implicitNegative}) {
    final majorPart = data.integerPart.abs().toString();

    final reversedPattern = pattern.reverse();
    final reversedDigits = majorPart.reverse();

    final isoCode = data.currency.isoCode;
    final reversedSymbol = data.currency.symbol.reverse();

    return processPart(
            pattern: reversedPattern,
            digits: reversedDigits,
            currency: data.currency,
            isoCode: isoCode,
            symbol: reversedSymbol,
            implicitNegative: implicitNegative,
            isNegative: data.amount.isNegative,
            directionReversed: true,
            printAllDigits: true)
        .reverse();
  }

  /// process decimal component
  String _processMinorPart(String pattern, MoneyData data) {
    if (pattern.isEmpty) {
      return '';
    }
    final minorPart =
        _stripTrailingZeros(data.amount.decimalPartAsString(), data);

    final isoCode = data.currency.isoCode.reverse();
    final symbol = data.currency.symbol;

    return processPart(
        pattern: pattern,
        digits: minorPart,
        isoCode: isoCode,
        symbol: symbol,
        currency: data.currency,
        isNegative: data.amount.isNegative,
        implicitNegative: false,
        directionReversed: false,
        printAllDigits: false);
  }

  // Remove all trailing zeros.
  String _stripTrailingZeros(String digits, MoneyData data) =>
      digits.replaceAll(RegExp(r'0+$'), '');

  String processPart(
      {required String pattern,
      required String digits,
      required String isoCode,
      required String symbol,
      required Currency currency,
      required bool isNegative,
      required bool directionReversed,
      required bool printAllDigits,
      required bool implicitNegative}) {
    final formatted = StringBuffer();

    const cRune = 67;
    const sRune = 83;
    const hashRune = 35;
    const minusRune = 45;
    const plusRune = 43;
    const zeroRune = 48;
    final groupSeparatorRune = patternGroupSeparator.runes.first;

    /// We output the digits in the integer part in reverse order
    /// as we travers the pattern in reverse order.
    var digitsIndex = 0;

    /// true once we have output the entire major part.
    var groupSeparatorSeen = false;

    /// If we have seen a digit pattern (0, #) and we encounter
    /// a non-digit pattern then we must flush all remaining digits
    /// as the pattern will often be shorter than the number of digits
    /// and we don't want a symbol in the middle of the digits.
    var digitPatternSeen = false;
    final zeroRuneCount = _countZeros(pattern);
    var lengthOfCurrentGroup = 0;
    var lengthOfLastGroup = 0;
    var optionalDigitPatternSeen = false;

    var totalCurrencyCount = 0;
    for (final rune in pattern.runes) {
      if (rune == cRune) {
        totalCurrencyCount++;
      }
    }

    var isoCodeIndex = totalCurrencyCount - 1;
    var flush = true;

    for (final rune in pattern.runes) {
      if (rune == groupSeparatorRune) {
        if (!digitPatternSeen) {
          throw IllegalPatternException("""
There must be '#' or '0' after the group separator $patternGroupSeparator""");
        }

        /// only output a group seperator if there are more digits
        /// to be written 
        /// or because the number of '0' pattern characters will force
        /// more digits ('0') be written.
        if (digitsIndex < digits.length || digitsIndex < zeroRuneCount - 1) {
          formatted.write(currency.groupSeparator);
          groupSeparatorSeen = true;
          lengthOfLastGroup = lengthOfCurrentGroup;
          lengthOfCurrentGroup = 0;
          isoCodeIndex = totalCurrencyCount - 1;
        }
      } else {
        switch (rune) {
          /// # - optional digit
          case hashRune:
            if (digitsIndex < digits.length) {
              formatted.write(digits[digitsIndex++]);
            } else {}
            lengthOfCurrentGroup++;
            isoCodeIndex = totalCurrencyCount - 1;
            digitPatternSeen = true;
            optionalDigitPatternSeen = true;

          /// 0 - digit or pad with 0
          case zeroRune:
            if (optionalDigitPatternSeen) {
              if (directionReversed) {
                throw IllegalPatternException('0 is invalid before a #');
              } else {
                throw IllegalPatternException('0 is invalid after a #');
              }
            }
            if (digitsIndex < digits.length) {
              formatted.write(digits[digitsIndex++]);
            } else {
              /// we are padding with leading zeros as the
              /// major part has been output.
              formatted.write('0');
            }
            lengthOfCurrentGroup++;
            isoCodeIndex = totalCurrencyCount - 1;
            digitPatternSeen = true;

          /// C -  Currency code
          case cRune:
            if (digitPatternSeen) {
              final flushed = _flushExtraDigits(
                remaining: digits.substring(digitsIndex),
                groupSeparatorSeen: groupSeparatorSeen,
                groupSize: lengthOfLastGroup,
                lengthOfCurrentGroup: lengthOfCurrentGroup,
                groupSeparator: currency.groupSeparator,
                printAllDigits: printAllDigits,
                showNegative: implicitNegative,
              );
              formatted.write(flushed);
              digitsIndex += flushed.length;
              flush = false;
            }

            if (isoCodeIndex == 3) {
              throw IllegalPatternException('''
The "C" character may only appear in a pattern consequitively three times''');
            }

            /// The C pattern is longer than the currencies iso code.
            if (isoCodeIndex < 0) {
              continue;
            }

            if (isoCodeIndex == 2) {
              // we have three Cs so we write the entire isoCode
              // regardless of length.
              formatted.write(isoCode.substring(2).reverse());
            } else {
              formatted.write(isoCode[isoCodeIndex]);
            }
            isoCodeIndex--;

          /// S - currency symbol
          case sRune:
            if (digitPatternSeen) {
              // print(formatted);
              final flushed = _flushExtraDigits(
                  remaining: digits.substring(digitsIndex),
                  groupSeparatorSeen: groupSeparatorSeen,
                  groupSize: lengthOfLastGroup,
                  lengthOfCurrentGroup: lengthOfCurrentGroup,
                  groupSeparator: currency.groupSeparator,
                  printAllDigits: printAllDigits,
                  showNegative: implicitNegative);
              formatted.write(flushed);
              digitsIndex += flushed.length;
              flush = false;
            }
            formatted.write(symbol);
            isoCodeIndex = totalCurrencyCount - 1;
          case minusRune:
            if (digitPatternSeen) {
              final flushed = _flushExtraDigits(
                  remaining: digits.substring(digitsIndex),
                  groupSeparatorSeen: groupSeparatorSeen,
                  groupSize: lengthOfLastGroup,
                  lengthOfCurrentGroup: lengthOfCurrentGroup,
                  groupSeparator: currency.groupSeparator,
                  printAllDigits: printAllDigits,
                  showNegative: implicitNegative);
              formatted.write(flushed);
              digitsIndex += flushed.length;
              flush = false;
            }
            formatted.write(isNegative ? '-' : '');
            isoCodeIndex = totalCurrencyCount - 1;
          case plusRune:
            if (digitPatternSeen) {
              final flushed = _flushExtraDigits(
                  remaining: digits.substring(digitsIndex),
                  groupSeparatorSeen: groupSeparatorSeen,
                  groupSize: lengthOfLastGroup,
                  lengthOfCurrentGroup: lengthOfCurrentGroup,
                  groupSeparator: currency.groupSeparator,
                  printAllDigits: printAllDigits,
                  showNegative: implicitNegative);
              formatted.write(flushed);
              digitsIndex += flushed.length;
              flush = false;
            }
            formatted.write(isNegative ? '-' : '+');
            isoCodeIndex = totalCurrencyCount - 1;

          /// Any un-recognised characters are just output
          /// verbatium
          default:
            if (digitPatternSeen) {
              final flushed = _flushExtraDigits(
                  remaining: digits.substring(digitsIndex),
                  groupSeparatorSeen: groupSeparatorSeen,
                  groupSize: lengthOfLastGroup,
                  lengthOfCurrentGroup: lengthOfCurrentGroup,
                  groupSeparator: currency.groupSeparator,
                  showNegative: implicitNegative,
                  printAllDigits: printAllDigits);
              formatted.write(flushed);
              digitsIndex += flushed.length;
              flush = false;
            }
            formatted.write(String.fromCharCode(rune));
        }
      }
    }

    if (flush) {
      formatted.write(_flushExtraDigits(
          printAllDigits: printAllDigits,
          remaining:
              digitsIndex < digits.length ? digits.substring(digitsIndex) : '',
          groupSeparatorSeen: groupSeparatorSeen,
          groupSize: lengthOfLastGroup,
          lengthOfCurrentGroup: lengthOfCurrentGroup,
          showNegative: implicitNegative,
          groupSeparator: currency.groupSeparator));
    }

    return formatted.toString();
  }

  final regex = RegExp(r'[+\-]');
  bool containsPlusOrMinus(String pattern) => regex.hasMatch(pattern);

  int _countZeros(String input) {
    var count = 0;
    for (var i = 0; i < input.length; i++) {
      if (input[i] == '0') {
        count++;
      }
    }
    return count;
  }

  bool flushed = false;

  /// Flushes out the remaining digits (in reverse order)
  /// inserting the grouping separator every [groupSize] digits.
  /// [remaining] is the substring (in reverse order) of the digits
  /// that haven't been output.
  String _flushExtraDigits({
    required bool printAllDigits,
    required String remaining,
    required int lengthOfCurrentGroup,
    required bool groupSeparatorSeen,
    required int groupSize,
    required String groupSeparator,
    required bool showNegative,
  }) {
    // print('''
    // printAllDigits $printAllDigits
    // remaining $remaining
    // lengthOfCurrentGroup $lengthOfCurrentGroup
    // groupSeparatorSeen $groupSeparatorSeen
    // groupSize $groupSize
    // groupSeparator $groupSeparator
    // showNegative $showNegative
    // ''');
    if (!printAllDigits) {
      return '';
    }

    // If no grouping was seen (groupSize <= 0), simply return the
    // remaining digits.
    if (groupSize <= 0) {
      if (showNegative) {
        remaining += '-';
      }
      return remaining;
    }

    /// trick to get the max int for dart.
    const maxInt = -1 >>> 1;
    final buffer = StringBuffer();

    if (lengthOfCurrentGroup > 1) {
      groupSize = lengthOfCurrentGroup;
    }
    var remainingGroup =
        groupSeparatorSeen ? groupSize - lengthOfCurrentGroup : maxInt;
    for (final digit in remaining.runes) {
      if (remainingGroup == 0) {
        buffer.write(groupSeparator);
        remainingGroup = groupSize;
      }
      buffer.write(String.fromCharCode(digit));
      remainingGroup--;
    }

    if (showNegative) {
      buffer.write('-');
    }

    return buffer.toString();
  }

  bool _containsDigits(String input) {
    final digitRegex = RegExp(r'\d');
    return digitRegex.hasMatch(input);
  }
}
