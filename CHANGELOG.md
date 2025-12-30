# 6.1.0
- There is a merge (of most) of #97 submitted by @fabiocarneiro - thanks to fabio for his excellent work.
- Robust Decimal/Group Separator Heuristic: A new heuristic dynamically detects decimalSeparator and groupSeparator by analyzing the input string's structure (presence and position of . and ,).   This allows Money.parse to correctly interpret formats like 1,246.98 (treating . as decimal) even for EUR, which defaults to ,.
- The heuristic is only applied if both separators are present in the input to prevent input such as 9,00 being mis-interpreted as 900 rather than 9.
- Accurate Major/Minor Unit Extraction: The ValueQueue._takeDigits method was refined to strictly differentiate between digits, group separators, and the detected decimal separator. This ensures major units stop precisely at the decimal point.
- Correct Truncation/Scaling Flow: PatternDecoder now extracts the full precision of minor units from the input string. The Fixed amount is then constructed with this full parsed precision. The final truncation or scaling to currency.decimalDigits (as per the "excess digits will be ignored" rule) is handled correctly by Fixed.copyWith during the Money object creation.
- Precise Negative Number Handling: The calculation of the final value now combines the absolute major and minor units first, and then applies the negative sign (if isNegative is true) to this combined absolute value, preventing off-by-one errors for negative inputs.
- Improved _isDigit: The _isDigit method was corrected to strictly identify only 0-9 characters as digits, preventing separators from being misinterpreted as numerical values.

# 6.0.9
- added onepubl logo.

# 6.0.8
- updated link to common currencies so it works from pub.dev

# 6.0.7
- updated the readme with more detail and improved the pubspec description.
- We now generate an md file with the full list of currency codes and their settings. 
- Fixed a spelling mistake in the currencies.yaml file.

# 6.0.6
- now allows a -ve sign before the currency symbol. Fixed a bug in the pattern which included = rather than -.

# 6.0.5
- reverted to character 1.4.0 to support flutter_test.

# 6.0.4
- removed the dependency on strings package by copying a the two functions we used into money2.

# 6.0.3
- Fixeds #96. Change the generator so if the symbol contains a $ we prefix the string with 'r'.
- spelling.

# 6.0.2-beta.2
- Fixes issue with trailing Currency isoCodes throwing a range exception as reported in #95.

# 6.0.2-beta.1
- BREAKING: Fixes #95. This problem was a regression caused as part of the 6.x release.
  The issue was that group separators after the first (right most) group where
  being treated incorrectly.  
  We now treat #,### == ###,###
  and ##,### == ##,###

We also fixed a long standing issue with common currences.
All CommonCurrencies has been defined without group separators. 
This has now been changed so that all common currencies are
defined with the appropriate group separators.

This means that the pattern for USD (and most other currencies) changes 
from S0.00 to S#,##0.00.
All common currencies are now defined with group separators as appropriate
for that currency.

The implication is that formatting with the old behavour would give $9000 whilst
the new behavour would give $9,000.
If you want to mimic the old behaviour you can simply set the pattern to the original 'S0.00'.

We have also changed how we are maintaing common currencies. 
We are are now generating common currencies from a yaml file.
To regenerate common currences run:
dart tool/generate_common_currencies.dart


# 6.0.1
- Added method isNonZero as a convenience.

# 6.0.0
 - Breaking All occurances of the Precentage named arg 'scale' have been changed to decimalDigits.
 - change all occurance of scale to decimalDigits. Upgraded to Fixed 6.0
 
# 6.0.0-beta.4
- Breaking: Money operator * now returns the same decimalDigits as the original
   Money instance. Previously we use the Currencies decimal Digits.
- upgraded to fixed 5.3.4
- Fixed broken examples in the readme and the main doco site.
- Fixed a bug in operator * which truncated the scale of doubles. We now default to 16 digits. 
- Added a new method multiplyByNum to allow the user to expliclity control the scale.
- created tests for all examples.
- Added missing hkd from list of common currencies. Thanks to @hwh97 for raising the issue.

# 6.0.0-beta.3
BREAKING: change fromCode and toCode to fromIsoCode and toIsoCode in the ExchangeRate.fromMinorUnits and ExchangeRate.fromNum methods to bring it in line with other methods.
Change how ExchangeRates are stored to json to bring it in line with how we store money as json.

```dart 
/// old format
 Map<String, dynamic> toJson() => {
        'integerPart': 0,
        'decimalPart': 68
        'decimals': 2,
        'fromIsoCode': 'AUD'
        'toIsoCode': 'USD'
        'toDecimalDigits': 3,
      };

/// new format
        'minorUnits': '75312',
        'decimals': 5,
        'fromIsoCode': 'AUD',
        'toIsoCode': 'USD',
        'toDecimals': 3,
```
Note that 'minorUnits' is a string to avoid overflow issues when javascript parses the json and the integer is larger than a javascript num.

# 6.0.0-beta.2
 BREAKING: the 'precision' argument to Currencies.copyWith has been renamed from
 precision to decimalDigits
 
