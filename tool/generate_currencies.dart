#! /usr/bin/env dart
// bin/generate_currencies.dart
//
// Generates:
//   1) lib/src/common_currencies.g.dart  — Dart definitions for CommonCurrencies
//   2) common_currencies.md              — Markdown summary of all currencies
//
// Usage:
//   dart tool/generate_currencies.dart
//
// This reads tool/currencies.yaml and produces a strongly typed
// `CommonCurrencies` class with predefined Currency instances.
//
// Example (in your app):
//
// ```dart
// import 'package:money2/money2.dart';
//
// final common = CommonCurrencies();
// final usd = common.usd;
// final price = Money.fromIntWithCurrency(1000, usd);
// print(price); // $10.00
// ```
//
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:yaml/yaml.dart';

const _yamlPath = 'tool/currencies.yaml';
const _dartOutPath = 'lib/src/common_currencies.g.dart';
const _mdOutPath = 'common_currencies.md';

void main() {
  final defs = readYaml();

  final code = generateCode(defs);
  File(_dartOutPath).writeAsStringSync(code);
  print('✅ Dart code written to $_dartOutPath');

  final md = generateMarkdown(defs);
  File(_mdOutPath).writeAsStringSync(md);
  print('✅ Markdown written to $_mdOutPath');
}

/// Currency definition read from YAML
class CurrencyDef {
  final String code;
  final int decimalDigits;
  final String? symbol;
  final String? pattern;
  final String? groupSeparator;
  final String? decimalSeparator;
  final String country;
  final String unit;
  final String name;
  final String varName;

  CurrencyDef({
    required this.code,
    required this.varName,
    required this.decimalDigits,
    required this.country,
    required this.unit,
    required this.name,
    this.symbol,
    this.pattern,
    this.groupSeparator,
    this.decimalSeparator,
  });
}

List<CurrencyDef> readYaml() {
  final text = File(_yamlPath).readAsStringSync();
  final yamlList = loadYaml(text) as YamlList;
  return yamlList.map<CurrencyDef>((node) {
    final map = node as YamlMap;
    return CurrencyDef(
      code: map['code'] as String,
      varName: ((map['varName'] as String?) ?? (map['code'] as String))
          .toLowerCase(),
      decimalDigits: map['decimalDigits'] as int,
      symbol: map['symbol'] as String?,
      pattern: map['pattern'] as String?,
      groupSeparator: map['groupSeparator'] as String?,
      decimalSeparator: map['decimalSeparator'] as String?,
      country: map['country'] as String,
      unit: map['unit'] as String,
      name: map['name'] as String,
    );
  }).toList();
}

