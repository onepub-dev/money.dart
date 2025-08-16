import 'package:money2/src/percentage.dart';
import 'package:test/test.dart';

void main() {
  test('percentage ...', ()  {
    var percentage = Percentage(100, decimalDigits: 3);
    expect(percentage.integerPart.toInt(), equals(0));
    expect(percentage.decimalPart.toInt(), equals(100));
    expect(percentage.decimalDigits, equals(3));

    // 100 %
    percentage = Percentage.tryParse('100', decimalDigits: 0)!;
    expect(percentage.integerPart.toInt(), equals(100));
    expect(percentage.decimalPart.toInt(), equals(0));
    expect(percentage.decimalDigits, equals(0));
    expect(percentage.toString(), equals('100%'));

    /// 20.5%
    percentage = Percentage.tryParse('20.5', decimalDigits: 3)!;
    expect(percentage.integerPart.toInt(), equals(20));
    expect(percentage.decimalPart.toInt(), equals(500));
    expect(percentage.decimalDigits, equals(3));
    expect(percentage.toString(), equals('20.500%'));

    ///
    percentage = Percentage.fromInt(205);
    expect(percentage.integerPart.toInt(), equals(2));
    expect(percentage.decimalPart.toInt(), equals(5));
    expect(percentage.decimalDigits, equals(2));

    expect(percentage.toString(), equals('2.05%'));

    /// copyWith
    percentage = Percentage.fromInt(20500, decimalDigits: 4);
    expect(percentage.integerPart, equals(BigInt.from(2)));
    expect(percentage.decimalPart, equals(BigInt.from(500)));
    expect(percentage.decimalDigits, equals(4));

    final one = percentage.copyWith(decimalDigits: 3);
    expect(one.integerPart, equals(BigInt.from(2)));
    expect(one.decimalPart, equals(BigInt.from(50)));
    expect(one.decimalDigits, equals(3));
  });
}
