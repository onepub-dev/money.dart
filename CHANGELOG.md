# 3.0.0-beta.4
- reverted meta to 1.3 as flutter_test isn't compatible with meta 1.7 Fixes: #47

# 3.0.0-beta.3
- upgraded to latest meta.
- moved to lints package.
- added [] and []= operators to access Currencies.
- cleaned up package imports.

# 3.0.0-beta.2
Revised the Money constructors to take a currency 'code' rather than a currency.

```
Money.from(100, CommonCurrency.usd);

becomes

Money.from(100, 'USD');

Old methods are still available as:

Money.fromWithCurrency(100, CommonCurrency.usd);

```

To support this CommonCurrencies are now automatically registered.

# 3.0.0-beta.1
Breaking changes
- re-implemented each of the == operator to use 'covariant' rather than taking a dynamic as this moves the type check to a compile time error rather than a runtime error. You can nolonger pass a dynamic to the == operator.
- Changed the Currencies class to a singleton as per #38. You will need to change calls such as:
```
Currencies.register() -> Currences().register();
Currencies.registerAll() -> Currences().registerAll();
Currencies.parse() -> Currences().parse();
```
- restructured the unit test directory so it confirms to the recommended structure.


# 2.2.1
Improved documentation around the Currencies class.

# 2.2.0
- Add API to access currently registered currencies 
```dart
Iterator<Currency> Currencies.getRegistered()
```


# 2.1.4
replaced @deprecated with @Deprecated.

# 2.1.3
Updated links in readme.

# 2.1.2
Corrected the documentation link.

# 2.1.1
Updated homepage.


# 2.1.0
Added zloty and Czech koruna
Default Euro pattern fixed - the symbol is now at the end of the value
removed support for the beta of 2.12.

# 2.0.3
un deprecated Money.fromBigInt as it is more memory efficient that Money.from

# 2.0.2
Rreleased null safety preview. fixes: #15 fixes: #29 - lost digits  using exchangeTo fixes: #28 - support more precision for exchange rates fixes #24 - support mutli-character symbols. fixes #22 - document inversion of , and . in format.
Rounding was wrong for -ve no. Changed to rounding based on sign.
moved doco to gitbooks.
Corrected the BRL pattern.
Corrected the decimal separator for brl.
Added tests for rounding.
Added tests for exchange rate precision.
Added bitcoin, sorted entries.
Fixed #26 rounding issue - Money.from rounds incorrectly. Fixed a bug in exchangeTo that had hard coded the number of decimal places.

# 2.0.1-nullsafety.6
Added Money.dividedBy with a double as the result.


# 2.0.1
released 2.0.1-nullsafety.5 to fix the description formatting.

# 2.0.1-nullsafety.5
Fixed the incorrect example output to be correct.

# 2.0.1-nullsafety.4
3rd attemp to fix formatting.

# 2.0.1-nullsafety.3
2nd attempt to fix the description formatting ;<

# 2.0.1-nullsafety.2
attempt to fix the escaping of the description.

# 2.0.1-nullsafety.1
Bug fixes for currences by with high precision and parsing amounts with less than the expected decimal places.
Merge pull request #21 from comigor/precision-0
Merge pull request #19 from comigor/master
moved to lint.
Exposed the encoders as part of the public api.
Correctly parse currencies with 0 minor digits
Fix a formatting issue where only currencies with precision=2 were being considered

# 2.0.0-nonnullable.1
Migrated the library to use the dart non-nulllable options.

# 1.4.3
add support for parsing negative money values

# 1.4.2
Merge pull request #9 from ibobo/master
replaced " with ' quotes.
removed all \$ replaced with r'$
Fix formatting of negative numbers below minorDigitsFactor

# 1.4.1
fixed lints to make pub.dev happy.
ignored settings.json.
When formatting patterns now support spaces between code/symbol and the digits.
Added support for a built in list of common currencies.
Added support for whitespace between pattern characters when parsing. We do this by removing any whitespace in the pattern or the value.
Allow space on minorPattern
Add test cases with spaces after digits



## version: 1.4.0
relase of beta features.

## version: 1.4.0-beta-3
Merged in PR #7

When formatting patterns now support spaces between code/symbol and the digits.

Thanks to @comigor for the patch.

## version: 1.4.0-beta-2
Forgot to export the new CommonCurrencies class.

## version: 1.4.0-beta-1
Added support for whitespace around the symbol and the currency code.
Added support for a builtin list of common currency codes as requested in #8

## version: 1.3.0
Fixes from oysterpack dealing with:
https://github.com/noojee/money.dart/issues/4
money values with single digit cents do not format correctly

and

https://github.com/noojee/money.dart/issues/2

Currently minor units and currency are used to construct Money, but they are not exposed as properties.



## version: 1.2.3
Updated code style to meet latest requirements of dartanalyzer.

## version: 1.2.2
Documented creation of top 20 currencies.

## version: 1.2.1
Corrections and improvements to the documentation.

## version: 1.2.0
Deprecated 'fromString' methods in favour of 'parse' method name. This was done to bring the library 
in line with the likes of BigInt.parse.

### Added
New 'Money.from(num)' method to support creating money from int's and doubles.
New Unit tests for Money.from and the new parse methods.

### Deprecated
Money.fromString - use Money.parse
Currency.fromString - use Currency.parse
Currencies.fromString - use Currencies.parse

