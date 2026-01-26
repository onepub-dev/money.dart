// this is a cli tool
// ignore_for_file: avoid_print

import 'currency_models.dart';

CurrencyDiff diffCurrencies(
    Map<String, ExistingCurrency> existing, List<Map<String, dynamic>> merged) {
  final mergedByCode = <String, Map<String, dynamic>>{};
  for (final entry in merged) {
    mergedByCode[entry['code'] as String] = entry;
  }

  final added = <String>{};
  final removed = <String>{};
  final updated = <String>{};

  for (final code in mergedByCode.keys) {
    final existingEntry = existing[code];
    if (existingEntry == null) {
      added.add(code);
      continue;
    }
    final mergedEntry = mergedByCode[code]!;
    if (!_entriesEqual(existingEntry.data, mergedEntry)) {
      updated.add(code);
    }
  }

  for (final code in existing.keys) {
    if (!mergedByCode.containsKey(code)) {
      removed.add(code);
    }
  }

  return CurrencyDiff(added, removed, updated);
}

void reportChanges(
    int originalCount, int isoCount, int extrasCount, CurrencyDiff diff) {
  print('Existing currencies: $originalCount');
  print('ISO currencies: $isoCount');
  print('Extras currencies: $extrasCount');
  print('Added: ${diff.added.length}');
  if (diff.added.isNotEmpty) {
    print('   + ${_formatCodes(diff.added)}');
  }
  print('Removed: ${diff.removed.length}');
  if (diff.removed.isNotEmpty) {
    print('   - ${_formatCodes(diff.removed)}');
  }
  print('Updated: ${diff.updated.length}');
  if (diff.updated.isNotEmpty) {
    print('   * ${_formatCodes(diff.updated)}');
  }
}

List<Map<String, dynamic>> mergeCurrencies(
  Map<String, ExistingCurrency> existing,
  List<IsoCurrency> isoEntries,
  Map<String, ExistingCurrency> extras,
) {
  final byCode = <String, List<IsoCurrency>>{};
  for (final entry in isoEntries) {
    byCode.putIfAbsent(entry.code, () => []).add(entry);
  }

  final merged = <Map<String, dynamic>>[];
  for (final code in byCode.keys.toList()..sort()) {
    final entries = byCode[code]!;
    final existingEntry = existing[code];
    final extraEntry = extras[code];
    if (extraEntry != null) {
      merged.add(_buildExtraEntry(code, entries, existingEntry, extraEntry));
      continue;
    }

    final name = _pickName(entries) ?? existingEntry?.name ?? '';
    final decimalDigits = _pickDecimalDigits(entries, existingEntry);
    final country = _pickCountry(entries, existingEntry);
    final unit = existingEntry?.unit ?? name;

    merged.add(_buildEntry(
      code: code,
      decimalDigits: decimalDigits,
      country: country,
      unit: unit,
      name: name,
      existing: existingEntry,
      isIso: true,
      isDeprecated: false,
      replacedBy: null,
    ));
  }

  final extraCodes =
      extras.keys.where((code) => !byCode.containsKey(code)).toList()..sort();
  for (final code in extraCodes) {
    merged.add(_buildEntryFromExtra(code, existing, extras));
  }

  return merged;
}

Map<String, dynamic> _buildExtraEntry(String code, List<IsoCurrency> entries,
    ExistingCurrency? existingEntry, ExistingCurrency extraEntry) {
  final name = _pickName(entries) ?? extraEntry.name ?? '';
  final decimalDigits = _pickDecimalDigits(entries, existingEntry);
  final country = _pickCountry(entries, existingEntry);
  final unit = extraEntry.unit ?? name;

  return _buildEntry(
    code: code,
    decimalDigits: decimalDigits,
    country: country,
    unit: unit,
    name: name,
    existing: existingEntry ?? extraEntry,
    isIso: true,
    isDeprecated: extraEntry.isDeprecated,
    replacedBy: extraEntry.replacedBy,
  );
}

Map<String, dynamic> _buildEntryFromExtra(
    String code,
    Map<String, ExistingCurrency> existing,
    Map<String, ExistingCurrency> extras) {
  final existingEntry = existing[code];
  final extraEntry = extras[code]!;
  final decimalDigits = extraEntry.data['decimalDigits'] as int? ?? 2;
  final name = extraEntry.name ?? '';
  final unit = extraEntry.unit ?? name;
  final country = extraEntry.country ?? '';

  return _buildEntry(
    code: code,
    decimalDigits: decimalDigits,
    country: country,
    unit: unit,
    name: name,
    existing: existingEntry ?? extraEntry,
    isIso: false,
    isDeprecated: extraEntry.isDeprecated,
    replacedBy: extraEntry.replacedBy,
  );
}

Map<String, dynamic> _buildEntry({
  required String code,
  required int decimalDigits,
  required String country,
  required String unit,
  required String name,
  required ExistingCurrency? existing,
  required bool isIso,
  required bool isDeprecated,
  required String? replacedBy,
}) {
  final entry = <String, dynamic>{
    'code': code,
    'decimalDigits': decimalDigits,
    'iso': isIso,
    'deprecated': isDeprecated,
  };

  void addIfNonEmpty(String key, String? value) {
    if (value != null && value.isNotEmpty) {
      entry[key] = value;
    }
  }

  addIfNonEmpty('symbol', existing?.symbol);
  addIfNonEmpty('pattern', existing?.pattern);
  addIfNonEmpty('groupSeparator', existing?.groupSeparator);
  addIfNonEmpty('decimalSeparator', existing?.decimalSeparator);
  addIfNonEmpty('country', country);
  addIfNonEmpty('unit', unit);
  addIfNonEmpty('name', name);
  addIfNonEmpty('varName', existing?.varName);
  addIfNonEmpty('replacedBy', replacedBy);

  return entry;
}

String? _pickName(List<IsoCurrency> entries) {
  final names = <String>{};
  for (final entry in entries) {
    if (entry.name.isNotEmpty) {
      names.add(entry.name);
    }
  }
  if (names.isEmpty) {
    return null;
  }
  if (names.length == 1) {
    return names.first;
  }
  return names.first;
}

int _pickDecimalDigits(
    List<IsoCurrency> entries, ExistingCurrency? existingEntry) {
  final digits = <int>{};
  for (final entry in entries) {
    digits.add(entry.decimalDigits);
  }
  if (digits.isNotEmpty) {
    return digits.first;
  }
  return (existingEntry?.data['decimalDigits'] as int?) ?? 2;
}

String _pickCountry(
    List<IsoCurrency> entries, ExistingCurrency? existingEntry) {
  if (existingEntry?.country != null && existingEntry!.country!.isNotEmpty) {
    return existingEntry.country!;
  }
  if (entries.length == 1) {
    return entries.first.country;
  }
  return 'Multiple';
}

bool _entriesEqual(Map<String, dynamic> existing, Map<String, dynamic> merged) {
  final existingNormalized = Map<String, dynamic>.from(existing)
    ..removeWhere((key, value) => value == null || value == '');
  for (final key in existingNormalized.keys.toList()) {
    if (!merged.containsKey(key)) {
      existingNormalized.remove(key);
    }
  }
  for (final entry in merged.entries) {
    if (!existingNormalized.containsKey(entry.key)) {
      existingNormalized[entry.key] = entry.value;
    }
  }
  return _mapsEqual(existingNormalized, merged);
}

bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a.length != b.length) {
    return false;
  }
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) {
      return false;
    }
    if (b[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}

String _formatCodes(Set<String> codes) {
  final sorted = codes.toList()..sort();
  return sorted.join(', ');
}
