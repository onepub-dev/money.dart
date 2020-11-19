import 'dart:math';

import 'package:intl/intl.dart';

import 'encoders.dart';
import 'money.dart';
import 'money_data.dart';

/// Encodes a monetary value based on a pattern.
class PatternEncoder implements MoneyEncoder<String> {
  /// the amount to encode
  Money money;

  /// the pattern to encode to.
  String pattern;

  ///
  PatternEncoder(
    this.money,
    this.pattern,
  );

  @override
  String encode(MoneyData data) {
    String formatted;

    var decimalSeperatorCount =
        data.currency.decimalSeparator.allMatches(pattern).length;

    if (decimalSeperatorCount > 1) {
      throw IllegalPatternException(
          "A format Pattern may contain, at most, a single decimal "
          "separator '${data.currency.decimalSeparator}'");
    }

    var decimalSeparatorIndex = pattern.indexOf(data.currency.decimalSeparator);

    var hasMinor = true;
    if (decimalSeparatorIndex == -1) {
      decimalSeparatorIndex = pattern.length;
      hasMinor = false;
    }

    var majorPattern = pattern.substring(0, decimalSeparatorIndex);

    formatted = formatMajorPart(data, majorPattern);
    if (hasMinor) {
      var minorPattern = pattern.substring(decimalSeparatorIndex + 1);
      formatted +=
          data.currency.decimalSeparator + formatMinorPart(data, minorPattern);
    }

    return formatted;
  }

  /// Formats the major part of the [data].
  String formatMajorPart(MoneyData data, String majorPattern) {
    var formatted = '';

    // extract the contiguous money components made up of 0 # , and .
    var moneyPattern = getMoneyPattern(majorPattern);
    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: false);

    var majorUnits = data.getMajorUnits();

    var formattedMajorUnits =
        getFormattedMajorUnits(data, moneyPattern, majorUnits);

    // replace the the money components with a single #
    majorPattern = compressMoney(majorPattern);

    var code = getCode(data, majorPattern);
    // replaces multiple C's with a single C
    majorPattern = compressC(majorPattern);

    // checks we have only one S.
    validateS(majorPattern);

    // Replace the compressed patterns with actual values.
    // The periods and commas have already been removed from the pattern.
    for (var i = 0; i < majorPattern.length; i++) {
      var char = majorPattern[i];
      switch (char) {
        case 'S':
          formatted += data.currency.symbol;
          break;
        case 'C':
          formatted += code;
          break;
        case '#':
          formatted += formattedMajorUnits;
          break;
          break;
        case ' ':
          formatted += ' ';
          break;
        case '0':
        case ',':
        case '.':
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }

    return formatted;
  }

  ///
  String getFormattedMajorUnits(
      MoneyData data, String moneyPattern, BigInt majorUnits) {
    if (data.currency.invertSeparators) {
      // the NumberFormat doesn't like the inverted characters
      // so we normalise them for the conversion.
      moneyPattern = moneyPattern.replaceAll('.', ',');
    }
    // format the no. into that pattern.
    var formattedMajorUnits =
        NumberFormat(moneyPattern).format(majorUnits.toInt());

    if (data.currency.invertSeparators) {
      // Now convert them back
      formattedMajorUnits = formattedMajorUnits.replaceAll(',', '.');
    }
    return formattedMajorUnits;
  }

  /// returns the currency code from [data] using the
  /// supplied [pattern] to find the code.
  String getCode(MoneyData data, String pattern) {
    // find the contigous 'C'
    var codeLength = 'C'.allMatches(pattern).length;

    // get the code based on the no. of C's.
    String code;
    if (codeLength == 3) {
      // Three Cs means the whole code.
      code = data.currency.code;
    } else {
      code = data.currency.code
          .substring(0, min(codeLength, data.currency.code.length));
    }
    return code;
  }

