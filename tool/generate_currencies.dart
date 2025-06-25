// bin/generate_currencies.dart
// Dart CLI script to read currencies.yaml and generate
// a sorted CommonCurrencies Dart file (lib/common_currencies.g.dart).

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:yaml/yaml.dart';

const _yamlPath = 'tool/currencies.yaml';
const _outputPath = 'lib/src/common_currencies.g.dart';

void main() {
  final defs = readYaml();
  final code = generateCode(defs);
  File(_outputPath).writeAsStringSync(code);
  print('✅ Dart code written to $_outputPath');
}

/// Currency definition read from YAML (with override)
class CurrencyDef {
  CurrencyDef({
    required this.code,
    required this.varName,
    required this.scale,
    required this.country,
    required this.unit,
    required this.name,
    this.symbol,
    this.pattern,
    this.groupSeparator,
    this.decimalSeparator,
  });
  final String code;
  final int scale;
  final String? symbol;
  final String? pattern;
  final String? groupSeparator;
  final String? decimalSeparator;
  final String country;
  final String unit;
  final String name;
  final String? varName;
}

List<CurrencyDef> readYaml() {
  final text = File(_yamlPath).readAsStringSync();
  final yamlList = loadYaml(text) as YamlList;
  return yamlList.map<CurrencyDef>((node) {
    final map = node as YamlMap;
    return CurrencyDef(
      code: map['code'] as String,
      varName:
          (map['varName'] as String? ?? map['code'] as String).toLowerCase(),
      scale: map['decimalDigites'] as int,
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
    ..writeln('/// The full list of currencies are available when you')
    ..writeln('/// parse an amount.')
    ..writeln('///')
    ..writeln('/// ```dart')
    ..writeln(r'''/// Currencies.parse('$AUD10.00', pattern: 'SCCC#.#');''')
    ..writeln('/// ```')
    ..writeln('/// ')
    ..writeln('/// Or when you simply need access to a common currency')
    ..writeln('/// ```dart')
    ..writeln('/// CommonCurrencies().usd')
    ..writeln('/// ```')
    ..writeln('///')
    ..writeln('///')
    ..writeln()
    ..writeln('class CommonCurrencies {')
    ..writeln('  factory CommonCurrencies() => _self;')
    ..writeln('  CommonCurrencies._();')
    ..writeln('  static final CommonCurrencies _self = CommonCurrencies._();')
    ..writeln();

  for (final d in defs) {
    buf
      ..writeln('  /// ${d.name}')
      ..writeln('  final Currency ${d.varName} = Currency.create(')
      ..writeln("\t\t'${d.code}',")
      ..writeln('\t\t${d.scale},');
    if (d.symbol != null) {
      var symbolRaw = '';
      if (d.symbol!.contains(r'$')) {
        symbolRaw = 'r';
      }
      buf.writeln("\t\tsymbol: $symbolRaw'${d.symbol}',");
    }
    if (d.pattern != null) {
      buf.writeln("\t\tpattern: '${d.pattern}',");
    }
    if (d.groupSeparator != null) {
      buf.writeln("\t\tgroupSeparator: '${d.groupSeparator}',");
    }
    if (d.decimalSeparator != null) {
      buf.writeln("\t\tdecimalSeparator: '${d.decimalSeparator}',");
    }
    buf
      ..writeln("\t\tcountry: '${d.country}',")
      ..writeln("\t\tunit: '${d.unit}',")
      ..writeln("\t\tname: '${d.name}'")
      ..writeln('\t);\n');
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
