import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';

class CldrData {
  final Map<String, String> currencyToRegion;
  final Map<String, String> likelySubtags;
  final String numbersBaseUrl;
  final Directory cacheDir;
  final Map<String, LocaleNumbers> _numbersCache = {};

  CldrData({
    required this.currencyToRegion,
    required this.likelySubtags,
    required this.numbersBaseUrl,
    required this.cacheDir,
  });

  String? localeForCurrency(String code) {
    final region = currencyToRegion[code];
    if (region == null || region.isEmpty) {
      return null;
    }

    final direct = likelySubtags['und-$region'];
    if (direct != null && direct.isNotEmpty) {
      return _normalizeLocale(direct);
    }

    final fallback = _firstLocaleForRegion(region);
    if (fallback != null) {
      return _normalizeLocale(fallback);
    }

    return null;
  }

  Future<LocaleNumbers?> numbersForCurrency(String code) async {
    final locale = localeForCurrency(code) ?? 'en';
    final primary = await _loadNumbers(locale);
    if (primary != null) {
      return primary;
    }
    if (locale != 'en') {
      return _loadNumbers('en');
    }
    return null;
  }

  Future<LocaleNumbers?> _loadNumbers(String locale) async {
    if (_numbersCache.containsKey(locale)) {
      return _numbersCache[locale];
    }

    final path = '${cacheDir.path}/numbers-$locale.json';
    final url = '$numbersBaseUrl/$locale/numbers.json';
    final downloaded = await _download(url, path);
    if (!downloaded) {
      return null;
    }

    final file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) {
      return null;
    }

    final decoded = jsonDecode(content) as Map<String, dynamic>;
    final localeNumbers = LocaleNumbers.fromJson(decoded, locale);
    if (localeNumbers == null) {
      return null;
    }
    _numbersCache[locale] = localeNumbers;
    return localeNumbers;
  }

  String? _firstLocaleForRegion(String region) {
    final matches = <String>[];
    for (final entry in likelySubtags.entries) {
      if (entry.key.endsWith('-$region')) {
        matches.add(entry.value);
      }
    }
    matches.sort();
    if (matches.isEmpty) {
      return null;
    }
    return matches.first;
  }
}

class LocaleNumbers {
  final String locale;
  final String groupSeparator;
  final String decimalSeparator;
  final String pattern;
  final Map<String, String> symbols;

  LocaleNumbers({
    required this.locale,
    required this.groupSeparator,
    required this.decimalSeparator,
    required this.pattern,
    required this.symbols,
  });

  String? symbolFor(String code) => symbols[code];

  static LocaleNumbers? fromJson(Map<String, dynamic> json, String locale) {
    final main = json['main'] as Map<String, dynamic>?;
    if (main == null || main.isEmpty) {
      return null;
    }

    final localeData = main[locale] as Map<String, dynamic>? ??
        main.values.first as Map<String, dynamic>;
    final numbers = localeData['numbers'] as Map<String, dynamic>?;
    if (numbers == null) {
      return null;
    }

    final symbols =
        numbers['symbols-numberSystem-latn'] as Map<String, dynamic>?;
    final groupSeparator = symbols?['group'] as String?;
    final decimalSeparator = symbols?['decimal'] as String?;

    final formats =
        numbers['currencyFormats-numberSystem-latn'] as Map<String, dynamic>?;
    final pattern = formats?['standard'] as String? ??
        (formats?.values.isNotEmpty ?? false
            ? formats!.values.first as String
            : null);

    if (groupSeparator == null || decimalSeparator == null || pattern == null) {
      return null;
    }

    final currencyMap = numbers['currencies'] as Map<String, dynamic>?;
    final symbolMap = <String, String>{};
    if (currencyMap != null) {
      for (final entry in currencyMap.entries) {
        final data = entry.value as Map<String, dynamic>?;
        if (data == null) {
          continue;
        }
        final symbol =
            data['symbol'] as String? ?? data['symbol-alt-narrow'] as String?;
        if (symbol != null && symbol.isNotEmpty) {
          symbolMap[entry.key] = symbol;
        }
      }
    }

    return LocaleNumbers(
      locale: locale,
      groupSeparator: groupSeparator,
      decimalSeparator: decimalSeparator,
      pattern: pattern,
      symbols: symbolMap,
    );
  }
}

Future<CldrData?> loadCldrData({
  required String baseUrl,
  required Directory cacheDir,
}) async {
  if (!cacheDir.existsSync()) {
    cacheDir.createSync(recursive: true);
  }

  final currencyPath = '${cacheDir.path}/currencyData.json';
  final subtagsPath = '${cacheDir.path}/likelySubtags.json';

  final currencyOk = await _download(
    '$baseUrl/cldr-core/supplemental/currencyData.json',
    currencyPath,
  );
  final subtagsOk = await _download(
    '$baseUrl/cldr-core/supplemental/likelySubtags.json',
    subtagsPath,
  );

  if (!currencyOk || !subtagsOk) {
    return null;
  }

  final currencyJson = _readJsonFile(currencyPath);
  final subtagsJson = _readJsonFile(subtagsPath);
  if (currencyJson == null || subtagsJson == null) {
    return null;
  }

  final currencyToRegion = _currencyToRegion(currencyJson);
  final likelySubtags = _likelySubtags(subtagsJson);

  return CldrData(
    currencyToRegion: currencyToRegion,
    likelySubtags: likelySubtags,
    numbersBaseUrl: '$baseUrl/cldr-numbers-full/main',
    cacheDir: cacheDir,
  );
}

Map<String, String> _currencyToRegion(Map<String, dynamic> json) {
  final map = <String, String>{};
  final supplemental = json['supplemental'] as Map<String, dynamic>?;
  final currencyData = supplemental?['currencyData'] as Map<String, dynamic>?;
  final region = currencyData?['region'] as Map<String, dynamic>?;
  if (region == null) {
    return map;
  }

  final regions = region.keys.toList()..sort();
  for (final regionCode in regions) {
    final entries = region[regionCode] as List<dynamic>?;
    if (entries == null) {
      continue;
    }
    for (final entry in entries) {
      if (entry is! Map) {
        continue;
      }
      for (final code in entry.keys) {
        if (code is String) {
          map.putIfAbsent(code, () => regionCode);
        }
      }
    }
  }
  return map;
}

Map<String, String> _likelySubtags(Map<String, dynamic> json) {
  final supplemental = json['supplemental'] as Map<String, dynamic>?;
  final subtags = supplemental?['likelySubtags'] as Map<String, dynamic>?;
  if (subtags == null) {
    return {};
  }
  return subtags.map((key, value) => MapEntry(key, value as String));
}

String _normalizeLocale(String locale) {
  final parts = locale.split('-');
  if (parts.length >= 3 && parts[1].length == 4) {
    return '${parts[0]}-${parts[2]}';
  }
  if (parts.length >= 3 && parts[2].length == 2) {
    return '${parts[0]}-${parts[2]}';
  }
  return locale;
}

Future<bool> _download(String url, String path) async {
  final file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  try {
    await fetch(url: url, saveToPath: path);
  } catch (_) {
    return false;
  }
  if (!file.existsSync() || file.lengthSync() == 0) {
    return false;
  }
  return true;
}

Map<String, dynamic>? _readJsonFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  final content = file.readAsStringSync();
  if (content.trim().isEmpty) {
    return null;
  }
  return jsonDecode(content) as Map<String, dynamic>;
}
