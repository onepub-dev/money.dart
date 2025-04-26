/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:convert';

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final money = Money.fromInt(1025, isoCode: 'USD');
  final expectedJson = <String, dynamic>{
    'minorUnits': '1025',
    'decimals': 2,
    'isoCode': 'USD',
  };

  test('Money is correctly serialized to JSON', () {
    final moneyJson = money.toJson();
    expect(moneyJson, equals(expectedJson));
  });

  test('Money is correctly encoded as JSON string', () {
    final moneyJsonString = jsonEncode(money);
    final expectedJsonString = jsonEncode(money.toJson());
    expect(moneyJsonString, equals(expectedJsonString));
  });

  test('Money is correctly decoded from JSON', () {
    final moneyJsonString = jsonEncode(expectedJson);
    final decodedMoney = Money.fromJson(
      jsonDecode(moneyJsonString) as Map<String, dynamic>,
    );
    expect(decodedMoney, equals(money));
  });

  test('Serialize and deserialize should be inverse operations', () {
    expect(money, equals(Money.fromJson(money.toJson())));
  });

  test('Full round trip should be equal to original', () {
    final moneyJsonString = jsonEncode(money);
    final decodedMoney = Money.fromJson(
      jsonDecode(moneyJsonString) as Map<String, dynamic>,
    );
    expect(decodedMoney, equals(money));
  });

  test('No lost in precision for valid money values', () {
    const largeScale = 12;
    final largeScaleCurrency = Currency.create('test', largeScale);
    Currencies().register(largeScaleCurrency);

    final privateNetWealth = BigInt.from(454e+12);
    final decimalPart = BigInt.from(123456789012);
    final privateNetWealthMoney = Money.fromBigInt(
      privateNetWealth * largeScaleCurrency.decimalDigitsFactor + decimalPart,
      isoCode: 'test',
    );
    expect(privateNetWealthMoney.amount.integerPart, equals(privateNetWealth));
    expect(privateNetWealthMoney.amount.decimalPart, equals(decimalPart));
    expect(privateNetWealthMoney.amount.decimalDigits, equals(largeScale));

    final reconstructed = Money.fromJson(privateNetWealthMoney.toJson());
    expect(reconstructed.amount.integerPart, equals(privateNetWealth));
    expect(reconstructed.amount.decimalPart, equals(decimalPart));
    expect(reconstructed.amount.decimalDigits, equals(largeScale));
    expect(reconstructed, equals(privateNetWealthMoney));
  });
}
