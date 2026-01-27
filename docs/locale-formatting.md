# Locale-Aware Formatting for money2

## Overview
Money2 currently treats formatting patterns as part of `Currency`, but locale-specific formatting is a locale concern. The goal is to introduce locale-aware formatting while preserving the existing value-object model and keeping currency data in money2.

## Motivation
- Formatting should adapt to user locale (e.g., separators and symbol placement) rather than be fixed per currency.
- Heuristic parsing has diminishing returns and is inherently fragile.
- Maintaining a full set of locales gives is greater control providing
we can identify a reliable parsable source of locales.
- Locale formatting data should be sourced from CLDR/ICU (via `intl` or other
locale-capable libraries) rather than maintained in money2.

## Goals
- Locale-aware formatting by default, with explicit locale overrides.
- Preserve `Money` and `Currency` as value objects, with formatting resolved externally.
- Provide a detailed migration guide where we break the api.
- provide a definitive source of currencies/locales that we pull from 
authoritive source where available and create ourselves when necessary.
- define the location of the -ve symbol.
- Source locale-specific formatting and symbols from CLDR/ICU.
- the intl package should only be a dev dependency


## Non-goals
- money2 will not become a general localization library.
- backwards compatibility is a nice to have but not if it compromises
the new API.

## Proposed API Changes (Draft)

### 1) New Locale-Aware Formatter Abstraction
Introduce a formatter interface to decouple formatting engine from core types.

```dart
abstract class MoneyFormatter {
  String format(Money money, {Locale? locale});
  Money parse(String input, Currency currency, {Locale? locale});
}
```

### 2) Global Config for Locale and Formatter
Provide a configurable entry point.

```dart
class MoneyConfig {
  static Locale? defaultLocale;
  static MoneyFormatter formatter = IntlMoneyFormatter(); // optional package
  static void acknowledgeLocaleMigration();
}
```

### 3) Money.format() Signature
Allow locale to be specified explicitly.

```dart
String format({Locale? locale, String? pattern});
```

Notes:
- If `locale` is supplied, use locale-aware formatting even when `pattern` is not.
- If `pattern` is supplied, it should still work for backward compatibility.

### 4) Currency Formatting Data
- Keep currency metadata (ISO, symbol, decimal digits) in money2.
- Deprecate using `Currency.pattern`, `groupSeparator`, `decimalSeparator` as the primary formatting source (keep for legacy compatibility).

### 5) Split Formatting from Currency
We will move formatting concerns out of `Currency` and into a dedicated locale model. Locale data will include separators, symbol/code placement, and sign placement rules. Currency remains ISO metadata (code, symbol, decimals, name, unit). Locale selection is user/caller-driven.

Locale responsibilities:
- group separator (thousands)
- decimal separator
- currency symbol/code placement (prefix/suffix) and spacing
- sign placement (+/‑) for positive/negative values
- digit grouping pattern (e.g. `#,##0` vs `##,##0`)
- optional rounding/display rules for minor units (e.g. always show 2 vs trim trailing zeros)

Currency responsibilities:
- ISO code (e.g. USD)
- default symbol (e.g. $)
- decimal digits (minor units)
- name/unit metadata

## Locale Model (Draft)

```dart
class MoneyLocale {
  final String localeTag; // e.g. en-US
  final String groupSeparator; // e.g. ','
  final String decimalSeparator; // e.g. '.'
  final String groupingPattern; // e.g. '#,##0' or '##,##0'

  // Symbol/code placement
  final CurrencyPlacement currencyPlacement; // prefix/suffix
  final bool spaceBetween; // true => "1 234,56 €"
  final CurrencyDisplay currencyDisplay; // symbol/code/name

  // Sign placement rules
  final SignPlacement negativeSign; // leading/trailing/parentheses
  final SignPlacement positiveSign; // leading/trailing/omit

  // Digit display rules
  final bool trimTrailingZeros; // e.g. 1.20 -> 1.2
  final int? minFractionDigits; // optional override
  final int? maxFractionDigits; // optional override

  const MoneyLocale({
    required this.localeTag,
    required this.groupSeparator,
    required this.decimalSeparator,
    required this.groupingPattern,
    required this.currencyPlacement,
    required this.spaceBetween,
    required this.currencyDisplay,
    required this.negativeSign,
    required this.positiveSign,
    required this.trimTrailingZeros,
    this.minFractionDigits,
    this.maxFractionDigits,
  });
}

enum CurrencyPlacement { prefix, suffix }
enum CurrencyDisplay { symbol, code, name }
enum SignPlacement { leading, trailing, parentheses, omit }
```

