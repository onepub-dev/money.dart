/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('CommonCurrency', () {
    test('has a code and a precision', () {
      // Check common currencies are registered.
      expect(Currencies().find('USD'), equals(CommonCurrencies().usd));

      var value = Currencies().parse(r'$USD10.50');
      expect(value, equals(Money.fromIntMinUnit(1050, code: 'USD')));

      // register all common currencies.
      value = Currencies().parse(r'$NZD10.50');
      expect(value, equals(Money.fromIntMinUnit(1050, code: 'NZD')));

      //Test for newly added currency
      value = Currencies().parse('₦NGN4.50');
      expect(value, equals(Money.fromIntMinUnit(450, code: 'NGN')));

      value = Currencies().parse('₵GHS4.50');
      expect(value, equals(Money.fromIntMinUnit(450, code: 'GHS')));
    });

    test('Test Default Formats', () {
      expect(Currencies().find('AUD')!.parse(r'$1234.56').toString(),
          equals(r'$1234.56'));

      expect(Currencies().find('INR')!.parse('₹1234.56').toString(),
          equals('₹1234.56'));
    });

    test('Test 1000 separator', () {
      expect(
          Currencies()
              .find('AUD')!
              .copyWith(pattern: 'S#,###.##')
              .parse(r'$1234.56')
              .toString(),
          equals(r'$1,234.56'));

      expect(
          Currencies()
              .find('INR')!
              .copyWith(pattern: 'S#,###.##')
              .parse('₹1234.56')
              .toString(),
          equals('₹1,234.56'));

      expect(
          Currencies()
              .find('INR')!
              .copyWith(pattern: 'S##,##,###.##')
              .parse('₹1234567.89')
              .toString(),
          equals('₹12,34,567.89'));
    });
  });
}
