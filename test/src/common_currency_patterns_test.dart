/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';


void main() {
  /// Tests that each common currency can format a Money instance
  group('common currency patterns', () {
    for (final currency in CommonCurrencies().asList()) {
      test('${currency.isoCode} formats with its pattern', () {
        final money = Money.fromIntWithCurrency(1, currency);

        final formatted = money.toString();
        expect(formatted, isNotEmpty);
      });
    }
  });
}
