# Money2

Money2 is a high-precision Dart library for representing, parsing, formatting,
and performing arithmetic on monetary values and currencies.

---

## Overview

Money2 provides safe, precise, and expressive handling of money and currencies.
It’s designed for business and financial applications where accuracy and
predictability are essential — no floating-point rounding surprises.

### Key Features

- Fixed-precision storage for accurate financial math  
- Multi-currency support, including custom currencies  
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

Money2 is sponsored by [OnePub](https://onepub.dev), the private Dart package repository.  
You can support Money2 by supporting OnePub.

---

## How Money2 Handles Currencies

Money2 separates the **currency definition** from the **monetary amount**, allowing you
to reuse and customize currency definitions.

### CommonCurrencies

Money2 ships with a full list of world currencies. You can view the complete list in  
[Common Currency List](https://github.com/onepub-dev/money.dart/blob/master/common_currencies.md).

You can also create your own currencies or override existing definitions.

Common currencies are used implicitly or explicitly when parsing monetary amounts.

#### Implicit

Money2 will recognize ISO currency codes (e.g. `USD`) from the registered CommonCurrencies list
and automatically use the correct currency.

```dart
Money amount = Currencies.parse(r'$USD10.00');
```

#### Explicit

Each of the following methods produces a `Money` object containing 10 US dollars:

```dart
Money amount = Money.parseWithCurrency(r'$USD10.00', CommonCurrencies().usd);
Money amount = Money.parseWithCurrency(r'$10.00', CommonCurrencies().usd);
Money amount = Money.parse(r'$USD10.00', isoCode: 'USD');
Money amount = Money.parse(r'$10.00', isoCode: 'USD');
```

---

### Defining a Custom Currency

You can define your own currencies using `Currency.create`.

Each `Currency` defines:

- **ISO code** — e.g. `USD`, `EUR`, `JPY`  
- **decimalDigits** — number of minor-unit digits (e.g. 2 for cents)  
- **symbol** — e.g. `$`, `€`, `¥`  
- **pattern** — default output pattern (e.g. `S#,##0.00`)  
- **groupSeparator** / **decimalSeparator** — display separators  
- Optional metadata: `name`, `unit`, `country`

```dart
final usd = Currency.create(
  'USD',
  3, // three decimal places
  symbol: r'$',
  pattern: 'S#,##0.000', // three decimal places
  country: 'United States',
  unit: 'Dollar',
  name: 'United States Dollar',
);

// Now use your custom currency
Money amount = Money.parseWithCurrency(r'$10.000', usd);
```

---

### Overriding CommonCurrencies

When parsing an amount that includes an ISO code, the parser searches all
**registered** currencies for a match.  
The CommonCurrencies list is automatically registered, but you can register
additional currencies or override existing ones.

For example, you might want to increase the number of decimal places:

```dart
Currencies().registerList([
  Currency.create('USD', 4, pattern: 'S#,###.####'),
  Currency.create('EUR', 4, decimalSeparator: ',', groupSeparator:'.'
      , pattern: 'S#,###.####'),
]);

final amount = Currencies().parse(r'$EUR1500');
print(amount); // €1.500,0000
```

---

### Currency Exchange

Money2 provides an easy way to convert between currencies using `ExchangePlatform`.

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

// Register one or more exchange rates.
final platform = ExchangePlatform()..register(rate);

final audAmount = Money.fromNum(100, isoCode: 'AUD');
final usdAmount = platform.exchangeTo(audAmount, 'USD');
print(usdAmount); // $65.00
```

If the reverse rate isn’t registered, Money2 can apply the inverse automatically (configurable).

---

### Precision & Safety

All arithmetic uses the `Fixed` package for fixed-scale (decimal places) operations — no binary
floating-point drift.  
Each `Money` value retains the precision defined by its `Currency`.

```dart
final m = Money.parse(r'$0.10', isoCode: 'USD');
print(m.amount);     // Fixed(0.10)
print(m.minorUnits); // 10 (cents)
```

---

# Working with Money

# Creating Money Instances

Money2 provides multiple constructors for creating `Money` objects, depending
on your data source and precision requirements.

All constructors require either a `Currency` instance or an ISO code
that matches a registered currency (e.g. from `CommonCurrencies`).

## 1. From integer minor units

Use `Money.fromIntWithCurrency()` or `Money.fromInt()` when you already
have amounts in minor units (e.g. cents, pence).

```dart
final usd = CommonCurrencies().usd;
final amount = Money.fromIntWithCurrency(1050, usd);
print(amount); // $10.50
```

If you have an ISO code instead of a `Currency`:
```dart
final amount = Money.fromInt(1050, isoCode: 'USD');
print(amount); // $10.50
```


---

## 2. From numeric (major units)

Use `Money.fromNum()` when your source value is in major units (e.g. 10.50 dollars).
Money2 converts this into the correct minor units internally using the currency’s scale.

```dart
final amount = Money.fromNum(10.50, isoCode: 'USD');
print(amount); // $10.50
```

⚠️ **Note:** Avoid using `double` for storage or transport — it may introduce binary rounding errors.  
Always prefer integer minor units when persisting data.

---

## 3. From strings (parsing)

Use `Money.parse()` or `Money.parseWithCurrency()` to create money from formatted strings.

```dart
final amount = Money.parse(r'$USD10.50');
print(amount); // $10.50

final usd = CommonCurrencies().usd;
final parsed = Money.parseWithCurrency(r'$10.50', usd);
print(parsed); // $10.50
```

Patterns are flexible — see the “Parsing & Formatting” section for details.

---

## 4. Using the Currency factory

Create a `Currency` once, then use it to create multiple `Money` instances.

```dart
final aud = Currency.create('AUD', 2, symbol: r'$', country: 'Australia');

final price = Money.fromIntWithCurrency(1999, aud);
final discount = Money.fromNum(5.50, isoCode: 'AUD');
```

---

## 5. From JSON

Use `Money.fromJson()` to recreate `Money` objects from stored JSON.
This is ideal when persisting values in databases or APIs.

```dart
final json = {
  'minorUnits': 1050,
  'decimals': 2,
  'isoCode': 'USD'
};

final amount = Money.fromJson(json);
print(amount); // $10.50
```

---

## 6. Cloning and modifying

Because `Money` is immutable, you can’t modify an existing instance directly.
Instead, use simple arithmetic or the copyWith method.

```dart
final price = Money.fromInt(1000, isoCode: 'USD');
final discounted = price * 0.9; // $9.00

final  highPrecision =  price.copyWith(decimalDigits: 4);
```

---

## Summary

| Method | Description | Example |
|--------|--------------|----------|
| `fromIntWithCurrency()` | From integer minor units with a `Currency` | `Money.fromIntWithCurrency(1050, usd)` |
| `fromInt()` | From integer minor units using ISO code | `Money.fromInt(1050, isoCode: 'USD')` |
| `fromNum()` | From numeric (major units) | `Money.fromNum(10.50, isoCode: 'USD')` |
| `parse()` / `parseWithCurrency()` | From formatted string | `Money.parse(r'$USD10.50')` |
| `fromJson()` | From serialized JSON | `Money.fromJson(json)` |

## Math Operations

Money2 supports precise arithmetic operations on `Money` values, preserving
currency, scale, and rounding rules automatically.

### Supported operators

| Operator | Description                     | Example                     |
|-----------|----------------------------------|------------------------------|
| `+` / `-` | Add or subtract Money values    | `m1 + m2`, `m1 - m2`        |
| `*` / `/` | Multiply or divide by numbers   | `m1 * 1.1`, `m1 / 2`        |
| `~/`      | Integer division (truncating)   | `m1 ~/ 3`                   |
| `%`       | Remainder (modulo)              | `m1 % Money.fromInt(100, m1.currency)` |
| `compareTo` / `<`, `>`, `<=`, `>=` | Comparison operators | `if (m1 > m2) print('More')` |
| `==`      | Value equality (same currency + amount) | `if (m1 == m2)` |

All arithmetic operations preserve the **currency** and **decimalDigits** of
the operands. When combining two `Money` values, they must share the same
currency — otherwise a `MoneyException` is thrown.

### Examples

```dart
final usd = CommonCurrencies().usd;

final price = Money.fromIntWithCurrency(1000, usd); // $10.00
final tax   = price * 0.1;                          // $1.00
final total = price + tax;                          // $11.00
final split = total / 3;                            // $3.67 (rounded)

print(total); // $11.00
print(split); // $3.67

// Comparison
final discount = Money.fromIntWithCurrency(200, usd); // $2.00
if (discount < total) {
  print('Discount is less than total');
}
```

## Parsing & Formatting (Locale-Agnostic Patterns)

Money2 uses simple patterns for parsing and formatting.
Patterns are **locale-agnostic** — they always use `,` for grouping and `.` for decimals.
When formatting, these are replaced by the currency’s actual separators.

**Pattern symbols**

| Symbol | Meaning                        |
|--------|--------------------------------|
| `S`    | Currency symbol                |
| `C`    | ISO code                       |
| `#`    | Digit placeholder              |
| `0`    | Mandatory digit                |
| `.`    | Decimal separator              |
| `,`    | Group separator                |
| `+`    | Always display +/- sign        |
| `-`    | Display - sign if negative     |

```dart
final parsed = usd.parse(r'$10.00');
print(parsed.format('SCCC 0.00')); // $USD 10.00

final parsedEur = eur.parse(r'$10.00');
// The decimal separator is based on the currency, not the pattern.
print(parsedEur.format('SCCC 0.00+')); // €EUR 10,00+
```

---


### Storing Monetary Values

`Money` stores values in **minor units** (like cents) using the `Fixed` type
for deterministic math.

```dart
final cost = Money.fromIntWithCurrency(1000, CommonCurrencies().usd);
print(cost); // $10.00

final taxInclusive = cost * 1.1;
print(taxInclusive); // $11.00

print(taxInclusive.minorUnits); // 1100
```

When storing amounts (e.g., in a database or JSON), store either the `minorUnits`
or use Money2’s built-in JSON serialization.

```dart
final json = amount.toJson();
final amount = Money.fromJson(json);
```

Example JSON output:

```json
{
  "minorUnits": 1100,
  "decimals": 2,
  "isoCode": "USD"
}
```

---



## Design Philosophy

The design choices in Money2 are deliberate and aim for correctness,
predictability, and long-term maintainability.

1. **Fixed decimal, never double** — financial values must be exact.  
   Money2 uses `Fixed` for deterministic scale and rounding.

2. **Immutability by default** — `Money` and `Currency` are value types.  
   All operations return new instances; inputs are never mutated.

3. **Currency-first modeling** — a `Money` always carries its `Currency`,  
   preventing accidental mixing of currencies.

4. **Locale-agnostic patterns** — parsing and formatting use a universal
   pattern syntax (`.` for decimals, `,` for grouping).

5. **Representation vs. presentation** — math uses fixed minor units;
   display is controlled via patterns and separators.

6. **Explicit rounding and scale** — calculations preserve scale and apply
   banker’s rounding (half-even).

7. **Exchange rates are data, not services** — `ExchangePlatform` stores
   rates; fetching and refreshing is your responsibility.

8. **Transparent serialization** — JSON and DB persistence support storing
   either `minorUnits` or formatted strings (prefer integers).

9. **Minimal surprises** — clear, typed exceptions for invalid parses or
   mismatched currencies.

---

## Examples

```dart
import 'money2.dart';
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);

  final costPrice = Money.fromIntWithCurrency(1000, usd);
  expect(costPrice.toString(), equals(r'$10.00'));

  final taxInclusive = costPrice * 1.1;
  expect(taxInclusive.toString(), equals(r'$11.00'));

  expect(taxInclusive.format('SCC #.00'), equals(r'$US 11.00'));

  final parsed = usd.parse(r'$10.00');
  expect(parsed.format('SCCC 0.00'), equals(r'$USD 10.00'));

  final buyPrice = Money.fromNum(10, isoCode: 'AUD');
  expect(buyPrice.toString(), equals(r'$10.00'));

  final sellPrice = Money.fromNum(10.50, isoCode: 'AUD');
  expect(sellPrice.toString(), equals(r'$10.50'));
}
```

---

## Upgrading

### v6
- `scale` renamed to `decimalDigits`
- JSON format for `ExchangeRates` changed.

### v5+
- `invertSeparator` replaced by `groupSeparator` and `decimalSeparator`
- Patterns must always use `,` for grouping and `.` for decimals

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

Currencies are defined in  
`tool/currencies.yaml`

---

## Documentation

- Full docs: https://money2.onepub.dev  
- API reference: https://pub.dev/documentation/money2/latest/