# 6.0.0-beta.1
- Add: support for large numbers. Thanks to @nesquikm's significant contribution we now
support numbers upto 100 digits (in both the integer and decimal components) and the library probably works for larger numbers as well - we use BigInt under the hood which is only limited by memory.

- New formatting engine. We have done a complete rewrite of the engine that formats money amounts which has alowed us to fix a number of 
  long time outstanding issue. In particular we now support the india clustering of thousands '##,###.##' and in general the engine should prove to be much more flexible.
- Add: we now support the '+' character in a pattern. When present we will either print '+' or '-' based on the sign of the number.
    This compares with the '-' pattern which will print a '-' (if the amount is -ve) but never a '+' character.
- Breaking: a pattern for the integer component like '0#' is now illegal and will throw. If used the '0' character can only come after any '#' character e.g. '#0' is allowed.
- Breaking: a pattern for the decimal component like 'xxxx.#0' is now illegal and will throw. If used the '0' character must come before any '#' character e.g. 'xxx.0#' is allowed.
- Breaking: change the json format as the current format was likely to break any javascript code that tried to parse it when it contained a large number.
  Given the breaking change we also took the opportunity to improve the format. We now have 'minorUnits', 'decimals' and 'isoCode' as the three fields.

  For example to store the value USD $10.25
  
  The old format contained four fields:
```dart
        'integerPart': 10
        'decimalPart': 25
        'decimals': 2
        'isoCode': 'USD"
```

The new format only has 3 fields and the minor units are a string to avoid javascript consumers throwing on big values:
```dart
     final expectedJson = <String, dynamic>{
    'minorUnits': '1025',
    'decimals': 2,
    'isoCode': 'USD',
    };
```
- Additional IllegalPatternException are now thrown when formatting a number if the pattern is invalid.

# 5.4.6
- modified Percentage.tryParse to return null if the amount can't be parsed. Previoulsy we returned zero which isn't in keeping with the expected signature a tryParse method.

# 5.4.5
- changed percentage.copyWith so it returns a Percentage not a Fixed.

# 5.4.4
- Fixed a bug in the multipledByPercent, it was failing to divide by 100 after we changed the way percentages are represented.

# 5.4.3
- added additional tests.
- fixed arg names to divide methods.
- added methods
  multipliedByPercentage
  percentageOf

- added helper class Percentage.
as a whole number rather than a decimal e.g. 10% is stored as 10 not 0.1


# 5.4.0
- added json serialisation to Money, Currency and ExchangeRate
 A big thanks to https://github.com/marcelomendoncasoares for this
 excellent contribution.

# 5.3.0
- Merge pull request #88 from bryanoltman/bo/fix-typo
- fix typo in README.md
- upgraded to decmial 3.x

# 5.2.1
- added copyWith ctor for money.

# 5.2.0
- added a test to check for inequality when the 'other' type is not a money now that we accept an Object? for other.
- Merge pull request #86 from karelklic/operator==  which now takes an Object? for other so that we work with
the likes of the freezed package.


# 5.1.0
- Added additional conversion operations. Upgraded to Fixed 5.0.
- released 5.0.1

# 5.0.0
The driver for this release and the breaking changes comes from:
https://github.com/onepub-dev/money.dart/issues/79

The aim is to allow users to fully customise the group and decimal separators.
We have also renamed 'scale' to 'decimalDigits' as this term is likely to be
more familiar to users.

## breaking changes
- The 'invertSeparator' argument to the Currency class has been broken out 
into two separate arguments 'groupSeparator' and 'decimalSeparator'. 
If you are using 'invertSeparator: true' then you need to replace this with
```dart
  groupSeparator: '.',
  decimalSeparator: ',',
```
- patterns used for parsing and formatting must always use ',' for group separators
and '.' for decimal separators regardless of what has been used for the
groupSeparator and decimalSeparator.
This allows a single pattern to be used across currencies rather than having
to create a unique pattern for each currency when looking to use custom formats.

This means that if you have been using 'invertSeparator: true' then you will 
need to modifiy any custom patterns from '#.###,##' to '#,###.##'.
Note the change in the separators!


- For methods that take a 'code' it has been renamed 'isoCode' to make the
correct use of the code more apparent.

- renamed PatterDecoder.isCode to isIsoCode
- renamed CurrencyCode to CurrencyIsoCode
- renamed all occurances of 'scale' to 'decimalDigits' as many people
  are not familiar with the concept of scale.
- changed toScale on ExchangeRate members to be 'toDecimalDigits'.

## non-breaking changes
- Fixed doco for Currencies class as it is a singleton and it's needs methods need to be called  via Currencies()...

