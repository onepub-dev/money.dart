# Money2

Money2 is a high‑precision Dart library for representing, parsing, formatting,
and performing arithmetic on monetary values and Currencies.

---

## Overview

Money2 provides safe, precise, and expressive handling of money and currencies.
It’s designed for business and financial applications where accuracy and
predictability are essential — no floating‑point rounding surprises.

### Key features

- Fixed‑precision storage for accurate financial math
- Multi‑currency support, including custom currencies
- Safe arithmetic using the [`Fixed`](https://pub.dev/packages/fixed) decimal type
- Simple parsing and formatting via a clear pattern syntax
- Common currencies generated from ISO data
- Configurable symbols, separators, and decimal digits
- Comprehensive documentation and examples
- JSON serialization and deserialization
- Pure Dart implementation
- Open Source (MIT)
- Using Money2 may even make you taller (unverified claim)

---


## Sponsors

Money2 is sponsored by OnePub, the private Dart package repository.

[OnePub](https://onepub.dev)

You can support Money2 by supporting OnePub.

## How Money2 Handles Currencies

Money2 separates the **currency definition** from the **monetary amount**, letting you
reuse a currency definition.

### CommonCurrencies

Money2 ships with a full list of every world currency. You can see the full details in
[Common Currency List](common_currencies.md).

You can also create your own currencies and override an existing currency definition.

Common Currencies are used implicitly and explicity when parsing monetary amounts.


#### Implicit
Money2 will recognize the 'USD' country code for the list a Common Currencies
and return amount as a USD currency.
```dart
Money amount = Currencies.parse('$USD10.00');
```

#### explicity

Each of the following parse methods will result in a Money object containing 10 US dollars.

```dart
Money amount = Money.parseWithCurrency(r'$USD10.00', CommonCurrency().usd);
Money amount = Money.parseWithCurrency(r'$10.00', CommonCurrency().usd);
Money amount = Money.parse(r'$USD10.00', isoCode: 'USD');
Money amount = Money.parse(r'$10.00', isoCode: 'USD');
```



### Defining a currency

You can also define your own currencies.

Each `Currency` defines:
- **ISO code** — e.g. `USD`, `EUR`, `JPY`
- **decimalDigits** — number of minor‑unit digits (e.g. 2 for cents)
- **symbol** — e.g. `$`, `€`, `¥`
- **pattern** — default output pattern (e.g. `S#,##0.00`)
- **groupSeparator** / **decimalSeparator** — display separators
- Optional metadata: `name`, `unit`, `country`

```dart
final usd = Currency.create(
  'USD',
  3,  // three decimal places
  symbol: r'$',
  pattern: 'S#,##0.000', // trhee decimals
  country: 'United States',
  unit: 'Dollar',
  name: 'United States Dollar',
);

/// Now use your custom currency
Money amount = Money.parseWithCurrency(r'$10.000', usd);
```



### 4) Override CommonCurrencies.

When parsing a monetary amount which includes an isoCode, the parser 
looks through the list of 'registered' currences to find a matching isoCode.

The list of CommonCurrencies are automatically registered.

You can added to the list of registed currencies, or override an existing currency.

This could be useful if for example you wanted to increase the number of decimal places in
every registered currency.


```dart
Currencies().registerList([
  Currency.create('USD', 4),
  Currency.create('EUR', 4),
]);

final amount = Currencies().parse(r'$EUR1500.0000');
print(amount); // €1,500.0000
```

### Currency exchange

Money provides an easy method to convert between currencies.

You use the `ExchangePlatform` to register exchange rates and convert amounts.

```dart
final aud = CommonCurrencies().aud;
final usd = CommonCurrencies().usd;

// Define an exchange rate: 1 AUD = 0.65 USD
final rate = ExchangeRate.fromNum(
  0.65,
  decimalDigits: 8,
  fromIsoCode: 'AUD',
  toIsoCode: 'USD',
);

// register one or more exchange rates.
final platform = ExchangePlatform()..register(rate);

final audAmount = Money.fromNum(100, isoCode: 'AUD');
final usdAmount = platform.exchangeTo(audAmount, 'USD');
print(usdAmount); // $65.00
```

If the reverse rate isn’t registered, Money2 can apply the inverse (configurable).

### Precision & safety

All arithmetic uses the `Fixed` package which provides fixed decimal (scale) precision mathematics — no binary floating‑point drift. 
Each `Money` value keeps the precision (decimal places) defined by its `Currency`.

```dart
final m = Money.parse(r'$0.10', isoCode: 'USD');
print(m.amount);     // Fixed(0.10)
print(m.minorUnits); // 10 (cents)
```



# Wroking with Money

### Storing monetary values (minor units)

`Money` stores values in **minor units** (like cents) using the `Fixed` decimal
type for deterministic math.

```dart
final cost = Money.fromIntWithCurrency(1000, CommonCurrencies().usd);
print(cost); // $10.00

final taxInclusive = cost * 1.1;
print(taxInclusive); // $11.00

print(taxInclusive.minorUnits); // 1100
```

If you need to store a monetory amount in a database or json etc, you should
store the minorUnits or use Money's json serialization to serialize the full 
monetary amount including currency information.

To serialise a Monetary amount use:

```dart
amount.toJson();

amount = Money.fromJson(jsonString);
```        

The output json is of the form:

```
{
   'minorUnits': '1100'
   'decimals': 2,
   'isoCode': 'ISD',
}
```


### ) Parsing & formatting (locale‑agnostic patterns)

Money2 uses simple patterns for parsing and formatting. Patterns are
**locale‑agnostic** in that a pattern uses `,` for thousand grouping and `.` for decimals in patterns,
regardless of a currency’s `groupSeparator`/`decimalSeparator` display settings.
When you format an amount, the pattern separators are replaced with the selected Currencies'
actual separators.

**Pattern symbols**

| Symbol | Meaning            |
|--------|---------------------|
| `S`    | Currency symbol    |
| `C`    | ISO code           |
| `#`    | Digit placeholder  |
| `0`    | Mandatory digit    |
| `.`    | Decimal separator  |
| `,`    | Group separator    |
| `+`    | Always display a +/- symbol |
| `-`    | Display a - symbol if the amount is -ve |



```dart
final parsed = usd.parse(r'$10.00');
print(parsed.format('SCCC 0.00')); // $USD 10.00

final parsed = eur.parse(r'$10.00');
// note the decimal separator is output based on the currency not the pattern.
print(parsed.format('SCCC 0.00+')); // €EUR 10,00+


```

## Design Philosophy

The design choices in Money2 are deliberate and aimed at correctness,
predictability, and long‑term maintainability.

1. **Fixed decimal, never double**  
   Financial values must be exact. We use `Fixed` for deterministic scale and
   rounding. There are no hidden binary rounding errors.

2. **Immutability by default**  
   `Money` and `Currency` act as value types. Operations return new instances;
   inputs aren’t mutated. This simplifies reasoning in complex apps and reduces
   bugs due to aliasing.

3. **Currency‑first modeling**  
   A `Money` value always carries its `Currency`. This prevents mixing amounts
   of different currencies and enables compile‑time and runtime checks.

4. **Locale‑agnostic patterns**  
   Parsing/formatting patterns always use `.` (decimal) and `,` (group) so the
   same format strings work globally. Display separators can still be configured
   per currency for output.

5. **Separation of representation vs. presentation**  
   Internal representation uses minor units and fixed scale (no of decimals); presentation is
   controlled by patterns and separators. This separation keeps math safe and
   output flexible.

6. **Explicit rounding and scale**  
   Calculations preserve scale and apply banker’s rounding (half‑even) where
   required. You can control `decimalDigits` per currency or via APIs that
   accept explicit decimalDigits.

7. **Exchange rates are data, not services**  
   An `ExchangePlatform` is a simple in‑memory registry. You decide where rates
   come from and how they’re refreshed. Money2 focuses on applying rates, not
   fetching them.

8. **Transparent serialization**  
   JSON and DB persistence can store either minorUnits or formatted strings.
   We strongly recommend minorUnits (integers) for lossless storage.

9. **Minimal surprises**  
   Defaults are conservative and explicit. If parsing fails or currencies
   don’t match, we throw clear, typed exceptions.

---

## Examples

```dart
import 'money2.dart';
import 'package:test/test.dart';

void main() {
  final usdCurrency = Currency.create('USD', 2);

  // Create money from an int (minor units).
  final costPrice = Money.fromIntWithCurrency(1000, usdCurrency);
  expect(costPrice.toString(), equals(r'$10.00'));

  final taxInclusive = costPrice * 1.1;
  expect(taxInclusive.toString(), equals(r'$11.00'));

  expect(taxInclusive.format('SCC #.00'), equals(r'$US 11.00'));

  // Parse using the Currency instance.
  final parsed = usdCurrency.parse(r'$10.00');
  expect(parsed.format('SCCC 0.00'), equals(r'$USD 10.00'));

  // From a number in major units.
  final buyPrice = Money.fromNum(10, isoCode: 'AUD');
  expect(buyPrice.toString(), equals(r'$10.00'));

  // From a number with fractional units (not recommended for transport).
  final sellPrice = Money.fromNum(10.50, isoCode: 'AUD');
  expect(sellPrice.toString(), equals(r'$10.50'));
}
```

---

## Upgrading

### Upgrading to v6
- All references to `scale` were renamed to `decimalDigits`.
- The JSON format for `ExchangeRates` changed.

See `CHANGELOG.md` for details.

### Upgrading from v4 to v5+
- `invertSeparator` was replaced by `groupSeparator` and `decimalSeparator`
- Parsing/formatting patterns must always use `,` (group) and `.` (decimal),
  regardless of the currency’s display separators.

If you previously used `invertSeparator: true`, update your currency:

```dart
// v4
final euro = Currency.create('EUR', 2,
  symbol: '€',
  invertSeparators: true,
  pattern: '#.##0,00 S');

// v5+
final euro = Currency.create('EUR', 2,
  symbol: '€',
  groupSeparator: '.',
  decimalSeparator: ',',
  pattern: '#,##0.00 S');
```

Additional changes:
- `PatternDecoder.isCode` → `isIsoCode`
- `CurrencyCode` → `CurrencyIsoCode`
- `scale` → `decimalDigits`
- `ExchangeRate.toScale` members → `toDecimalDigits`

---

## Building

Common currencies are generated by a Dart script:

```bash
dart tool/generate_currencies.dart
```

Currencies are defined in:
```
tool/currencies.yaml
```

---

## Documentation

- Full docs: https://money2.onepub.dev
- API reference: https://pub.dev/documentation/money2/latest/

---