## version: 1.1.1
Minor documenation cleanups.

## version: 1.1.0
Change the API of Currencies. Its now a singleton so usage changes from:
Currencies().register() to Currencies.register().

### Added
New methods to parse a monetary value from a String including:
Money.frommString
Currency.fromString
Currencies.fromString

New method to convert a [Money] of one currency to another currency
via the [Money.exchangeTo] method.

New examples and unit tests for the above methods.


## version: 1.0.7
2nd Attempt to improve the description displayed on pub.dev.

## version: 1.0.6
Attempt to improve the description displayed on pub.dev.

## version: 1.0.5
Formatting of examples as the pub.dev site clips wide lines.

## version: 1.0.4
Improved the examples.

## version: 1.0.3
Changed readme sample to the more familar usd. 

### Added
Examples of registry usage.  
Additional unit tests.

## version: 1.0.2
tweaks to the doco, some additional unit tests. Improved the trailing zero logic.

## version: 1.0.1
Improvemenst to the dartdoc.

## version: 1.0.0
First release version

### Updated
Readme to document invertedSeparators and general improvments corrections.

### Added
Added a couple additional examples.
InvertedSeparator argument to Currency.create
Additional unit test for the InvertedSeparator option.

## version: 1.0.0-beta.6
Minor cleanups of the readme.md

## version: 1.0.0-beta.5
Updated the name of example.dart to please google package gods.

## version: 1.0.0-beta.4
Update to please the google package gods.

### Added
- longer description
- fixed to broken annotations.

## version: 1.0.0-beta.3
Updated the description.

### Removed
- Dependency on `meta ^1.1.7`.
### Updated
- Dependancy on `intl: ^0.16.0`.

## 1.0.0-beta.1 - 2019-9-26
### Added
- Dependency on `meta ^1.1.7`.
- Dependancy on `intl: ^0.15.8`.
- Annotations `@immutable` and `@sealed` to `Money`, `Currency`, `MoneyData`.
- Added new format method on Money class to allow simply formating of amounts.
- Modified the API to make it easier to follow.
- Change the Currencies class to a factory and renamed methods to 'register' and 'registerList'.
- Chaneged ctor for Money from withBigInt to fromBigInt
- Added ctor for Money 'fromInt'
- Added strong mode to the analyzer.
- Renamed a number of classes for clarity.
- Added unit tests for the new formatter.
- Updated the readme.md for clarity and the details on the new formatter.
- Removed the aggregated currency interface as couldn't see that it added significant value.

## 1.0.0-alpha.1 - 2019-04-09
> **This release was made from scratch and provides API incompatible with `0.2.1`.**

### Added
- `Currency` value-type.
- The interface `Currencies` for representation of currency directories.
- Implementation of currencies which can be initialized by any `Iterable<Currency>`
(see the factory `Currencies.from(Iterable<Currency>)`).
- Aggregating `Currencies` implementation (see the factory
`Currencies.aggregating(Iterable<Currencies>)`).
- Adds `Money` value-type:
    - amount predicates: `.isZero`, `.isPositive`, `.isNegative`;
    - currency predicates `.isInCurrency(Currency)`, `.isInSameCurrencyAs(Money)`;
    - comparison operators: `==`, `<`, `<=`, `>`, `>=`;
    - conformance to `Comparable<Money>`;
    - arithmetic operators (`+(Money)`, `-(Money)`, `*(num)`, `/(num)`);
    - allocation according to ratios with `.allocationAccordingTo(List<int>)`;
    - allocation to _N_ targets with `.allocationTo(int)`;
    - `.encodedBy(MoneyDecoder)`;
    - `Money.decoding(MoneyEncoder)`.
- Interface `MoneyEncoder`.
- Interface `MoneyDecoder`.
- `MoneyData` — DTO for encoding/decoding.

## 0.2.1 - 2018-08-21
### Fixed
- Fixes comparison of `0` and `-0` amount in a browser.

## 0.2.0 - 2018-08-17
### Changed
- Code was migrated to Dart 2.0. No API changes.

## 0.1.6 - 2017-02-24
### Fixed
- Fixed wrong parsing from string when integer part of amount is `0`.

## 0.1.5 - 2016-07-06
### Changed
- Class `Currency` is not abstract from now on.

### Fixed
- `Money.hashCode` now relates on `amount` and `currency` (Issue #1).


## 0.1.4 - 2016-06-03
### Changed
- [BC] `Money.==()` now receives `Object` instead of `Money` and checks runtime
  type of the argument, closes [#4](https://github.com/LitGroup/money.dart/issues/4).


## 0.1.3+2 - 2016-05-10
### Fixed
- Fixed invalid rounding of amount in `Money.toString()`, closes
  [#3](https://github.com/LitGroup/money.dart/issues/3).


## 0.1.3 - 2015-05-05
### Added
- Added `Money.fromDouble()` constructor.


## 0.1.2 - 2015-05-05
### Added
- Added getter `Money.amountAsString`.


## 0.1.1 - 2015-05-04
### Added
- Added `Money.fromString()` constructor.
- Added relational operators (`<`, `<=`, `>`, `>=`).


## 0.1.0+1 - 2015-05-01
### Fixed
- Fixes `README.md`.


## [0.1.0] - 2015-05-01
Initial version.