## Full set of currency codes
Thanks to the work of [fueripe-desu](https://github.com/fueripe-desu) we now have a full set of currency codes
and associated formatting built into common-currencies.
An heroic piece of work - so much thanks to fueripe-desu from myself and the wider Dart
community.


# 5.0.0-alpha.2
- updated the list of supported platforms.

# 5.0.0-alpha.1
The driver for this release and the breaking changes comes from:
https://github.com/onepub-dev/money.dart/issues/79

The aim is to allow users to fully customise the group and decimal separators.
We have also renamed 'scale' to 'decimalDigits' as this term is likely to be
more familiar to users.

## breaking changes
- The 'invertSeparator' argument to the Currency class has been broken out 
into two separate arguments 'groupSeparator' and 'decimalSeparator'. 
If you are using 'invertSeparator: true' then you need to replace this with
```dart
  groupSeparator: '.',
  decimalSeparator: ',',
```
- patterns used for parsing and formatting must always use ',' for group separators
and '.' for decimal separators regardless of what has been used for the
groupSeparator and decimalSeparator.
This allows a single pattern to be used across currencies rather than having
to create a unique pattern for each currency when looking to use custom formats.

This means that if you have been using 'invertSeparator: true' then you will 
need to modifiy any custom patterns from '#.###,##' to '#,###.##'.
Note the change in the separators!


- For methods that take a 'code' it has been renamed 'isoCode' to make the
correct use of the code more apparent.

- renamed PatterDecoder.isCode to isIsoCode
- renamed CurrencyCode to CurrencyIsoCode
- renamed all occurances of 'scale' to 'decimalDigits' as many people
  are not familiar with the concept of scale.
- changed toScale on ExchangeRate members to be 'toDecimalDigits'.

## non-breaking changes
- Fixed doco for Currencies class as it is a singleton and it's needs methods need to be called  via Currencies()...

# 4.1.0
- upgraded to intl 0.19

# 4.0.0
- updated min sdk to 3.x
- updated to fixed 4.x
- test: add test for trailing symbol pattern

# 3.4.1
- fix(pattern_encoder): handle trailing decimal when pattern has trailing symbol
- Added scale unit tests provided by @nesquikm

# 3.4.0
- upgraded to: fixed 2.4.0, intl 0.18, meta 1.9.0

# 3.3.0
- Upgraded to fixed 2.3.0 and Decimal 2.3.0 to fixed a compilation problem caused by a breaking change in decimal. upgraded to lint_hard. Increased the minimum sdk to 2.14 as reflect decimals minimum sdk.

# 3.2.0
- updated to the latest version of decimal, fixed and meta.
- BREAKING: The exchange rate formatter was incorrectly displaying the rate as a currency when its just a scalar value. The currency symbol prefix has now been removed. The exchange rate format was also performing rounding  when the scale was larger than the no. of decimals the format included. This was not the intended behaviour. It now truncates the no. of decimals to reflect the format pattern. If you want rounding then you should scale the no. before formatting it.

# 3.1.4
- Fixed: #69 - tryParse throws when Money empty - thanks to LewisHolliday
- add failing tryParse tests
- add tests for parse with invalid input
- Money.parse now correctly throws MoneyParseException when an invalid amount is passed.

# 3.1.3
- exported money_data.dart in the barrel file.
- corrected spelling for  Money.fromBigIntWitCurrency and ExchangeRate.fromFixedWitCurrency
- updated links from noojee.dev to onepub.dev

# 3.1.2
Corrected the home page link

# 3.1.0
- Merge pull request #59 from niklasbartsch/Upraded-to-the-latest-version-of-fixed
- Fixes: error when using Money2 in a Flutter Web environment due to the reduced size of an int (53bits vs 64 bits).

# 3.0.0-beta2
- added notes on v2-v3 conversion.
- Changed ExchangePlatform to work with ExchangeRate changes.
- Added ctors to ExchangeRate for the supported data types. 
- Added a method to apply an inverse rate.  Added the from Currency so it could be used in the ExchangePlatform and is fully self desribing.
- Fixed the # char for decimal patterns as it was acting like the 0 char.
- Made the Code and Symbol patterns optional.
- renamed Money.from to Money.fromNum. 
- Added Money.fromIntWithCurrency. 
- Added Money.fromDecimal 
- Added operators for Money and Fixed operations.
- Change all exceptions to be derived from a common MoneyException.
- Updated bitcoins pattern to make it consistent with other currencies.
- Added the exchange_platform to the set of exported classes.
- Added decimalPart to moneyData. 
- Added sign to Money.

# 2.3.0
- In response to issue #53 we have modified how excess minorUnits (decimals) are parsed.  Even if the parse pattern doesn't contain decimal places we will still parse decimal places in the Monetary Value. This ensures that we always retain the original parsed values precisions. However the api is currently quiet on how precision is treated when parsing decimals. We have now documented the api to state that we will parse upto the Currencies defined precisions.
- - This means:
   if you pass a monetary value with decimal digits in excess of the Currencies precision they will be ignored.
   If you pass a monetary value with decimal digits in excess of the passed pattern then they will be parsed upto the precision of the Currency.
- Fixed a bug where parsing a no. of the form '.99' (i.e. no leading major digit) would thrown an exception.

# 2.2.2
- Fix overflow issue when using high precision currencies - thanks to Bob Jackman for the contribution.


# 3.0.0-beta.6
- Added additional tests for INR.
- INR had invertseparator as true which isn't correct for INR. The pattern was also wrong.

# 3.0.0-beta.5
Change the common currency format for the inr currencies as it was inconsistent with all other default formats.
This also sides steps bug #50.

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
