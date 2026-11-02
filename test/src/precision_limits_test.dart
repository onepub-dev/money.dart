import 'package:decimal/decimal.dart';
import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final usd = CommonCurrencies().usd;
  final eur = CommonCurrencies().euro;
  const limit = Currency.maxDecimalDigits;

  test('multiplication rounds bounded intermediate precision', () {
    final amount = Money.fromIntWithCurrency(123, usd);
    final one = Fixed.fromBigInt(BigInt.from(10).pow(999), decimalDigits: 999);
    final result = amount.multiplyByFixed(one);
    expect(result.minorUnits, BigInt.from(123));
    expect(result.decimalDigits, 2);
    expect(result.currency, usd);
  });

  test('exchange rounds bounded intermediate precision', () {
    final amount = Money.fromIntWithCurrency(123, usd);
    final one = Fixed.fromBigInt(BigInt.from(10).pow(999), decimalDigits: 999);
    final rate = ExchangeRate.fromFixedWithCurrency(one,
        fromCurrency: usd, toCurrency: eur);
    final result = rate.applyRate(amount);
    expect(result.minorUnits, BigInt.from(123));
    expect(result.decimalDigits, 2);
    expect(result.currency, eur);
  });

  test('two maximum precision operands allow a twice-limit product', () {
    final one =
        Fixed.fromBigInt(BigInt.from(10).pow(limit), decimalDigits: limit);
    final amount = Money.fromFixedWithCurrency(one, usd, decimalDigits: limit);
    final product = amount.multiplyByFixed(one);
    expect(product.minorUnits, BigInt.from(100));
    expect(product.decimalDigits, 2);

    final rate = ExchangeRate.fromFixedWithCurrency(one,
        fromCurrency: usd, toCurrency: eur, toDecimalDigits: limit);
    final converted = rate.applyRate(amount);
    expect(converted.minorUnits, one.minorUnits);
    expect(converted.decimalDigits, limit);
  });

  test('inverse exchange rescales a maximum precision amount', () {
    final amount = Money.fromBigIntWithCurrency(BigInt.from(10).pow(limit), eur,
        decimalDigits: limit);
    final rate = ExchangeRate.fromMinorUnitsWithCurrency(100,
        decimalDigits: 2,
        fromCurrency: usd,
        toCurrency: eur,
        toDecimalDigits: 2);

    final result = rate.applyInverseRate(amount);
    expect(result.minorUnits, BigInt.from(100));
    expect(result.decimalDigits, 2);
    expect(result.currency, usd);
  });

  test('inverse exchange preserves rounding after high precision division', () {
    final rate = ExchangeRate.fromMinorUnitsWithCurrency(200,
        decimalDigits: 2,
        fromCurrency: usd,
        toCurrency: eur,
        toDecimalDigits: 2);
    // Dividing 2.0098 and 2.0100 by two gives 1.0049 and the 1.005 tie.
    for (final entry in {20098: 100, 20100: 101, -20098: -100, -20100: -101}
        .entries) {
      final amount = Money.fromBigIntWithCurrency(
          BigInt.from(entry.key) * BigInt.from(10).pow(limit - 4), eur,
          decimalDigits: limit);

      final result = rate.applyInverseRate(amount);
      expect(result.minorUnits, BigInt.from(entry.value));
      expect(result.decimalDigits, 2);
      expect(result.currency, usd);
    }
  });

  test('inverse exchange keeps the to-currency precision default', () {
    final wholeUnits = Currency.create('TEST', 0);
    final rate = ExchangeRate.fromMinorUnitsWithCurrency(100,
        decimalDigits: 2, fromCurrency: wholeUnits, toCurrency: eur);
    final amount = Money.fromBigIntWithCurrency(
        BigInt.from(123) * BigInt.from(10).pow(limit - 2), eur,
        decimalDigits: limit);

    final result = rate.applyInverseRate(amount);
    expect(result.minorUnits, BigInt.from(123));
    expect(result.decimalDigits, 2);
    expect(result.currency, wholeUnits);
  });

  test('external Fixed scales are rejected before rescaling or arithmetic', () {
    final amount = Money.fromIntWithCurrency(123, usd);
    for (final digits in [limit + 1, 1000000000]) {
      // Fixed.fromBigInt stores the scale without allocating a power of ten.
      final excessive = Fixed.fromBigInt(BigInt.one, decimalDigits: digits);
      expect(
          () => Money.fromFixedWithCurrency(excessive, usd), throwsRangeError);
      expect(() => amount.multiplyByFixed(excessive), throwsRangeError);
      expect(
          () => ExchangeRate.fromFixedWithCurrency(excessive,
              fromCurrency: usd, toCurrency: eur),
          throwsRangeError);
    }
  });

  test('currency precision accepts the limit and rejects outside it', () {
    final currency = Currency.create('TEST', limit);
    expect(currency.decimalDigitsFactor, BigInt.from(10).pow(limit));
    expect(Currency.fromJson(currency.toJson()).decimalDigits, limit);
    for (final digits in [-1, limit + 1]) {
      expect(() => Currency.create('TEST', digits), throwsRangeError);
      expect(() => currency.copyWith(decimalDigits: digits), throwsRangeError);
      expect(
          () => Currency.fromJson(
              {...currency.toJson(), 'decimalDigits': digits}),
          throwsRangeError);
    }
  });

  test('Money precision overrides and JSON are bounded', () {
    final money = Money.fromInt(1, isoCode: 'USD', decimalDigits: limit);
    expect(Money.fromJson(money.toJson()).decimalDigits, limit);
    for (final digits in [-1, limit + 1]) {
      final constructors = <Money Function()>[
        () => Money.fromNumWithCurrency(1, usd, decimalDigits: digits),
        () => Money.fromIntWithCurrency(1, usd, decimalDigits: digits),
        () => Money.fromBigIntWithCurrency(BigInt.one, usd,
            decimalDigits: digits),
        () => Money.fromFixedWithCurrency(Fixed.fromInt(1), usd,
            decimalDigits: digits),
        () => Money.fromDecimalWithCurrency(Decimal.one, usd,
            decimalDigits: digits),
        () => money.copyWith(decimalDigits: digits),
        () => money.multiplyByNum(1, digits),
        () => Money.fromJson({...money.toJson(), 'decimals': digits}),
      ];
      for (final construct in constructors) {
        expect(construct, throwsRangeError);
      }
      expect(() => Money.parseWithCurrency('1', usd, decimalDigits: digits),
          throwsA(isA<MoneyParseException>()));
      expect(
          Money.tryParse('1', isoCode: 'USD', decimalDigits: digits), isNull);
    }
  });

  test('ExchangeRate precision fields are bounded independently', () {
    final rate = ExchangeRate.fromBigIntWithCurrency(BigInt.one,
        decimalDigits: limit,
        fromCurrency: usd,
        toCurrency: eur,
        toDecimalDigits: limit);
    expect(
        ExchangeRate.fromJson(rate.toJson()).exchangeRate.decimalDigits, limit);
    for (final digits in [-1, limit + 1]) {
      for (final field in ['decimals', 'toDecimals']) {
        expect(() => ExchangeRate.fromJson({...rate.toJson(), field: digits}),
            throwsRangeError);
      }
      expect(
          () => ExchangeRate.fromNumWithCurrency(1,
              decimalDigits: digits, fromCurrency: usd, toCurrency: eur),
          throwsRangeError);
      expect(
          () => ExchangeRate.fromMinorUnitsWithCurrency(1,
              decimalDigits: digits, fromCurrency: usd, toCurrency: eur),
          throwsRangeError);
      expect(
          () => ExchangeRate.fromBigIntWithCurrency(BigInt.one,
              decimalDigits: digits, fromCurrency: usd, toCurrency: eur),
          throwsRangeError);
      expect(
          () => ExchangeRate.fromFixedWithCurrency(Fixed.fromInt(1),
              fromCurrency: usd, toCurrency: eur, toDecimalDigits: digits),
          throwsRangeError);
    }
  });
}
