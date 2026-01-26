// this is a cli tool
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:xml/xml.dart';

import 'currency_models.dart';

Future<bool> downloadIsoXml(String url, String path) async {
  final file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  try {
    await fetch(url: url, saveToPath: path);
  } catch (e) {
    print('ERROR: ISO XML download failed: $e');
    return false;
  }
  if (!file.existsSync() || file.lengthSync() == 0) {
    print('ERROR: ISO XML download failed or is empty: $path');
    return false;
  }
  return true;
}

List<IsoCurrency> readIsoXml(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    print('ERROR: XML file not found: $path');
    return [];
  }
  final xml = file.readAsStringSync();
  if (xml.trim().isEmpty) {
    print('ERROR: XML file is empty: $path');
    return [];
  }
  final document = XmlDocument.parse(xml);
  final entries = document.descendants
      .whereType<XmlElement>()
      .where((element) => element.name.local == 'CcyNtry');

  final results = <IsoCurrency>[];
  for (final entry in entries) {
    final code = _childText(entry, 'Ccy');
    if (code == null || code.isEmpty) {
      continue;
    }
    final name = _childText(entry, 'CcyNm') ?? '';
    final country = _childText(entry, 'CtryNm') ?? '';
    final minorUnitsRaw = _childText(entry, 'CcyMnrUnts');
    final minorUnits = _parseMinorUnits(minorUnitsRaw);

    results.add(IsoCurrency(
      code: code,
      name: name,
      country: country,
      decimalDigits: minorUnits,
    ));
  }
  return results;
}

String? _childText(XmlElement element, String tag) {
  for (final child in element.children.whereType<XmlElement>()) {
    if (child.name.local == tag) {
      return child.innerText.trim();
    }
  }
  return null;
}

int _parseMinorUnits(String? value) {
  if (value == null || value.isEmpty) {
    return 0;
  }
  final normalized = value.trim();
  final parsed = int.tryParse(normalized);
  if (parsed != null) {
    return parsed;
  }
  return 0;
}