  /// MinorUnits use trailing zeros, MajorUnits use leading zeros.
  String getMoneyPattern(String pattern) {
    var foundMoney = false;
    var inMoney = false;
    var moneyPattern = '';
    for (var i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      switch (char) {
        case 'S':
          inMoney = false;
          break;
        case 'C':
          inMoney = false;
          break;
        case '#':
          inMoney = true;
          foundMoney = true;

          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '#';
          break;
        case '0':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '0';
          inMoney = true;
          foundMoney = true;
          break;
        case ',':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += ',';
          inMoney = true;
          foundMoney = true;

          break;
        case '.':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '.';
          inMoney = true;
          foundMoney = true;

          break;
        case ' ':
          inMoney = false;
          break;
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }
    return moneyPattern;
  }

  ///
  String formatMinorPart(MoneyData data, String minorPattern) {
    var formatted = '';
    // extract the contiguous money components made up of 0 # , and .
    var moneyPattern = getMoneyPattern(minorPattern);

    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: true);

    var paddedTo = 0;
    var firstZero = moneyPattern.indexOf('0');
    if (firstZero != -1) {
      paddedTo = moneyPattern.length;
    }

    var minorUnits = data.getMinorUnits();
    // format the no. into that pattern.
    // in order for Number format to format single digit minor unit properly
    // with proper 0s, we first add [minorDigitsFactor] and then strip the 1
    // after being formatted.
    //
    // e.g., using ## to format 1 would result in 1, but we want it
    // formatted as 01 because it is really the decimal part of the number.
    var formattedMinorUnits = NumberFormat(moneyPattern)
        .format((minorUnits + data.currency.minorDigitsFactor).toInt())
        .substring(1);
    if (moneyPattern.length < formattedMinorUnits.length) {
      // money pattern is short, so we need to force a truncation as
      // NumberFormat doesn't know we are dealing with minor units.
      formattedMinorUnits =
          formattedMinorUnits.substring(0, moneyPattern.length);
    }

    // replace the the money components with a single #
    minorPattern = compressMoney(minorPattern);

    var code = getCode(data, minorPattern);
    // replaces multiple C's with a single S
    minorPattern = compressC(minorPattern);

    // checks we have only one S.
    validateS(minorPattern);

    // expand the pattern
    for (var i = 0; i < minorPattern.length; i++) {
      var char = minorPattern[i];
      switch (char) {
        case 'S':
          formatted += data.currency.symbol;
          break;
        case 'C':
          formatted += code;
          break;
        case '#':
          formatted += formattedMinorUnits;
          break;
        case ' ':
          formatted += ' ';
          break;
        case '0':
        case ',':
        case '.':
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }

    // Fixed problems caused by passing a int to the NumberFormat
    // when we are trying to format a decimal.
    // Move leading zeros to the end when minor units >= 10 - i.e.,
    // we want to keep the leading zeros for single digit cents.
    if (minorUnits.toInt() >= 10) {
      formatted = invertZeros(formatted);
    }
    // Add trailing zeros.

    if (paddedTo != 0) formatted = formatted.padRight(paddedTo, '0');

    return formatted;
  }

  /// counts the no. of # and 0s in the pattern before the decimal seperator.
  int countMajorPatternDigits(String pattern, String decimalSeparator) {
    var count = 0;
    for (var i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      if (char == decimalSeparator) {
        break;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  /// counts the no. of # and 0s in the pattern before the decimal separator.
  int countMinorPatternDigits(String pattern, String decimalSeparator) {
    var count = 0;
    var foundDecimalSeparator = false;

    for (var i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      if (char == decimalSeparator) {
        foundDecimalSeparator = true;
      }

      if (!foundDecimalSeparator) {
        continue;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  ///
  void isMoneyAllowed(
      {required bool inMoney, required bool foundMoney, required int pos}) {
    if (!inMoney && foundMoney) {
      throw IllegalPatternException('Found a 0 at location $pos. '
          'All money characters (0#,.)must be contiguous');
    }
  }

  /// Compresses multiple currency pattern characters 'CCC' into a single
  /// 'C'.
  String compressC(String majorPattern) {
    // replaced with a single C.
    majorPattern = majorPattern.replaceAll(RegExp(r'[C]+'), 'C');

    if ('C'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single contigous group of 'C's");
    }
    return majorPattern;
  }

  ///
  void validateS(String majorPattern) {
    // check for at most single S
    if ('S'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single 'S's");
    }
  }

  ///
  String compressMoney(String majorPattern) {
    return majorPattern.replaceAll(RegExp(r'[#|0|,|\.]+'), '#');
  }

  ///
  void checkZeros(String moneyPattern, String thousandSeparator,
      {required bool minor}) {
    if (!moneyPattern.contains('0')) return;

    var illegalPattern = IllegalPatternException(
        '''The '0' pattern characters must only be at the end of the pattern for ${(minor ? 'Minor' : 'Major')} Units''');

    // compress zeros so we have only one which should be at the end,
    // unless we have thousand separators then we can have several 0s e.g. 0,0,0
    moneyPattern = moneyPattern.replaceAll(RegExp(r'0+'), '0');

    // last char must be a zero (i.e. thousand separater not allowed here)
    if (moneyPattern[moneyPattern.length - 1] != '0') throw illegalPattern;

    // check that zeros are the trailing character.
    // if the pattern has thousand separators then there can be more than one 0.
    var zerosEnded = false;
    var len = moneyPattern.length - 1;
    for (var i = len; i > 0; i--) {
      var char = moneyPattern[i];
      var isValid = char == '0';

      // when looking at the intial zeros a thousand separator
      // is consider  valid.
      if (!zerosEnded) isValid &= char == thousandSeparator;

      if (isValid && zerosEnded) {
        throw illegalPattern;
      }
      if (!isValid) zerosEnded = true;
    }
  }

  /// move leading zeros to the end of the string.
  String invertZeros(String formatted) {
    var trailingZeros = '';
    var result = '';
    for (var i = 0; i < formatted.length; i++) {
      var char = formatted[i];

      if (char == '0' && result.isEmpty) {
        trailingZeros += '0';
      } else {
        result += char;
      }
    }
    return result + trailingZeros;
  }
}

/// Thrown when you pass an invalid pattern to [Money.format].
class IllegalPatternException implements Exception {
  /// the error
  String message;

  ///
  IllegalPatternException(this.message);

  @override
  String toString() => message;
}