String generateCode(List<CurrencyDef> defs) {
  defs.sort((a, b) => a.code.compareTo(b.code));

  final buf = StringBuffer()
    ..writeln('/// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln('library;')
    ..writeln('/*')
    ..writeln(' * Copyright (c) 2025 S. Brett Sutton')
    ..writeln(' * SPDX-License-Identifier: MIT')
    ..writeln(' *')
    ..writeln(' * This file is part of the “Money2” project.')
    ..writeln(
        ' * See the LICENSE file in the project root for full license text.')
    ..writeln(' */')
    ..writeln()
    ..writeln("import 'currency.dart';")
    ..writeln()
    ..writeln('/// Provides a list of the most common currencies.')
    ..writeln('///')
    ..writeln('/// Example usage:')
    ..writeln('/// ```dart')
    ..writeln('/// final common = CommonCurrencies();')
    ..writeln('/// final usd = common.usd;')
    ..writeln('/// final price = Money.fromIntWithCurrency(1000, usd);')
    ..writeln(r'/// print(price); // $10.00')
    ..writeln('/// ```')
    ..writeln()
    ..writeln('class CommonCurrencies {')
    ..writeln('  static final CommonCurrencies _self = CommonCurrencies._();')
    ..writeln('  factory CommonCurrencies() => _self;')
    ..writeln('  CommonCurrencies._();')
    ..writeln();

  for (final d in defs) {
    buf
      ..writeln('  /// ${d.name}')
      ..writeln('  final ${d.varName} = Currency.create(')
      ..writeln("    '${d.code}',")
      ..writeln('    ${d.decimalDigits},');
    if (d.symbol != null && d.symbol!.isNotEmpty) {
      final raw = d.symbol!.contains(r'$') ? 'r' : '';
      buf.writeln("    symbol: $raw'${d.symbol}',");
    }
    if (d.pattern != null && d.pattern!.isNotEmpty) {
      buf.writeln("    pattern: '${_escapeSingleQuotes(d.pattern!)}',");
    }
    if (d.groupSeparator != null && d.groupSeparator!.isNotEmpty) {
      buf.writeln(
          "    groupSeparator: '${_escapeSingleQuotes(d.groupSeparator!)}',");
    }
    if (d.decimalSeparator != null && d.decimalSeparator!.isNotEmpty) {
      buf.writeln("""
    decimalSeparator: '${_escapeSingleQuotes(d.decimalSeparator!)}',""");
    }
    buf
      ..writeln("    country: '${_escapeSingleQuotes(d.country)}',")
      ..writeln("    unit: '${_escapeSingleQuotes(d.unit)}',")
      ..writeln("    name: '${_escapeSingleQuotes(d.name)}'")
      ..writeln('  );')
      ..writeln();
  }

  buf.writeln('  List<Currency> asList() => [');
  for (final d in defs) {
    buf.writeln('    ${d.varName},');
  }
  buf
    ..writeln('  ];')
    ..writeln('}');
  return buf.toString();
}

String generateMarkdown(List<CurrencyDef> defs) {
  defs.sort((a, b) => a.code.compareTo(b.code));

  // Defaults
  const defaultDigits = 2;
  const defaultGroupSep = ',';
  const defaultDecimalSep = '.';
  const defaultSymbol = '';
  const defaultPattern = 'S#,##0.00';

  final buf = StringBuffer()
    ..writeln('# Common Currencies')
    ..writeln()
    ..writeln('''
This document is auto-generated from `tool/currencies.yaml` by `tool/generate_currencies.dart`.''')
    ..writeln()
    ..writeln('''
Each row represents a currency available via the `CommonCurrencies` class:''')
    ..writeln()
    ..writeln('```dart')
    ..writeln('final common = CommonCurrencies();')
    ..writeln('final usd = common.usd;')
    ..writeln('final amount = Money.fromIntWithCurrency(2500, usd);')
    ..writeln(r'print(amount); // $25.00')
    ..writeln('```')
    ..writeln()
    ..writeln('Empty fields indicate the value matches the default below:')
    ..writeln('- Decimal Digits: 2')
    ..writeln(r'- Symbol: "$"')
    ..writeln('- Pattern: "S#,##0.00"')
    ..writeln('- Group Separator: ","')
    ..writeln('- Decimal Separator: "."')
    ..writeln()
    ..writeln('**Total currencies:** ${defs.length}')
    ..writeln()
    ..writeln('''
| ISO | Common | Name | Country | Unit | Symbol | Pattern | Group Sep | Decimal Sep | Decimal Digits |''')
    ..writeln('''
|-----|--------|------|---------|------|--------|----------|------------|--------------|----------------|''');

  for (final d in defs) {
    final iso = _mdEsc(d.code);
    final common = _mdCode(d.varName);
    final name = _mdEsc(d.name);
    final country = _mdEsc(d.country);
    final unit = _mdEsc(d.unit);

    final symbolCell = (d.symbol != null && d.symbol != defaultSymbol)
        ? _mdCode(d.symbol!)
        : '';
    final patternCell = (d.pattern != null && d.pattern != defaultPattern)
        ? _mdCode(d.pattern!)
        : '';
    final groupSepCell = (d.groupSeparator != null &&
            d.groupSeparator!.isNotEmpty &&
            d.groupSeparator != defaultGroupSep)
        ? _mdCode(d.groupSeparator!)
        : '';
    final decSepCell = (d.decimalSeparator != null &&
            d.decimalSeparator!.isNotEmpty &&
            d.decimalSeparator != defaultDecimalSep)
        ? _mdCode(d.decimalSeparator!)
        : '';
    final digitsCell =
        (d.decimalDigits != defaultDigits) ? d.decimalDigits.toString() : '';

    buf.writeln('''
| $iso | $common | $name | $country | $unit | $symbolCell | $patternCell | $groupSepCell | $decSepCell | $digitsCell |''');
  }

  buf
    ..writeln()
    ..writeln('> Regenerate with:')
    ..writeln('>')
    ..writeln('> ```bash')
    ..writeln('> dart tool/generate_currencies.dart')
    ..writeln('> ```');

  return buf.toString();
}

// Helpers

String _escapeSingleQuotes(String s) => s.replaceAll("'", r"\'");

String _mdEsc(String s) =>
    s.replaceAll('|', r'\|').replaceAll('<', r'\<').replaceAll('>', r'\>');

String _mdCode(String s) {
  if (s.isEmpty) {
    return '';
  }
  final hasBacktick = s.contains('`');
  final fence = hasBacktick ? '``' : '`';
  return '$fence$s$fence';
}
