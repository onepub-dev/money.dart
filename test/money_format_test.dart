/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:money2/money2.dart';
import 'package:money2/src/pattern_encoder.dart';
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);
  final euro = Currency.create('EUR', 2,
      symbol: '€', invertSeparators: true, pattern: 'S0,00');
  final long = Currency.create('LONG', 2);
  final bitcoin = Currency.create('BTC', 8);

  final usd10d25 = Money.fromInt(1025, usd);
  final usd10 = Money.fromInt(1000, usd);
  final long1000d90 = Money.fromInt(100090, long);
  final btc1satoshi = Money.fromInt(1, bitcoin);

  group('format', () {
    test('Simple Number', () {
      expect(usd10d25.toString(), equals('\$10.25'));
      expect(usd10.format('#.#0'), equals('10.00'));
      expect(usd10d25.format('#'), equals('10'));
      expect(usd10d25.format('#.#'), equals('10.2'));
      expect(usd10d25.format('0.00'), equals('10.25'));
      expect(usd10d25.format('#,##0.##'), equals('10.25'));
      expect(long1000d90.format('#,##0.00'), equals('1,000.90'));
      expect(usd10d25.format('###,000.##'), equals('010.25'));
      expect(usd10d25.format('##.##'), equals('10.25'));
      expect(usd10d25.format('##'), equals('10'));
      expect(btc1satoshi.format('0.00000000'), equals('0.00000001'));
    });

    test('Inverted Decimal Separator', () {
      final eurolarge = Money.fromInt(10000000, euro);
      final euroSmall = Money.fromInt(1099, euro);
      expect(eurolarge.toString(), equals('€100000,00'));
      expect(euroSmall.format('S#'), equals('€10'));
      expect(euroSmall.format('#,#'), equals('10,9'));
      expect(euroSmall.format('CCC#,#0'), equals('EUR10,99'));
      expect(euroSmall.format('###.000,##'), equals('010,99'));
      expect(eurolarge.format('###.000,00'), equals('100.000,00'));
      expect(euroSmall.format('##,##'), equals('10,99'));
      expect(euroSmall.format('##'), equals('10'));
    });
    test('Lead zero USD', () {
      expect(Money.fromInt(310, usd).format('000.##'), equals('003.10'));
      expect(Money.fromInt(301, usd).format('000.##'), equals('003.01'));
      expect(usd10d25.format('000.##'), equals('010.25'));
      expect(usd10d25.format('000'), equals('010'));
    });

    test('trailing zero USD', () {
      expect(usd10d25.format('##.000'), equals('10.250'));
      expect(usd10d25.format('000'), equals('010'));
      expect(Money.fromInt(301, usd).format('000.000'), equals('003.010'));
    });

    test('less than 10 cents USD in minor units', () {
      expect(Money.fromInt(01, usd).toString(), '\$0.01');
      expect(Money.fromInt(301, usd).toString(), '\$3.01');
      expect(Money.fromBigInt(BigInt.from(301), usd).toString(), '\$3.01');
      expect(Money.from(3.01, usd).toString(), '\$3.01');
    });

    test('Symbol tests', () {
      expect(usd10d25.format('S##.##'), equals('\$10.25'));
      expect(usd10.format('S##.00'), equals('\$10.00'));
      expect(usd10.format('##.00 S'), equals('10.00 \$'));
      expect(usd10d25.format('S##'), equals('\$10'));
      expect(usd10d25.format('S##'), equals('\$10'));
      expect(usd10d25.format('S ##'), equals('\$ 10'));
      expect(usd10d25.format('## S'), equals('10 \$'));
    });

    test('Currency tests', () {
      expect(usd10d25.format('C##.##'), equals('U10.25'));
      expect(usd10d25.format('CC##.##'), equals('US10.25'));
      expect(usd10d25.format('CCC##.##'), equals('USD10.25'));
      expect(usd10d25.format('##.##CCC'), equals('10.25USD'));
      expect(usd10d25.format('##.## CCC'), equals('10.25 USD'));
      expect(long1000d90.format('CCC S#,###.00'), equals('LONG \$1,000.90'));
    });

    test('USD combos', () {
      expect(usd10d25.format('SCCC 000,000.##'), equals('\$USD 000,010.25'));
      expect(usd10d25.format('CCC S##.##'), equals('USD \$10.25'));
      expect(usd10d25.format('S ##.## CCC'), equals('\$ 10.25 USD'));
    });

    test('Invalid Patterns', () {
      expect(() => usd10d25.format('0##'),
          throwsA(TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('000,'),
          throwsA(TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('000#'),
          throwsA(TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('0#'),
          throwsA(TypeMatcher<IllegalPatternException>()));
      expect(() => usd10d25.format('0.0#'),
          throwsA(TypeMatcher<IllegalPatternException>()));
    });
  });
}
