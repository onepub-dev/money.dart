/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('CommonCurrency', () {
    test('has an isoCode and a precision', () {
      // Check common currencies are registered.
      expect(Currencies().find('USD'), equals(CommonCurrencies().usd));

      var value = Currencies().parse(r'$USD10.50');
      expect(value, equals(Money.fromInt(1050, isoCode: 'USD')));

      // register all common currencies.
      value = Currencies().parse(r'$NZD10.50');
      expect(value, equals(Money.fromInt(1050, isoCode: 'NZD')));

      //Test for newly added currency
      value = Currencies().parse('₦NGN4.50');
      expect(value, equals(Money.fromInt(450, isoCode: 'NGN')));

      value = Currencies().parse('₵GHS4.50');
      expect(value, equals(Money.fromInt(450, isoCode: 'GHS')));
    });

    test('Test Default Formats', () {
      expect(Currencies().find('AUD')!.parse(r'$1234.56').toString(),
          equals(r'$1,234.56'));

      expect(Currencies().find('INR')!.parse('₹1234.56').toString(),
          equals('₹1,234.56'));
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

    test('group separators', () {
      final money = Money.fromInt(33900000, decimalDigits: 0, isoCode: 'USD');
      expect(money.toString(), r'$33,900,000.00');
      // AUD
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().aud)
              .toString(),
          equals(r'$31,234,567.00'));

      // usd
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().usd)
              .toString(),
          equals(r'$31,234,567.00'));

      /// Algerian Dinar
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().dzd)
              .toString(),
          equals('31,234,567.00د.ج'));

      /// Armenian Dram
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().amd)
              .toString(),
          equals('31,234,567.00֏'));

      /// Bahraini Dinar
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().bhd)
              .toString(),
          equals('31,234,567.000.د.ب'));

      /// Bitcoin
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().btc)
              .toString(),
          equals('₿31,234,567.00000000'));

      /// Burundian Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().bif)
              .toString(),
          equals('FBu31,234,567'));

      /// Central African CFA Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().xaf)
              .toString(),
          equals('FCFA31 234 567'));

      /// CFP Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().xpf)
              .toString(),
          equals('F31,234,567'));

      /// Chilean Peso
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().clp)
              .toString(),
          equals(r'$31,234,567'));

      /// Colombian Peso
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().cop)
              .toString(),
          equals(r'31.234.567,00$'));

      /// Comorian Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().kmf)
              .toString(),
          equals('CF31,234,567'));

      /// Czech Koruna
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().czk)
              .toString(),
          equals('31.234.567,00Kč'));

      /// Djiboutian Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().djf)
              .toString(),
          equals('Fdj31,234,567'));

      /// European Union Euro
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().euro)
              .toString(),
          equals('31.234.567,00€'));

      /// Guinean Franc
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().gnf)
              .toString(),
          equals('FG31,234,567'));

      /// Hungarian Forint
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().huf)
              .toString(),
          equals('Ft31,234,567'));

      /// Icelandic Krona
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().isk)
              .toString(),
          equals('kr31,234,567'));

      /// Indian Rupee
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().inr)
              .toString(),
          equals('₹3,12,34,567.00'));

      /// Iraqi Dinar
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().iqd)
              .toString(),
          equals('31,234,567.000ع.د'));

      /// Japanese Yen
      expect(
          Money.fromIntWithCurrency(
                  31234567, decimalDigits: 0, CommonCurrencies().jpy)
              .toString(),
          equals('¥31,234,567'));

      // single
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,#,###'))
              .toString(),
          equals('3,1,2,3,4,567'));
      // default
      expect(
          Money.fromIntWithCurrency(
                  31234567,
                  decimalDigits: 0,
                  Currency.create('AU', 6, pattern: '#,###'))
              .toString(),
          equals('31,234,567'));
    });
  });
}
