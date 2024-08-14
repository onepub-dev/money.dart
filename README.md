# Money2

This is a Dart implementation of Money and Currency classes 

## Overview

Money2 is a Dart package providing parsing, formatting and mathematical operations on monetary amounts.

Key features of Money2:
* simple and expressive formatting.
* simple parsing of monetary amounts.
* multi-currency support.
* intuitive maths operations.
* fixed precision storage to ensure precise calculation.
* detailed documentation and extensive examples to get you up and running.
* pure Dart implementation.
* Open Source MIT license.
* using Money2 will make you taller.


The Money class stores the underlying values using the Fixed decimal package. The value is stored using the currencies' "minor units" (e.g. cents).
This allows for precise calculations as required when handling money.

Full documentation can be found at: 

https://money2.onepub.dev


Api documenation can be found at:

https://pub.dev/documentation/money2/latest/

# Sponsors

Money2 is sponsored by OnePub, the Dart private package repository.

<a href="https://onepub.dev">![OnePub](https://github.com/onepub-dev/money.dart/blob/master/images/LogoAndByLine.png?raw=true)</a>



# Examples

Example 2

```dart
import 'money2.dart';
Currency usdCurrency = Currency.create('USD', 2);

// Create money from an int.
Money costPrice = Money.fromIntWithCurrency(1000, usdCurrency);
expect(costPrice.toString(), equals(r'$10.00'));

final taxInclusive = costPrice * 1.1;
expect(taxInclusive.toString(), equals(r'$11.00'));

expect(taxInclusive.format('SCC #.00'), equals(r'$US 11.00'));

// Create money from an String using the `Currency` instance.
Money parsed = usdCurrency.parse(r'$10.00');
expect(parsed.format('SCCC 0.00'), equals(r'$USD 10.00'));

// Create money from an int which contains the MajorUnit (e.g dollars)
Money buyPrice = Money.fromNum(10, code: 'AUD');
expect(buyPrice.toString(), equals(r'$10.00'));

// Create money from a double which contains Major and Minor units (e.g. dollars and cents)
// We don't recommend transporting money as a double as you will get rounding errors.
Money sellPrice = Money.fromNum(10.50, code: 'AUD');
expect(sellPrice.toString(), equals(r'$10.50'));
```


# Upgrading from v4 to v5
The Money2 5.0.0 release introduces a number of breaking changes:

- The 'invertSeparator' argument to the Currency class has been broken out 
into two separate arguments 'groupSeparator' and 'decimalSeparator'. 

If you have been using 'invertSeparator: true' then you need to replace this with
```dart
  groupSeparator: '.',
  decimalSeparator: ',',
```
- patterns used for parsing and formatting must always use ',' for group separators
and '.' for decimal separators **regardless** of what has been used for the
groupSeparator and decimalSeparator. This allows a single pattern to be used across currencies rather than having
to create a unique pattern for each currency when looking to use custom formats.

So if you have been using 'invertSeparator: true' then you will 
need to modifiy any custom patterns from '#.###,##' to '#,###.##'.

Note the change in the separators!


- For methods that take a 'code' it has been renamed 'isoCode' to make the
correct use of the code more apparent.

- renamed PatterDecoder.isCode to isIsoCode
- renamed CurrencyCode to CurrencyIsoCode
- renamed all occurances of 'scale' to 'decimalDigits' as many people
  are not familiar with the concept of scale.
- changed toScale on ExchangeRate members to be 'toDecimalDigits'.



Here is how we used separators in the old v4 code:

```dart
  final euro = Currency.create('EUR', 2,
      symbol: '€',
      invertSeparators: true,
      pattern: '#.##0,00 S');

  final bmwPrice = Money.fromIntWithCurrency(10025090, euro);
  print(bmwPrice);
  // > 100.250,90 €
  ```

  In v5 you need to change this to:

  ```dart
    final euro = Currency.create('EUR', 2,
      symbol: '€',
      groupSeparator: '.',
      decimalSeparator: ',',
      pattern: '#,##0.00 S');

  final bmwPrice = Money.fromIntWithCurrency(10025090, euro);
  print(bmwPrice);
  // > 100.250,90 €
  ```

  Note: the `pattern` format has changed.

  
