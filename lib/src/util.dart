import 'package:fixed/fixed.dart';

import 'currency.dart';

/// true if the passed character is a digit.
bool isDigit(String char) {
  if (char.isEmpty) {
    return false;
  }
  final code = char.codeUnitAt(0);

  return code >= 48 && code <= 57;
}

/// Validates precision before it reaches Fixed exponentiation or padding.
int checkDecimalDigits(int decimalDigits) {
  if (decimalDigits < 0 || decimalDigits > Currency.maxDecimalDigits) {
    throw RangeError.range(
        decimalDigits, 0, Currency.maxDecimalDigits, 'decimalDigits');
  }
  return decimalDigits;
}

/// Multiplies bounded operands before rounding to a public precision.
Fixed multiplyAndRescale(Fixed amount, Fixed multiplier, int decimalDigits) {
  checkDecimalDigits(amount.decimalDigits);
  checkDecimalDigits(multiplier.decimalDigits);
  checkDecimalDigits(decimalDigits);

  // Two valid operands can produce up to twice the public precision limit.
  final product = amount * multiplier;
  if (product.decimalDigits < 0 ||
      product.decimalDigits > 2 * Currency.maxDecimalDigits) {
    throw RangeError.range(product.decimalDigits, 0,
        2 * Currency.maxDecimalDigits, 'product.decimalDigits');
  }
  return product.copyWith(decimalDigits: decimalDigits);
}
