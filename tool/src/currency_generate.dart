import 'dart:io';

import 'package:yaml/yaml.dart';

import 'currency_models.dart';

List<CurrencyDef> readCurrencyYaml(String path) {
  final text = File(path).readAsStringSync();
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
      isIso: map['iso'] as bool? ?? true,
      isDeprecated: map['deprecated'] as bool? ?? false,
      replacedBy: map['replacedBy'] as String?,
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
    ..writeln('  static final _self = CommonCurrencies._();')
    ..writeln();

  for (final d in defs) {
    buf
      ..writeln('  /// ${d.name}')
      ..writeln('  final ${d.varName} = Currency.create(')
      ..writeln("    '${d.code}',")
      ..writeln('    ${d.decimalDigits},');
    if (d.symbol != null && d.symbol!.isNotEmpty && d.symbol != r'$') {
      buf.writeln('    symbol: ${_stringLiteral(d.symbol!)},');
    }
    if (d.pattern != null &&
        d.pattern!.isNotEmpty &&
        d.pattern != 'S#,##0.00') {
      buf.writeln('    pattern: ${_stringLiteral(d.pattern!)},');
    }
    if (d.groupSeparator != null &&
        d.groupSeparator!.isNotEmpty &&
        d.groupSeparator != ',') {
      buf.writeln('    groupSeparator: '
          '${_stringLiteral(d.groupSeparator!)},');
    }
    if (d.decimalSeparator != null &&
        d.decimalSeparator!.isNotEmpty &&
        d.decimalSeparator != '.') {
      buf.writeln('    decimalSeparator: '
          '${_stringLiteral(d.decimalSeparator!)},');
    }
    if (!d.isIso) {
      buf.writeln('    isIso: false,');
    }
    if (d.isDeprecated) {
      buf.writeln('    isDeprecated: true,');
    }
    if (d.replacedBy != null && d.replacedBy!.isNotEmpty) {
      buf.writeln('    replacedBy: ${_stringLiteral(d.replacedBy!)},');
    }
    buf
      ..writeln('    country: ${_stringLiteral(d.country)},')
      ..writeln('    unit: ${_stringLiteral(d.unit)},')
      ..writeln('    name: ${_stringLiteral(d.name)}')
      ..writeln('  );')
      ..writeln();
  }

  buf
    ..writeln('  factory CommonCurrencies() => _self;')
    ..writeln('  CommonCurrencies._();')
    ..writeln()
    ..writeln('  List<Currency> asList() => [');
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

  final buf = StringBuffer()
    ..writeln('# Common Currencies')
    ..writeln()
    ..writeln('''
This document is auto-generated from `tool/currencies.yaml` by `tool/update_currencies.dart`.''')
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
    ..writeln('**Total currencies:** ${defs.length}')
    ..writeln()
    ..writeln('Run:')
    ..writeln()
    ..writeln('```bash')
    ..writeln('dart tool/update_currencies.dart')
    ..writeln('```')
    ..writeln()
    ..writeln('| Code | Common | ISO | Name | Country | Unit | Symbol | '
        'Pattern | Group Sep | Decimal Sep | Decimal Digits |')
    ..writeln('|------|--------|-----|------|---------|------|--------|'
        '---------|-----------|-------------|----------------|');

  for (final d in defs) {
    buf.writeln('| ${d.code} '
        '| ${d.varName} '
        '| ${d.isIso ? 'Yes' : 'No'} '
        '| ${d.name} '
        '| ${d.country} '
        '| ${d.unit} '
        '| ${d.symbol ?? ''} '
        '| ${d.pattern ?? ''} '
        '| ${d.groupSeparator ?? ''} '
        '| ${d.decimalSeparator ?? ''} '
        '| ${d.decimalDigits} |');
  }

  return buf.toString();
}

String _stringLiteral(String value) {
  final hasSingle = value.contains("'");
  final hasDouble = value.contains('"');
  final hasBackslash = value.contains(r'\\');
  final hasDollar = value.contains(r'$');

  if (!hasSingle && !hasBackslash && !hasDollar) {
    return "'$value'";
  }
  if (!hasDouble && !hasBackslash && !hasDollar) {
    return '"$value"';
  }

  if (!hasSingle && (hasBackslash || hasDollar)) {
    return "r'$value'";
  }
  if (!hasDouble && (hasBackslash || hasDollar)) {
    return 'r"$value"';
  }

  final quote = (hasSingle && !hasDouble) ? '"' : "'";
  var escaped = value.replaceAll(r'\', r'\\');
  if (quote == "'") {
    escaped = escaped.replaceAll("'", r"\'");
  } else {
    escaped = escaped.replaceAll('"', r'\"');
  }
  if (hasDollar) {
    escaped = escaped.replaceAll(r'$', r'\$');
  }
  return '$quote$escaped$quote';
}