## Locale YAML Format (Draft)

```yaml
# tool/locales.yaml
- locale: "en-US"
  groupSeparator: ","
  decimalSeparator: "."
  groupingPattern: "#,##0"
  currencyPlacement: "prefix"
  spaceBetween: false
  currencyDisplay: "symbol"
  negativeSign: "leading"
  positiveSign: "omit"
  trimTrailingZeros: false
  minFractionDigits: 2
  maxFractionDigits: 2

- locale: "de-DE"
  groupSeparator: "."
  decimalSeparator: ","
  groupingPattern: "#,##0"
  currencyPlacement: "suffix"
  spaceBetween: true
  currencyDisplay: "symbol"
  negativeSign: "leading"
  positiveSign: "omit"
  trimTrailingZeros: false
  minFractionDigits: 2
  maxFractionDigits: 2

- locale: "en-IN"
  groupSeparator: ","
  decimalSeparator: "."
  groupingPattern: "##,##0"
  currencyPlacement: "prefix"
  spaceBetween: false
  currencyDisplay: "symbol"
  negativeSign: "leading"
  positiveSign: "omit"
  trimTrailingZeros: false
  minFractionDigits: 2
  maxFractionDigits: 2
```

## CLDR as Source of Truth (Generated Dart)
We will use CLDR directly as the authoritative source for locale formatting data. We will not ship locale YAML in the package; instead, we will generate Dart classes for locales (and any related currency formatting metadata) at build-time from CLDR.

Rationale:
- Avoid a runtime dependency on `intl`.
- Ensure consistent, deterministic locale formatting across platforms.
- Keep money2’s formatting data in strongly-typed Dart code, generated from CLDR.

Implications:
- Add a build-time generator that pulls CLDR data and emits locale classes.
- Locale selection uses generated `MoneyLocale` definitions (no external YAML at runtime).

## Migration Strategy
- Add a one-time warning at initialization or on first formatting call to indicate locale-first behavior is coming.
- Provide `MoneyConfig.acknowledgeLocaleMigration()` to silence warnings.
- Phase rollout:
  - Phase 1: locale support is opt-in and coexists with currency patterns.
  - Phase 2: locale support becomes default; currency patterns become fallback.
  - Phase 3: legacy formatting flagged as deprecated with explicit opt-in.

## Fallback Behavior
If locale cannot be resolved:
- Option A: throw (strict mode).
- Option B: neutral formatting fallback (e.g., `USD 1,234.56`).
- Option C: require `MoneyConfig.defaultLocale` or use system default if available.

## Parsing
- Parsing should also be locale-aware to avoid ambiguous separators (e.g., `1,234` vs `1.234`).
- Provide a parse API with locale hint: `Money.parse(value, currency: usd, locale: Locale('de'))`.

## Compatibility Risks
- Existing applications expect currency-level separators and patterns.
- Some apps depend on custom patterns (e.g., crypto or no-symbol formats).
- Need opt-out or explicit pattern override.

## Testing Strategy
- Golden tests for locale formatting across common locales (en_US, de_DE, fr_FR).
- Legacy tests for existing currency-based formatting to ensure compatibility.
- Parse/format round-trip tests per locale.

## Worked Examples (Now vs After)

### Money.format
Now
```dart
final usd = Currency.create('USD', 2);
final price = Money.fromIntWithCurrency(123456, usd);
print(price.format('S#,##0.00')); // $1,234.56
```

After
```dart
MoneyConfig.defaultLocale = const Locale('en', 'US');
print(price.format(locale: const Locale('en', 'US'))); // $1,234.56
print(price.format(locale: const Locale('de', 'DE'))); // 1.234,56 $
// Legacy pattern still works:
print(price.format(pattern: 'S#,##0.00')); // $1,234.56
// Patterns can include separate positive/negative sections:
print(price.format(pattern: 'S#,##0.00;S-#,##0.00')); // $1,234.56
```

