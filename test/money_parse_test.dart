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
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);
  final euro = Currency.create('EUR', 2,
      symbol: '€', invertSeparators: true, pattern: '0,00 S');
  // final long = Currency.create('LONG', 2);

  // final Money usd10d25 = Money.fromInt(1025, usd);
  // final Money usd10 = Money.fromInt(1000, usd);
  // final Money long1000d90 = Money.fromInt(100090, long);

  group('Money.parse', () {
    test('Default Currency Pattern', () {
      expect(Money.parse('\$10.25', usd), equals(Money.fromInt(1025, usd)));
      expect(Money.parse('10.25', usd, pattern: '#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Money.parse('USD10.25', usd, pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Money.parse('\$USD10.25', usd, pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Money.parse('1,000.25', usd, pattern: '#.#'),
          equals(Money.fromInt(100025, usd)));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(Money.parse('10,25', euro, pattern: '#,#'),
          equals(Money.fromInt(1025, euro)));
      expect(Money.parse('€10,25', euro, pattern: 'S0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Money.parse('EUR10,25', euro, pattern: 'CCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Money.parse('€EUR10,25', euro, pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Money.parse('1.000,25', euro, pattern: '#.###,00'),
          equals(Money.fromInt(100025, euro)));
      expect(Money.parse('1.000,25', euro, pattern: '#.###,00'),
          equals(Money.fromInt(100025, euro)));
    });

    test(
        'Decode and encode with the same currency should be inverse operations',
        () {
      for (var precision = 2; precision < 5; precision++) {
        final currency = Currency.create('MONEY', precision,
            pattern: '0.${'0' * precision} CCC');
        final stringValue = '1025.${'0' * (precision - 1)}1 MONEY';
        expect(
            Money.parse(stringValue, currency).toString(), equals(stringValue));
      }
    });
  });

  group('Currency.parse', () {
    test('Default Currency Pattern', () {
      expect(usd.parse('\$10.25'), equals(Money.fromInt(1025, usd)));
      expect(
          usd.parse('10.25', pattern: '#.#'), equals(Money.fromInt(1025, usd)));
      expect(usd.parse('USD10.25', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(usd.parse('\$USD10.25', pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(usd.parse('1,000.25', pattern: '#.#'),
          equals(Money.fromInt(100025, usd)));
    });

    test('White space', () {
      expect(usd.parse('\$ 10.25', pattern: 'S #.#'),
          equals(Money.fromInt(1025, usd)));
      expect(usd.parse('\$USD 10.25', pattern: 'SCCC #.#'),
          equals(Money.fromInt(1025, usd)));
      expect(usd.parse('\$ USD 10.25', pattern: 'S CCC #.#'),
          equals(Money.fromInt(1025, usd)));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(euro.parse('10,25', pattern: '#,#'),
          equals(Money.fromInt(1025, euro)));
      expect(euro.parse('€10,25', pattern: 'S0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(euro.parse('EUR10,25', pattern: 'CCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(euro.parse('€EUR10,25', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(euro.parse('1.000,25', pattern: '#.###,00'),
          equals(Money.fromInt(100025, euro)));
      expect(euro.parse('1.000,25', pattern: '#.###,00'),
          equals(Money.fromInt(100025, euro)));
    });
  });

  group('Currencies().parse', () {
    Currencies.register(usd);
    Currencies.register(euro);

    test('Default Currency Pattern', () {
      expect(Currencies.parse('\$USD10.25', 'SCCC0.0'),
          equals(Money.fromInt(1025, usd)));
      expect(Currencies.parse('USD10.25', 'CCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Currencies.parse('USD10.25', 'CCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Currencies.parse('\$USD10.25', 'SCCC#.#'),
          equals(Money.fromInt(1025, usd)));
      expect(Currencies.parse('USD1,000.25', 'CCC#.#'),
          equals(Money.fromInt(100025, usd)));
    });

    test('Inverted Decimal Separator with pattern', () {
      var euro = Currency.create('EUR', 2);
      expect(Currencies.parse('EUR10,25', 'CCC#,#'),
          equals(Money.fromInt(1025, euro)));
      expect(Currencies.parse('€EUR10,25', 'SCCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Currencies.parse('EUR10,25', 'CCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Currencies.parse('€EUR10,25', 'SCCC0,0'),
          equals(Money.fromInt(1025, euro)));
      expect(Currencies.parse('EUR1.000,25', 'CCC#.###,00'),
          equals(Money.fromInt(100025, euro)));
      expect(Currencies.parse('EUR1.000,25', 'CCC#.###,00'),
          equals(Money.fromInt(100025, euro)));
    });
  });

  group('deprecated fromString methods', () {
    test('Money', () {
      expect(
          Money.fromString('\$10.25', usd), equals(Money.fromInt(1025, usd)));
    });

    test('Currency', () {
      expect(usd.parse('\$10.25'), equals(Money.fromInt(1025, usd)));
    });

    test('Currencies', () {
      expect(Currencies.parse('\$USD10.25', 'SCCC0.0'),
          equals(Money.fromInt(1025, usd)));
    });
  });
}
