/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:fixed/fixed.dart';
import 'package:meta/meta.dart' show immutable, sealed;

import 'currency.dart';
import 'money.dart';
import 'pattern_decoder.dart';
import 'pattern_encoder.dart' show PatternEncoder;

/// DTO for exchange of data between an instance of [Money] and [PatternEncoder]
/// or [PatternDecoder].
@sealed
@immutable
class MoneyData {
  /// Amount of money in the smallest units (e.g. cent for USD).
  final Fixed amount;

  /// The currency
  final Currency currency;

  /// Creates a MoneyData
  const MoneyData.from(this.amount, this.currency);

  /// returns the major currency value of this
  /// MoneyData (e.g. the dollar amount)
  BigInt get integerPart => amount.integerPart;

  BigInt get decimalPart => amount.decimalPart;

  /// returns the minor currency value of this MoneyData (e.g. the cents amount)
  BigInt getMinorUnits() => amount.minorUnits;
}
