// da real fromInt that's what I'm talking about

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final euro = CommonCurrencies().euro;
  test('Money.fromInteger', () {
    final m = Money.fromInteger(10, code: 'EUR');
    expect(m.toString(), '10,00€');
    expect(m.minorUnits.toInt(), 1000);
    final mWithC = Money.fromIntegerWithCurrency(10, euro);
    expect(mWithC.toString(), '10,00€');
  });
}
