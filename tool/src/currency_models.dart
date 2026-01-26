class ExistingCurrency {
  final String code;
  final Map<String, dynamic> data;

  ExistingCurrency({
    required this.code,
    required this.data,
  });

  String? get symbol => data['symbol'] as String?;
  String? get pattern => data['pattern'] as String?;
  String? get groupSeparator => data['groupSeparator'] as String?;
  String? get decimalSeparator => data['decimalSeparator'] as String?;
  String? get varName => data['varName'] as String?;
  String? get country => data['country'] as String?;
  String? get unit => data['unit'] as String?;
  String? get name => data['name'] as String?;
  bool get isIso => data['iso'] as bool? ?? true;
  bool get isDeprecated => data['deprecated'] as bool? ?? false;
  String? get replacedBy => data['replacedBy'] as String?;
}

class IsoCurrency {
  final String code;
  final String name;
  final String country;
  final int decimalDigits;

  IsoCurrency({
    required this.code,
    required this.name,
    required this.country,
    required this.decimalDigits,
  });
}

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
  final bool isIso;
  final bool isDeprecated;
  final String? replacedBy;

  CurrencyDef({
    required this.code,
    required this.varName,
    required this.decimalDigits,
    required this.country,
    required this.unit,
    required this.name,
    required this.isIso,
    required this.isDeprecated,
    this.symbol,
    this.pattern,
    this.groupSeparator,
    this.decimalSeparator,
    this.replacedBy,
  });
}

class CurrencyDiff {
  final Set<String> added;
  final Set<String> removed;
  final Set<String> updated;

  CurrencyDiff(this.added, this.removed, this.updated);
}
