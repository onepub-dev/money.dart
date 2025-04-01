import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Check if asList() contains all defined currencies', () {
    // Determine the correct file path
    final currentDir = Directory.current.path;
    final filePath = '$currentDir/lib/src/common_currencies.dart';
    final file = File(filePath);

    // Ensure the file exists
    expect(
      file.existsSync(),
      isTrue,
      reason: '❌ Error: File $filePath does not exist.',
    );

    // Read all lines from the file
    final content = file.readAsStringSync();

    // Sets to store currencies defined in the class and included in asList()
    final Set<String> definedCurrencies = {};
    final Set<String> asListCurrencies = {};

    // Regular expression to match currency definitions
    final RegExp currencyDefRegex = RegExp(r'\bfinal Currency (\w+)');

    // Extract defined currencies
    for (final match in currencyDefRegex.allMatches(content)) {
      definedCurrencies.add(match.group(1)!);
    }

    // Extract currencies from asList()
    final RegExp asListRegex = RegExp(
      r'asList\(\) => \[([\s\S]*?)\];',
    );
    final asListMatch = asListRegex.firstMatch(content);

    if (asListMatch != null) {
      final asListBody = asListMatch.group(1)!;
      final matches = RegExp(r'(\w+),').allMatches(asListBody);
      for (final m in matches) {
        asListCurrencies.add(m.group(1)!);
      }
    } else {
      fail('❌ Error: Could not find asList() method in $filePath');
    }

    // Find missing currencies that are defined but not included in asList()
    final missingCurrencies = definedCurrencies.difference(asListCurrencies);

    // Run test assertion
    expect(
      missingCurrencies,
      isEmpty,
      reason: '❌ The following currencies are missing in asList():\n' +
          missingCurrencies.map((c) => '- $c').join('\n'),
    );
  });
}
