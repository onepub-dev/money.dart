import 'package:money2/money2.dart';
import 'package:strings/strings.dart';
import 'package:test/test.dart';

/// This test is designed to ensure that the
/// examples in the README.md and Money gitbook site work correctly.
///
/// As such this file needs to be kept in sync with the
/// Examples section in the README.md and gitbooks.
///

void main() {
  group('README.MD', () {
    test('Examples', () {
      final usdCurrency = Currency.create('USD', 2);

      /// Create money from an int.
      final costPrice = Money.fromIntWithCurrency(1000, usdCurrency);
      expect(costPrice.toString(), equals(r'$10.00'));

      final taxInclusive = costPrice * 1.1;
      expect(taxInclusive.toString(), equals(r'$11.00'));

      expect(taxInclusive.format('SCC #.00'), equals(r'$US 11.00'));

      /// Create money from an String using the `Currency` instance.
      final parsed = usdCurrency.parse(r'$10.00');
      expect(parsed.format('SCCC 0.00'), equals(r'$USD 10.00'));

      /// Create money from an int which contains the MajorUnit (e.g dollars)
      final buyPrice = Money.fromNum(10, isoCode: 'AUD');
      expect(buyPrice.toString(), equals(r'$10.00'));

      /// Create money from a double which contains Major and Minor units
      /// (e.g. dollars and cents)
      /// We don't recommend transporting money as a double as you will get
      /// rounding errors.
      final sellPrice = Money.fromNum(10.50, isoCode: 'AUD');
      expect(sellPrice.toString(), equals(r'$10.50'));
    });
  });

  group('gitbook', () {
    test('Common Currency - example 1', () {
      /// Create a Money instance from the AUD common currency.
      final amount = Money.parse(r'$1.25', isoCode: 'AUD');
      expect(amount.toString(), equals(r'$1.25'));
      expect(amount.format('SCCC 0.00'), equals(r'$AUD 1.25'));

      /// Create a Money instance using the aud field.
      final amount2 = Money.parseWithCurrency(r'$1.25', CommonCurrencies().aud);
      expect(amount2.format('SCC 0.00'), equals(r'$AU 1.25'));

      /// Create a money instance from a Fixed and the USD
      /// common currency.
      final amount3 = Money.fromFixed(Fixed.parse('1.24', decimalDigits: 2),
          isoCode: 'USD');

      expect(amount3.format('S0.00 CCC'), equals(r'$1.24 USD'));
    });

    test('Create Currency - example 1', () {
      // US dollars which have 2 digits after the decimal place
      // using the default patttern: 'S0.00'
      final usd = Currency.create('USD', 2);
      expect(usd.isoCode, equals('USD'));

      // Create currency using a custom pattern
      final usd2 = Currency.create('USD', 2, pattern: 'SCCC 0.00');

      /// we can now use the currency to create a Money instance.
      final amount = Money.parseWithCurrency(r'$1.25', usd2);

      expect(amount.toString(), equals(r'$USD 1.25'));

      // configure everything
      final euro = Currency.create('EUR', 2,
          symbol: '€',
          decimalSeparator: ',',
          groupSeparator: '.',
          pattern: '0,00S',
          country: 'European Union',
          unit: 'Euro',
          name: 'European Union Euro');
      expect(euro.country, equals('European Union'));
    });

    test('register currency', () {
      /// Create currency and replace the CommonCurrency with our
      /// own one.
      final usd = Currency.create('USD', 2);
      Currencies().register(usd);

      /// Change the registered euro currency to have 4 decimal places
      /// Note: CommonCurrencies can't be changed but the registry can.
      final euro = CommonCurrencies().euro.copyWith(decimalDigits: 4);
      Currencies().register(euro);
      final euro4 = Currencies().parse('EUR1500.0');
      expect(euro4.decimalDigits, equals(4));

      /// register a new currency with 8 decimals.
      final doge =
          Currency.create('DODG', 8, symbol: 'Ð', pattern: 'S0.00000000');
      Currencies().register(doge);

      // find a registered currency.
      final nowUseIt = Currencies().find('DODG');
      expect(nowUseIt, isNotNull);
      if (nowUseIt != null) {
        final cost = Money.fromIntWithCurrency(1000000000, nowUseIt);
        expect(cost.toString(), equals('Ð10.00000000'));
      }

      /// restor the common currency so not to affect other tests.
      Currencies().register(CommonCurrencies().euro);
      Currencies().register(CommonCurrencies().usd);
    });

    test('Parse money', () {
      /// Parse the amount using default pattern for AUD.
      final t1 = Money.parse('10.00', isoCode: 'AUD');
      expect(t1.toString(), equals(r'$10.00'));

      final t2 = Money.parse(r'$10.00', isoCode: 'AUD');
      expect(t2.amount, equals(Fixed.fromNum(10.00)));

      /// Parse using an alternate pattern
      final t3 =
          Money.parse(r'$10.00 AUD', isoCode: 'AUD', pattern: 'S0.00 CCC');
      expect(t3.amount, equals(Fixed.parse('10.00', decimalDigits: 2)));
    });

    test('parse with Currency', () {
      /// Parse using a currency.
      final t1 = CommonCurrencies().aud.parse(r'$10.00');
      expect(t1.toString(), equals(r'$10.00'));
      expect(t1.currency.isoCode, equals('AUD'));
    });

    test('parse with unknown currency', () {
      final t1 = Currencies().parse(r'$AUD10.00');
      expect(t1.toString(), equals(r'$10.00'));
      expect(t1.currency.isoCode, equals('AUD'));
    });

    test('Find a currency', () {
      // Find a registered currency via its code.
      final audCurrency = Currencies().find('AUD');
      final audCostPrice = Money.fromIntWithCurrency(899, audCurrency!);
      expect(audCostPrice.currency.isoCode, equals('AUD'));
    });

    test('Default Formatting', () {
      final aud = Currency.create('AUD', 2);
      final costPrice = Money.fromIntWithCurrency(1099, aud);
      expect(costPrice.toString(), equals(r'$10.99'));

      final jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');
      final yenCostPrice = Money.fromIntWithCurrency(1099, jpy);
      expect(yenCostPrice.toString(), equals('¥1099'));

      final euro = Currency.create('EUR', 2,
          symbol: '€',
          decimalSeparator: ',',
          groupSeparator: '.',
          // The pattern MUST use the default group and decimal separators.
          // This allows us to share patterns across currencies.
          pattern: '#,##0.00S');
      final euroCostPrice = Money.fromIntWithCurrency(899, euro);
      expect(euroCostPrice.toString(), equals('8,99€'));

      final euroValue = euro.parse('2,99€');
      expect(euroValue.toString(), equals('2,99€'));
    });

    test('Symbols', () {
      // Create a currency for Japan's yen with the correct symbol
      final jpy = Currency.create('JPY', 0, symbol: '¥');
      expect(jpy.symbol, equals('¥'));
      final euro = Currency.create('EUR', 2, symbol: '€');
      expect(euro.symbol, equals('€'));
    });

    test('Decimal Separator', () {
      final euro = Currency.create('EUR', 2,
          symbol: '€',
          decimalSeparator: ',',
          groupSeparator: '.',
          pattern: 'S0,000.00');

      expect(euro.decimalSeparator, equals(','));
    });

    test('Group Separator', () {
      final euro = Currency.create('EUR', 2,
          symbol: '€',
          decimalSeparator: ',',
          groupSeparator: '.',
          pattern: 'S0,000.00');

      expect(euro.groupSeparator, equals('.'));
    });

    test('Money.parse', () {
      final usd = Currency.create('USD', 2);
      final amount = Money.parseWithCurrency(r'$10.25', usd);
      expect(amount.currency.isoCode, equals('USD'));
    });

    test('Money.parse with Pattern', () {
      final usd = Currency.create('USD', 2);
      final amount = Money.parseWithCurrency(r'$10.25', usd, pattern: 'S0.00');
      expect(amount.currency.isoCode, equals('USD'));
    });

    group('Currency.parse', () {
      test('parse with Currency', () {
        /// Parse using a currency.
        final t1 = CommonCurrencies().aud.parse(r'$10.00');
        expect(t1.toString(), equals(r'$10.00'));
        expect(t1.currency.isoCode, equals('AUD'));
      });

      test('Parse with pattern', () {
        final t2 = CommonCurrencies().aud.parse(r'10.00$', pattern: '0.00S');
        expect(t2.toString(), equals(r'$10.00'));
        expect(t2.currency.isoCode, equals('AUD'));
      });
    });

    group('Money.from', () {
      test('parse with Currency', () {
        // create one (1) australian dollar
        Money.fromFixed(Fixed.fromInt(100), isoCode: 'AUD');

        Money.parse(r'$1.00', isoCode: 'AUD');

        Money.fromFixedWithCurrency(Fixed.fromInt(100), CommonCurrencies().aud);

        Money.parseWithCurrency(r'$1.00', CommonCurrencies().aud);

        /// Create a money value of $5.10 usd from an int
        Money.fromInt(510, isoCode: 'USD');

        /// Create a money value of ¥25010 from a big int.
        Money.fromBigInt(BigInt.from(25010), isoCode: 'JPY');
      });
    });

    group('Currencies.from', () {
      test('parse with Currency', () {
        Currencies().parse(r'$USD10.25', pattern: 'SCCC0.0');
        Currencies().parse('JPY100', pattern: 'CCC0');
      });
    });

    group('decimalDigits', () {
      test('parse with Currency', () {
        final aud = Currency.create('AUD', 2);
        expect(aud.decimalDigits, equals(2));
      });

      test('parsing', () {
        final aud = Currency.create('AUD', 2);
        final one = aud.parse(r'$1.12345');
        expect(one.minorUnits.toInt(), equals(112));
      });

      test('formatting', () {
        final aud = Currency.create('AUD', 2);
        final one = aud.parse(r'$1.12345');
        expect(one.format('#.###'), equals('1.12'));
      });

      test('formatting - trailing zeros', () {
        final aud = Currency.create('AUD', 2);
        final one = aud.parse(r'$1.12345');
        expect(one.format('0.000'), equals('1.120'));
      });

      test('formatting - trailing zeros', () {
        CommonCurrencies().aud.copyWith(decimalDigits: 4);
        Currency.create('AUD', 4, pattern: '0.0000');
      });

      test('formatting - trailing zeros', () {
        Currencies()
            .register(CommonCurrencies().aud.copyWith(decimalDigits: 5));
        expect(Currencies().find('AUD')!.decimalDigits, equals(5));

        /// restore registry
        Currencies().register(CommonCurrencies().aud);
      });
    });

    group('Formatting', () {
      test('formatting', () {
        final usd = Currency.create('USD', 2);
        final one = Money.fromIntWithCurrency(100, usd);
        expect(one.format('S0'), equals(r'$1'));
      });
    });

    group('Formatting Patterns', () {
      test('formatting', () {
        var usd = Currency.create('USD', 2);
        final lowPrice = Money.fromIntWithCurrency(1099, usd);
        expect(lowPrice.format('S000.000'), equals(r'$010.990'));

        var costPrice =
            Money.fromIntWithCurrency(10034530, usd); // 100,345.30 usd

        expect(costPrice.format('###,###.00'), equals('100,345.30'));

        expect(costPrice.format('S###,###.##'), equals(r'$100,345.3'));

        expect(costPrice.format('CC###,###.00'), equals('US100,345.30'));

        expect(costPrice.format('CCC###,###.##'), equals('USD100,345.3'));

        expect(costPrice.format('SCC###,###.00'), equals(r'$US100,345.30'));

        usd = Currency.create('USD', 2);
        costPrice = Money.fromIntWithCurrency(10034530, usd); // 100,345.30 usd
        expect(costPrice.format('SCC###,###.##'), equals(r'$US100,345.3'));

        final jpy = Currency.create('JPY', 0, symbol: '¥');
        costPrice = Money.fromIntWithCurrency(345, jpy); // 345 yen
        expect(costPrice.format('SCCC#'), equals('¥JPY345'));

// Bahraini dinar
        final bhd = Currency.create('BHD', 3,
            symbol: 'BD', decimalSeparator: ',', groupSeparator: '.');
        costPrice = Money.fromIntWithCurrency(100345, bhd); // 100.345 bhd
        expect(costPrice.format('SCCC0000.000'), equals('BDBHD0100,345'));
      });
    });
  });

  group('Storing and Send', () {
    test('formatting', () {
      final money = Money.fromInt(1025, isoCode: 'USD');
      final moneyJson = money.toJson();

      final expectedJson = <String, dynamic>{
        'minorUnits': '1025',
        'decimals': 2,
        'isoCode': 'USD',
      };

      expect(moneyJson, equals(expectedJson));

      final retrievedAmount = Money.fromJson(moneyJson);
      expect(retrievedAmount.minorUnits.toInt(), equals(1025));
      expect(retrievedAmount.decimalDigits, equals(2));
      expect(retrievedAmount.currency.isoCode, equals('USD'));
    });
  });

  group('Exchange Rates', () {
    test('exchange rate', () {
      /// Create the AUD invoice amount ($10.00)
      final invoiceAmount = Money.fromInt(1000, isoCode: 'AUD');
      expect(invoiceAmount.format('SCCC 0.00'), equals(r'$AUD 10.00'));

      /// Define the exchange rate in USD (0.68c)
      final auToUsExchangeRate = ExchangeRate.fromFixed(
          Fixed.parse('0.75432', decimalDigits: 5),
          fromIsoCode: 'AUD',
          toIsoCode: 'USD',
          toDecimalDigits: 5);
      expect(auToUsExchangeRate.format('0.00000'), equals('0.75432'));

      /// Now do the conversion.
      final usdAmount = invoiceAmount.exchangeTo(auToUsExchangeRate);
      expect(usdAmount.format('SCCC 0.00'), equals(r'$USD 7.54'));
    });
  });

  group('Currency Predicates', () {
    test('isInCurrency', () {
      final fiveDollars = Money.parse('5.00', isoCode: 'USD');
      final sevenDollars = Money.parse('7.00', isoCode: 'USD');
      final fiveEuros = Money.parse('5.00', isoCode: 'EUR');
      expect(fiveDollars.isInCurrency(CommonCurrencies().usd.isoCode),
          isTrue); // => true
      expect(fiveDollars.isInCurrency(CommonCurrencies().euro.isoCode),
          isFalse); // => false
      expect(fiveDollars.isInSameCurrencyAs(sevenDollars), isTrue); // => true
      expect(fiveDollars.isInSameCurrencyAs(fiveEuros), isFalse); // => false
    });
  });

  group('Arithmetic Operations', () {
    test('MultiplyByFixed', () {
      final kr = Currency.create('KR', 0);
      final amount = Money.parseWithCurrency('100', kr, pattern: 'S0');
      final halfish = amount.multiplyByFixed(Fixed.parse(
        '0.4',
      ));
      expect(halfish, equals(Money.fromIntWithCurrency(40, kr)));
      expect(halfish.decimalDigits, equals(0));
    });

    test('Multiply by num', () {
      /// Create the KR currency with 0 decimal digits.
      final kr = Currency.create('KR', 0);

      /// parse '100' to get a Money storing KR100.
      final amount = Money.parseWithCurrency('100', kr, pattern: 'S0');

      /// Multiply by 0.4 to get KR40
      final halfish = amount * 0.4;
      expect(halfish, equals(Money.fromIntWithCurrency(40, kr)));

      /// scale of the results is 0 as dictated by the Currency.
      expect(halfish.decimalDigits, equals(0));
    });

    test('Operators', () {
      final fiveDollars = Money.parse('5.00', isoCode: 'USD');
      final tenDollars = fiveDollars + fiveDollars;
      expect(tenDollars.minorUnits.toInt(), equals(1000));
      final zeroDollars = fiveDollars - fiveDollars;
      expect(zeroDollars.minorUnits.toInt(), equals(0));

      final fifteenCents = Money.fromBigInt(BigInt.from(15), isoCode: 'USD');

      final thirtyCents = fifteenCents * 2; // $0.30
      expect(thirtyCents.minorUnits.toInt(), equals(30));
      final eightCents = fifteenCents * 0.5; // $0.08 (rounded from 0.075)
      expect(eightCents.minorUnits.toInt(), equals(8));
    });
  });

  group('Allocation', () {
    test('Ratio', () {
      final usd = CommonCurrencies().usd;
      final profit = Money.fromBigIntWithCurrency(BigInt.from(5), usd); // 5¢

      var allocation = profit.allocationAccordingTo([70, 30]);
      expect(allocation[0],
          equals(Money.fromBigIntWithCurrency(BigInt.from(4), usd))); // 4¢
      expect(allocation[1],
          equals(Money.fromBigIntWithCurrency(BigInt.from(1), usd))); // 1¢

      /// The order of ratios is important:
      allocation = profit.allocationAccordingTo([30, 70]);
      expect(allocation[0],
          equals(Money.fromBigIntWithCurrency(BigInt.from(2), usd))); // 2¢
      expect(allocation[1],
          equals(Money.fromBigIntWithCurrency(BigInt.from(3), usd))); // 3¢
    });

    test('N Targest', () {
      final usd = CommonCurrencies().usd;

      final value =
          Money.fromBigIntWithCurrency(BigInt.from(800), usd); // $8.00

      final allocation = value.allocationTo(3);
      expect(allocation[0],
          equals(Money.fromBigIntWithCurrency(BigInt.from(267), usd))); // $2.67
      expect(allocation[1],
          equals(Money.fromBigIntWithCurrency(BigInt.from(267), usd))); // $2.67
      expect(allocation[2],
          equals(Money.fromBigIntWithCurrency(BigInt.from(266), usd))); // $2.66
    });
  });

  group('Money encoding/decoding', () {
    test('Encoding', () {
      final fiveDollars = Money.parse('5.00', isoCode: 'USD');
      final encoded = fiveDollars.encodedBy(MoneyToStringEncoder());
      expect(encoded, equals('USD 5.00'));
    });
  });
}

class MoneyToStringEncoder implements MoneyEncoder<String> {
  @override
  String encode(MoneyData data) {
    // Receives MoneyData DTO and produce
    // a string representation of money value...
    final major = data.integerPart.toString();
    final minor = data.decimalPart.toString();

    return '${data.currency.isoCode} $major.${Strings.padRight(minor, 2, '0')}';
  }
}