### Money.toString
Now
```dart
final usd = Currency.create('USD', 2);
final price = Money.fromIntWithCurrency(123456, usd);
print(price.toString()); // uses currency.pattern, e.g. $1,234.56
```

After
```dart
MoneyConfig.defaultLocale = const Locale('fr', 'FR');
print(price.toString()); // 1 234,56 $
```

### Money.parse
Now
```dart
final money = Money.parse(r'$10.50', isoCode: 'USD');
```

After
```dart
final money = Money.parse('10,50 €',
    isoCode: 'EUR',
    locale: const Locale('de', 'DE'));
```

### Money.parseWithCurrency
Now
```dart
final eur = Currency.create('EUR', 2);
final money = Money.parseWithCurrency('€10.50', eur, pattern: 'S#,##0.00');
```

After
```dart
final eur = Currency.create('EUR', 2);
final money = Money.parseWithCurrency('10,50 €',
    eur,
    locale: const Locale('de', 'DE'));
```

### Money.tryParse
Now
```dart
final money = Money.tryParse(r'$11.50', isoCode: 'USD');
```

After
```dart
final money = Money.tryParse('11,50 €',
    isoCode: 'EUR',
    locale: const Locale('de', 'DE'));
```

### Currencies.parse
Now
```dart
Currencies().register(Currency.create('USD', 2));
final money = Currencies().parse(r'$USD1500.0');
```

After
```dart
Currencies().register(Currency.create('USD', 2));
final money = Currencies().parse('USD 1 500,0',
    locale: const Locale('fr', 'FR'));
```

### Currency.create
Now
```dart
final eur = Currency.create('EUR', 2,
    symbol: '€',
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',');
```

After
```dart
// Still supported but treated as legacy defaults
final eur = Currency.create('EUR', 2, symbol: '€');
// Locale-aware formatting handled by MoneyConfig/formatter.
```

### New APIs
```dart
MoneyConfig.defaultLocale = const Locale('en', 'US');
MoneyConfig.formatter = IntlMoneyFormatter();
MoneyConfig.acknowledgeLocaleMigration();
```

## Comparison: money2 vs Java Money (JSR 354) Locale API

### High-level approach
- money2 (today): currency-driven formatting using `Currency.pattern`, `groupSeparator`, and `decimalSeparator`; locale is not part of the API surface.
- Java Money (JSR 354): locale-driven formatting via `MonetaryFormats.getAmountFormat(Locale, ...)` returning a `MonetaryAmountFormat`, with provider-based extensibility.

### Core formatting entry points
money2 (today)
```dart
final usd = Currency.create('USD', 2, pattern: r'$0.00');
final price = Money.fromIntWithCurrency(123456, usd);
print(price.format('S#,##0.00')); // $1,234.56
```

Java Money (JSR 354)
```java
MonetaryAmount amount = Monetary.getDefaultAmountFactory()
    .setCurrency("USD").setNumber(1234.56).create();
MonetaryAmountFormat format = MonetaryFormats.getAmountFormat(Locale.US);
String out = format.format(amount); // locale-driven
```

### Parsing
- money2 (today): `Money.parse(...)` and `Money.parseWithCurrency(...)` use pattern + currency separators.
- Java Money: `MonetaryAmountFormat.parse(...)` parses using a locale-specific format instance.

### Locale coverage and discovery
- money2 (today): no locale discovery API; locales would be external.
- Java Money: `MonetaryFormats.getAvailableLocales(...)` returns available locales and `getFormatProviderNames()` lists registered providers.

### Extensibility
- money2 (today): patterns are part of `Currency` instances and generated lists.
- Java Money: formatting is provider-based via `MonetaryAmountFormatProviderSpi` and query-driven formats.

### Thread-safety considerations
- money2 (today): formatting is pure and stateless.
- Java Money: `MonetaryAmountFormat` instances are not required to be thread-safe; consumers should not share instances across threads without synchronization.

### Implications for money2 locale support
- Align with Java Money’s model: a locale-first formatter service (`MoneyFormatter`) with a global provider (`MoneyConfig`) is closest to JSR 354’s `MonetaryFormats` factory + provider SPI.

## Open Questions
- Should `intl` be required or optional via an adapter package?
- How should we define precedence when both `pattern` and `locale` are supplied?
- Do we need to add locale-specific symbol placement customization for edge cases?
