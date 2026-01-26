#! /usr/bin/env dart
// tool/update_currencies.dart
//
// Regenerates tool/currencies.yaml from ISO 4217 list-one.xml data and
// regenerates common currency outputs.
//
// Usage:
//   dart tool/update_currencies.dart
//
// This script preserves symbol/pattern/formatting fields from existing
// currencies.yaml where possible, while updating ISO-sourced fields.
// Additional non-ISO or deprecated entries are loaded from
// tool/currencies_extras.yaml.
//
// ignore_for_file: avoid_print

import 'dart:io';

import 'src/cldr_source.dart';
import 'src/currency_formatting.dart';
import 'src/currency_generate.dart';
import 'src/currency_merge.dart';
import 'src/currency_yaml.dart';
import 'src/iso_source.dart';

const _isoUrl =
    'https://www.six-group.com/dam/download/financial-information/data-center/'
    'iso-currrency/lists/list-one.xml';
const _cldrBaseUrl =
    'https://raw.githubusercontent.com/unicode-org/cldr-json/48.0.0/cldr-json';
const _defaultXmlPath = 'tool/iso-list-one.xml';
const _defaultYamlPath = 'tool/currencies.yaml';
const _extrasYamlPath = 'tool/currencies_extras.yaml';
const _cldrCachePath = 'tool/cldr-cache';
const _dartOutPath = 'lib/src/common_currencies.g.dart';
const _mdOutPath = 'common_currencies.md';

Future<void> main(List<String> args) async {
  final yamlPath = _argValue(args, '--out') ?? _defaultYamlPath;

  final downloaded = await downloadIsoXml(_isoUrl, _defaultXmlPath);
  final existing = readExistingYaml(yamlPath);
  final extras = readExtrasYaml(_extrasYamlPath);
  if (!downloaded) {
    print('ERROR: Failed to download ISO list from $_isoUrl.');
    return;
  }

  final isoEntries = readIsoXml(_defaultXmlPath);
  if (isoEntries.isEmpty) {
    print('ERROR: No ISO currencies were loaded. Aborting update.');
    return;
  }

  final merged = mergeCurrencies(existing, isoEntries, extras);
  final cldr = await loadCldrData(
    baseUrl: _cldrBaseUrl,
    cacheDir: Directory(_cldrCachePath),
  );
  if (cldr == null) {
    print('WARNING: Failed to load CLDR data.');
  }
  final formatted = await applyCldrFormatting(merged, cldr);
  final changes = diffCurrencies(existing, formatted);
  final isoCount = isoEntries.map((entry) => entry.code).toSet().length;
  reportChanges(existing.length, isoCount, extras.length, changes);

  final yaml = writeYaml(formatted);
  File(yamlPath).writeAsStringSync(yaml);
  print('Updated $yamlPath with ${formatted.length} currencies');

  final defs = readCurrencyYaml(yamlPath);
  final code = generateCode(defs);
  File(_dartOutPath).writeAsStringSync(code);
  print('Dart code written to $_dartOutPath');

  final md = generateMarkdown(defs);
  File(_mdOutPath).writeAsStringSync(md);
  print('Markdown written to $_mdOutPath');
}

String? _argValue(List<String> args, String key) {
  final index = args.indexOf(key);
  if (index == -1 || index + 1 >= args.length) {
    return null;
  }
  return args[index + 1];
}
