import 'dart:io';

import 'package:yaml/yaml.dart';

import 'currency_models.dart';

Map<String, ExistingCurrency> readExistingYaml(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return {};
  }
  final text = file.readAsStringSync();
  if (text.trim().isEmpty) {
    return {};
  }
  final yamlList = loadYaml(text) as YamlList;
  final map = <String, ExistingCurrency>{};
  for (final node in yamlList) {
    final entry = (node as YamlMap).cast<String, dynamic>();
    final code = entry['code'] as String?;
    if (code == null || code.isEmpty) {
      continue;
    }
    map[code] = ExistingCurrency(code: code, data: entry);
  }
  return map;
}

Map<String, ExistingCurrency> readExtrasYaml(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return {};
  }
  final text = file.readAsStringSync();
  if (text.trim().isEmpty) {
    return {};
  }
  final yamlList = loadYaml(text) as YamlList;
  final map = <String, ExistingCurrency>{};
  for (final node in yamlList) {
    final entry = (node as YamlMap).cast<String, dynamic>();
    final code = entry['code'] as String?;
    if (code == null || code.isEmpty) {
      continue;
    }
    map[code] = ExistingCurrency(code: code, data: entry);
  }
  return map;
}

String writeYaml(List<Map<String, dynamic>> entries) {
  final buf = StringBuffer('# Generated common currencies\n\n');

  final sorted = entries.toList()
    ..sort((a, b) {
      final countryA = (a['country'] as String?) ?? '';
      final countryB = (b['country'] as String?) ?? '';
      final countryCompare = countryA.compareTo(countryB);
      if (countryCompare != 0) {
        return countryCompare;
      }
      return (a['code'] as String).compareTo(b['code'] as String);
    });

  for (final entry in sorted) {
    buf
      ..writeln('- code: ${entry['code']}')
      ..writeln('  decimalDigits: ${entry['decimalDigits']}')
      ..writeln('  iso: ${entry['iso'] ?? true}');

    final deprecated = entry['deprecated'] as bool? ?? false;
    if (deprecated) {
      buf.writeln('  deprecated: true');
    }

    void writeStringField(String key) {
      final value = entry[key] as String?;
      if (value == null || value.isEmpty) {
        return;
      }
      buf.writeln('  $key: "${escapeYaml(value)}"');
    }

    writeStringField('symbol');
    writeStringField('pattern');
    writeStringField('groupSeparator');
    writeStringField('decimalSeparator');
    writeStringField('country');
    writeStringField('unit');
    writeStringField('name');
    writeStringField('varName');
    writeStringField('replacedBy');
    buf.writeln();
  }

  return buf.toString();
}

String escapeYaml(String value) =>
    value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
