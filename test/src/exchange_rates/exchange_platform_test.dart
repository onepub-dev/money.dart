/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  test('default decimalDigits ...', ()  {
    final platform = ExchangePlatform();

    final aud = Money.fromNum(1, decimalDigits: 2, isoCode: 'AUD');
    final usd = Money.fromNum(0.75312, decimalDigits: 2, isoCode: 'USD');

    /// use target currency decimalDigits
    platform.register(ExchangeRate.fromFixed(
      Fixed.fromNum(0.75312, decimalDigits: 5),
      fromIsoCode: 'AUD',
      toIsoCode: 'USD',
    ));

    final t1 = platform.exchangeTo(aud, 'USD');
    expect(
        t1, equals(Money.fromNum(0.75312, decimalDigits: 2, isoCode: 'USD')));
    expect(t1.decimalDigits, equals(2));

    /// Use the automatic inverse rate
    final t2 = platform.exchangeTo(usd, 'AUD');
    expect(t2, equals(Money.fromNum(1, decimalDigits: 2, isoCode: 'AUD')));
    expect(t2.decimalDigits, equals(2));
  });

  test('controlled decimal Digits ...', ()  {
    final platform = ExchangePlatform();

    final aud = Money.fromNum(1, decimalDigits: 2, isoCode: 'AUD');
    final usd = Money.fromNum(0.75312, decimalDigits: 5, isoCode: 'USD');

    /// control the target decimal Digits.
    platform.register(ExchangeRate.fromFixed(
        Fixed.fromNum(0.75312, decimalDigits: 5),
        fromIsoCode: 'AUD',
        toIsoCode: 'USD',
        toDecimalDigits: 5));

    final t1 = platform.exchangeTo(aud, 'USD');
    expect(
        t1, equals(Money.fromNum(0.75312, decimalDigits: 5, isoCode: 'USD')));
    expect(t1.decimalDigits, equals(5));

    /// Use the automatic inverse rate
    final t2 = platform.exchangeTo(usd, 'AUD');
    expect(t2, equals(Money.fromNum(1, decimalDigits: 5, isoCode: 'AUD')));
    expect(t2.decimalDigits, equals(5));
  });
}
