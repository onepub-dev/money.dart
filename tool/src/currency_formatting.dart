// this is a cli tool
// ignore_for_file: avoid_print

import 'cldr_source.dart';

class FormattingStats {
  var filled = 0;
  var warnings = 0;
}

Future<List<Map<String, dynamic>>> applyCldrFormatting(
  List<Map<String, dynamic>> merged,
  CldrData? cldr,
) async {
  final stats = FormattingStats();
  final updated = <Map<String, dynamic>>[];

  for (final entry in merged) {
    final code = entry['code'] as String;
    final decimalDigits = entry['decimalDigits'] as int? ?? 2;

    final needsSymbol = _isMissing(entry['symbol']);
    final needsPattern = _isMissing(entry['pattern']);
    final needsGroup = _isMissing(entry['groupSeparator']);
    final needsDecimal = _isMissing(entry['decimalSeparator']);

    if (needsSymbol || needsPattern || needsGroup || needsDecimal) {
      final format = cldr == null ? null : await cldr.numbersForCurrency(code);
      final symbol = needsSymbol ? format?.symbolFor(code) : null;
      final pattern = needsPattern ? format?.pattern : null;
      final groupSeparator = needsGroup ? format?.groupSeparator : null;
      final decimalSeparator = needsDecimal ? format?.decimalSeparator : null;
      final missingCldr = cldr != null &&
          ((needsSymbol && symbol == null) ||
              (needsPattern && pattern == null) ||
              (needsGroup && groupSeparator == null) ||
              (needsDecimal && decimalSeparator == null));

      final resolved = _applyFormatting(
        entry,
        decimalDigits: decimalDigits,
        symbol: symbol,
        pattern: pattern,
        groupSeparator: groupSeparator,
        decimalSeparator: decimalSeparator,
        stats: stats,
        missingCldr: missingCldr,
      );
      updated.add(resolved);
      continue;
    }

    updated.add(Map<String, dynamic>.from(entry));
  }

  if (cldr == null) {
    print('WARNING: CLDR data unavailable. Using fallback defaults.');
  }
  if (stats.warnings > 0) {
    print('WARNING: ${stats.warnings} currencies lacked CLDR data.');
  }
  if (stats.filled > 0) {
    print('Filled formatting fields for ${stats.filled} currencies.');
  }

  return updated;
}

Map<String, dynamic> _applyFormatting(
  Map<String, dynamic> entry, {
  required int decimalDigits,
  required String? symbol,
  required String? pattern,
  required String? groupSeparator,
  required String? decimalSeparator,
  required FormattingStats stats,
  required bool missingCldr,
}) {
  final updated = Map<String, dynamic>.from(entry);

  final resolvedSymbol = symbol ?? (entry['symbol'] as String?) ?? r'$';
  final resolvedPattern = _normalizePattern(
    pattern ?? (entry['pattern'] as String?) ?? _defaultPattern(decimalDigits),
  );
  final resolvedGroup =
      groupSeparator ?? (entry['groupSeparator'] as String?) ?? ',';
  final resolvedDecimal =
      decimalSeparator ?? (entry['decimalSeparator'] as String?) ?? '.';

  if (_isMissing(entry['symbol'])) {
    updated['symbol'] = resolvedSymbol;
    stats.filled += 1;
  }
  if (_isMissing(entry['pattern'])) {
    updated['pattern'] = resolvedPattern;
    stats.filled += 1;
  }
  if (_isMissing(entry['groupSeparator'])) {
    updated['groupSeparator'] = resolvedGroup;
    stats.filled += 1;
  }
  if (_isMissing(entry['decimalSeparator'])) {
    updated['decimalSeparator'] = resolvedDecimal;
    stats.filled += 1;
  }

  if (missingCldr) {
    stats.warnings += 1;
    final code = entry['code'];
    print('WARNING: Missing CLDR data for $code. Using defaults.');
  }

  return updated;
}

bool _isMissing(Object? value) {
  if (value == null) {
    return true;
  }
  if (value is String) {
    return value.trim().isEmpty;
  }
  return false;
}

String _defaultPattern(int decimalDigits) {
  if (decimalDigits <= 0) {
    return 'S#,##0';
  }
  return 'S#,##0.${'0' * decimalDigits}';
}

String _normalizePattern(String pattern) {
  if (pattern.contains('¤')) {
    return pattern.replaceAll(RegExp('¤+'), 'S');
  }
  return pattern;
}
