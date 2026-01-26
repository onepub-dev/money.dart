/// GENERATED CODE - DO NOT MODIFY BY HAND
library;
/*
 * Copyright (c) 2025 S. Brett Sutton
 * SPDX-License-Identifier: MIT
 *
 * This file is part of the “Money2” project.
 * See the LICENSE file in the project root for full license text.
 */

import 'currency.dart';

/// Provides a list of the most common currencies.
///
/// Example usage:
/// ```dart
/// final common = CommonCurrencies();
/// final usd = common.usd;
/// final price = Money.fromIntWithCurrency(1000, usd);
/// print(price); // $10.00
/// ```

class CommonCurrencies {
  static final _self = CommonCurrencies._();

  /// Cardano
  final ada = Currency.create(
    'ADA',
    6,
    isIso: false,
    country: 'Digital',
    unit: 'Cardano',
    name: 'Cardano'
  );

  /// UAE Dirham
  final aed = Currency.create(
    'AED',
    2,
    symbol: 'د.إ',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'United Arab Emirates',
    unit: 'Dirham',
    name: 'UAE Dirham'
  );

  /// Afghani
  final afn = Currency.create(
    'AFN',
    2,
    symbol: '؋',
    pattern: 'S #,##0.00',
    country: 'Afghanistan',
    unit: 'Afghani',
    name: 'Afghani'
  );

  /// Lek
  final all = Currency.create(
    'ALL',
    2,
    symbol: 'L',
    country: 'Albania',
    unit: 'Lek',
    name: 'Lek'
  );

  /// Armenian Dram
  final amd = Currency.create(
    'AMD',
    2,
    symbol: '֏',
    pattern: '#,##0.00S',
    country: 'Armenia',
    unit: 'Dram',
    name: 'Armenian Dram'
  );

  /// Netherlands Antillean Guilder
  final ang = Currency.create(
    'ANG',
    2,
    symbol: 'ƒ',
    pattern: 'S #,##0.00;S -#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    isIso: false,
    isDeprecated: true,
    replacedBy: 'XCG',
    country: 'Curaçao and Sint Maarten',
    unit: 'Guilder',
    name: 'Netherlands Antillean Guilder'
  );

  /// Kwanza
  final aoa = Currency.create(
    'AOA',
    2,
    symbol: 'Kz',
    pattern: '#,##0.00 S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Angola',
    unit: 'Kwanza',
    name: 'Kwanza'
  );

  /// Argentine Peso
  final ars = Currency.create(
    'ARS',
    2,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Argentina',
    unit: 'Peso',
    name: 'Argentine Peso'
  );

  /// Australian Dollar
  final aud = Currency.create(
    'AUD',
    2,
    country: 'Australian',
    unit: 'Dollar',
    name: 'Australian Dollar'
  );

  /// Aruban Florin
  final awg = Currency.create(
    'AWG',
    2,
    symbol: 'ƒ',
    pattern: 'S #,##0.00;S -#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Aruba',
    unit: 'Florin',
    name: 'Aruban Florin'
  );

  /// Azerbaijan Manat
  final azn = Currency.create(
    'AZN',
    2,
    symbol: '₼',
    country: 'Azerbaijan',
    unit: 'Manat',
    name: 'Azerbaijan Manat'
  );

  /// Convertible Mark
  final bam = Currency.create(
    'BAM',
    2,
    symbol: 'KM',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Bosnia and Herzegovina',
    unit: 'Mark',
    name: 'Convertible Mark'
  );

  /// Barbados Dollar
  final bbd = Currency.create(
    'BBD',
    2,
    country: 'Barbados',
    unit: 'Dollar',
    name: 'Barbados Dollar'
  );

  /// Bitcoin Cash
  final bch = Currency.create(
    'BCH',
    8,
    symbol: '₿',
    pattern: 'S#,##0.00000000',
    isIso: false,
    country: 'Digital',
    unit: 'Bitcoin Cash',
    name: 'Bitcoin Cash'
  );

  /// Taka
  final bdt = Currency.create(
    'BDT',
    2,
    symbol: '৳',
    country: 'Bangladesh',
    unit: 'Taka',
    name: 'Taka'
  );

  /// Bulgarian Lev
  final bgn = Currency.create(
    'BGN',
    2,
    symbol: 'лв',
    decimalSeparator: ',',
    isIso: false,
    isDeprecated: true,
    replacedBy: 'EUR',
    country: 'Bulgaria',
    unit: 'Lev',
    name: 'Bulgarian Lev'
  );

  /// Bahraini Dinar
  final bhd = Currency.create(
    'BHD',
    3,
    symbol: '.د.ب',
    pattern: '#,##0.000S',
    country: 'Bahrain',
    unit: 'Dinar',
    name: 'Bahraini Dinar'
  );

  /// Burundi Franc
  final bif = Currency.create(
    'BIF',
    0,
    symbol: 'FBu',
    pattern: 'S#,##0',
    country: 'Burundi',
    unit: 'Franc',
    name: 'Burundi Franc'
  );

  /// Bermudian Dollar
  final bmd = Currency.create(
    'BMD',
    2,
    country: 'Bermuda',
    unit: 'Dollar',
    name: 'Bermudian Dollar'
  );

  /// BNB
  final bnb = Currency.create(
    'BNB',
    18,
    isIso: false,
    country: 'Digital',
    unit: 'BNB',
    name: 'BNB'
  );

  /// Brunei Dollar
  final bnd = Currency.create(
    'BND',
    2,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Brunei',
    unit: 'Dollar',
    name: 'Brunei Dollar'
  );

  /// Boliviano
  final bob = Currency.create(
    'BOB',
    2,
    symbol: 'Bs.',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Bolivia',
    unit: 'Boliviano',
    name: 'Boliviano'
  );

  /// Mvdol
  final bov = Currency.create(
    'BOV',
    2,
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'BOLIVIA (PLURINATIONAL STATE OF)',
    unit: 'Mvdol',
    name: 'Mvdol'
  );

  /// Brazilian Real
  final brl = Currency.create(
    'BRL',
    2,
    symbol: r'R$',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Brazil',
    unit: 'Real',
    name: 'Brazilian Real'
  );

  /// Bahamian Dollar
  final bsd = Currency.create(
    'BSD',
    2,
    country: 'Bahamas',
    unit: 'Dollar',
    name: 'Bahamian Dollar'
  );

  /// Bitcoin
  final btc = Currency.create(
    'BTC',
    8,
    symbol: '₿',
    pattern: 'S#,##0.00000000',
    isIso: false,
    country: 'Digital',
    unit: 'Bitcoin',
    name: 'Bitcoin'
  );

  /// Ngultrum
  final btn = Currency.create(
    'BTN',
    2,
    symbol: 'Nu.',
    country: 'Bhutan',
    unit: 'Ngultrum',
    name: 'Ngultrum'
  );

  /// Pula
  final bwp = Currency.create(
    'BWP',
    2,
    symbol: 'P',
    country: 'Botswana',
    unit: 'Pula',
    name: 'Pula'
  );

  /// Belarusian Ruble
  final byn = Currency.create(
    'BYN',
    2,
    symbol: 'Br',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Belarus',
    unit: 'Ruble',
    name: 'Belarusian Ruble'
  );

  /// Belize Dollar
  final bzd = Currency.create(
    'BZD',
    2,
    country: 'Belize',
    unit: 'Dollar',
    name: 'Belize Dollar'
  );

  /// Canadian Dollar
  final cad = Currency.create(
    'CAD',
    2,
    country: 'Canada',
    unit: 'Dollar',
    name: 'Canadian Dollar'
  );

  /// Congolese Franc
  final cdf = Currency.create(
    'CDF',
    2,
    symbol: 'FC',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Congo (DRC)',
    unit: 'Franc',
    name: 'Congolese Franc'
  );

  /// WIR Euro
  final che = Currency.create(
    'CHE',
    2,
    pattern: 'S #,##0.00;S-#,##0.00',
    groupSeparator: "'",
    country: 'SWITZERLAND',
    unit: 'WIR Euro',
    name: 'WIR Euro'
  );

  /// Swiss Franc
  final chf = Currency.create(
    'CHF',
    2,
    symbol: 'fr',
    pattern: 'S #,##0.00;S-#,##0.00',
    groupSeparator: "'",
    country: 'Switzerland',
    unit: 'Franc',
    name: 'Swiss Franc'
  );

  /// WIR Franc
  final chw = Currency.create(
    'CHW',
    2,
    pattern: 'S #,##0.00;S-#,##0.00',
    groupSeparator: "'",
    country: 'SWITZERLAND',
    unit: 'WIR Franc',
    name: 'WIR Franc'
  );

  /// Unidad de Fomento
  final clf = Currency.create(
    'CLF',
    4,
    pattern: 'S#,##0.00;S-#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'CHILE',
    unit: 'Unidad de Fomento',
    name: 'Unidad de Fomento'
  );

  /// Chilean Peso
  final clp = Currency.create(
    'CLP',
    0,
    pattern: 'S#,##0',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Chile',
    unit: 'Peso',
    name: 'Chilean Peso'
  );

  /// Yuan Renminbi
  final cny = Currency.create(
    'CNY',
    2,
    symbol: '¥',
    country: 'China',
    unit: 'Renminbi',
    name: 'Yuan Renminbi'
  );

  /// Colombian Peso
  final cop = Currency.create(
    'COP',
    2,
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Colombia',
    unit: 'Peso',
    name: 'Colombian Peso'
  );

  /// Unidad de Valor Real
  final cou = Currency.create(
    'COU',
    2,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'COLOMBIA',
    unit: 'Unidad de Valor Real',
    name: 'Unidad de Valor Real'
  );

  /// Costa Rican Colon
  final crc = Currency.create(
    'CRC',
    2,
    symbol: '₡',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Costa Rica',
    unit: 'Colón',
    name: 'Costa Rican Colon'
  );

  /// Cuban Peso
  final cup = Currency.create(
    'CUP',
    2,
    country: 'Cuba',
    unit: 'Peso',
    name: 'Cuban Peso'
  );

  /// Cabo Verde Escudo
  final cve = Currency.create(
    'CVE',
    2,
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Cape Verde',
    unit: 'Escudo',
    name: 'Cabo Verde Escudo'
  );

  /// Czech Koruna
  final czk = Currency.create(
    'CZK',
    2,
    symbol: 'Kč',
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Czech',
    unit: 'Koruna',
    name: 'Czech Koruna'
  );

  /// Djibouti Franc
  final djf = Currency.create(
    'DJF',
    0,
    symbol: 'Fdj',
    pattern: 'S#,##0',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Djibouti',
    unit: 'Franc',
    name: 'Djibouti Franc'
  );

  /// Danish Krone
  final dkk = Currency.create(
    'DKK',
    2,
    symbol: 'kr',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Denmark',
    unit: 'Krone',
    name: 'Danish Krone'
  );

  /// Dogecoin
  final doge = Currency.create(
    'DOGE',
    8,
    isIso: false,
    country: 'Digital',
    unit: 'Dogecoin',
    name: 'Dogecoin'
  );

  /// Dominican Peso
  final dop = Currency.create(
    'DOP',
    2,
    country: 'Dominican Republic',
    unit: 'Peso',
    name: 'Dominican Peso'
  );

  /// Algerian Dinar
  final dzd = Currency.create(
    'DZD',
    2,
    symbol: 'د.ج',
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Algeria',
    unit: 'Dinar',
    name: 'Algerian Dinar'
  );

  /// Egyptian Pound
  final egp = Currency.create(
    'EGP',
    2,
    symbol: '£',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Egypt',
    unit: 'Pound',
    name: 'Egyptian Pound'
  );

  /// Nakfa
  final ern = Currency.create(
    'ERN',
    2,
    symbol: 'Nfk',
    country: 'Eritrea',
    unit: 'Nakfa',
    name: 'Nakfa'
  );

  /// Ethiopian Birr
  final etb = Currency.create(
    'ETB',
    2,
    symbol: 'Br',
    country: 'Ethiopia',
    unit: 'Birr',
    name: 'Ethiopian Birr'
  );

  /// Ethereum
  final eth = Currency.create(
    'ETH',
    18,
    isIso: false,
    country: 'Digital',
    unit: 'Ether',
    name: 'Ethereum'
  );

  /// Euro
  final euro = Currency.create(
    'EUR',
    2,
    symbol: '€',
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'European Union',
    unit: 'Euro',
    name: 'Euro'
  );

  /// Fiji Dollar
  final fjd = Currency.create(
    'FJD',
    2,
    country: 'Fiji',
    unit: 'Dollar',
    name: 'Fiji Dollar'
  );

  /// Falkland Islands Pound
  final fkp = Currency.create(
    'FKP',
    2,
    symbol: '£',
    country: 'Falkland Islands',
    unit: 'Pound',
    name: 'Falkland Islands Pound'
  );

  /// Pound Sterling
  final gbp = Currency.create(
    'GBP',
    2,
    symbol: '£',
    country: 'Britan',
    unit: 'Pound Sterling',
    name: 'Pound Sterling'
  );

  /// Lari
  final gel = Currency.create(
    'GEL',
    2,
    symbol: '₾',
    decimalSeparator: ',',
    country: 'Georgia',
    unit: 'Lari',
    name: 'Lari'
  );

  /// Ghana Cedi
  final ghs = Currency.create(
    'GHS',
    2,
    symbol: '₵',
    country: 'Ghana',
    unit: 'Cedi',
    name: 'Ghana Cedi'
  );

  /// Gibraltar Pound
  final gip = Currency.create(
    'GIP',
    2,
    symbol: '£',
    country: 'Gibraltar',
    unit: 'Pound',
    name: 'Gibraltar Pound'
  );

  /// Dalasi
  final gmd = Currency.create(
    'GMD',
    2,
    symbol: 'D',
    country: 'Gambia',
    unit: 'Dalasi',
    name: 'Dalasi'
  );

  /// Guinean Franc
  final gnf = Currency.create(
    'GNF',
    0,
    symbol: 'FG',
    pattern: 'S#,##0',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Guinea',
    unit: 'Franc',
    name: 'Guinean Franc'
  );

  /// Quetzal
  final gtq = Currency.create(
    'GTQ',
    2,
    symbol: 'Q',
    country: 'Guatemala',
    unit: 'Quetzal',
    name: 'Quetzal'
  );

  /// Guyana Dollar
  final gyd = Currency.create(
    'GYD',
    2,
    country: 'Guyana',
    unit: 'Dollar',
    name: 'Guyana Dollar'
  );

  /// Hong Kong Dollar
  final hkd = Currency.create(
    'HKD',
    2,
    country: 'Hong Kong',
    unit: 'Dollar',
    name: 'Hong Kong Dollar'
  );

  /// Lempira
  final hnl = Currency.create(
    'HNL',
    2,
    symbol: 'L',
    country: 'Honduras',
    unit: 'Lempira',
    name: 'Lempira'
  );

  /// Gourde
  final htg = Currency.create(
    'HTG',
    2,
    symbol: 'G',
    country: 'Haiti',
    unit: 'Gourde',
    name: 'Gourde'
  );

  /// Forint
  final huf = Currency.create(
    'HUF',
    2,
    symbol: 'Ft',
    pattern: 'S#,##0',
    country: 'Hungary',
    unit: 'Forint',
    name: 'Forint'
  );

  /// Rupiah
  final idr = Currency.create(
    'IDR',
    2,
    symbol: 'Rp',
    country: 'Indonesia',
    unit: 'Rupiah',
    name: 'Rupiah'
  );

  /// New Israeli Sheqel
  final ils = Currency.create(
    'ILS',
    2,
    symbol: '₪',
    country: 'Israel',
    unit: 'Shekel',
    name: 'New Israeli Sheqel'
  );

  /// Indian Rupee
  final inr = Currency.create(
    'INR',
    2,
    symbol: '₹',
    pattern: 'S##,###.00',
    country: 'Indian',
    unit: 'Rupee',
    name: 'Indian Rupee'
  );

  /// Iraqi Dinar
  final iqd = Currency.create(
    'IQD',
    3,
    symbol: 'ع.د',
    pattern: '#,##0.000S',
    country: 'Iraq',
    unit: 'Dinar',
    name: 'Iraqi Dinar'
  );

  /// Iranian Rial
  final irr = Currency.create(
    'IRR',
    2,
    symbol: '﷼',
    country: 'Iran',
    unit: 'Rial',
    name: 'Iranian Rial'
  );

  /// Iceland Krona
  final isk = Currency.create(
    'ISK',
    0,
    symbol: 'kr',
    pattern: 'S#,##0',
    country: 'Iceland',
    unit: 'Krona',
    name: 'Iceland Krona'
  );

  /// Jamaican Dollar
  final jmd = Currency.create(
    'JMD',
    2,
    country: 'Jamaica',
    unit: 'Dollar',
    name: 'Jamaican Dollar'
  );

  /// Jordanian Dinar
  final jod = Currency.create(
    'JOD',
    3,
    symbol: 'د.ا',
    pattern: '#,##0.000S',
    country: 'Jordan',
    unit: 'Dinar',
    name: 'Jordanian Dinar'
  );

  /// Yen
  final jpy = Currency.create(
    'JPY',
    0,
    symbol: '¥',
    pattern: 'S#,##0',
    country: 'Japanese',
    unit: 'Yen',
    name: 'Yen'
  );

  /// Kenyan Shilling
  final kes = Currency.create(
    'KES',
    2,
    symbol: 'KSh',
    pattern: 'S #,##0.00',
    country: 'Kenya',
    unit: 'Shilling',
    name: 'Kenyan Shilling'
  );

  /// Som
  final kgs = Currency.create(
    'KGS',
    2,
    symbol: 'с',
    country: 'Kyrgyzstan',
    unit: 'Som',
    name: 'Som'
  );

  /// Riel
  final khr = Currency.create(
    'KHR',
    2,
    symbol: '៛',
    country: 'Cambodia',
    unit: 'Riel',
    name: 'Riel'
  );

  /// Comorian Franc
  final kmf = Currency.create(
    'KMF',
    0,
    symbol: 'CF',
    pattern: 'S#,##0',
    country: 'Comoros',
    unit: 'Franc',
    name: 'Comorian Franc'
  );

  /// North Korean Won
  final kpw = Currency.create(
    'KPW',
    2,
    symbol: '₩',
    country: 'North Korea',
    unit: 'Won',
    name: 'North Korean Won'
  );

  /// Won
  final krw = Currency.create(
    'KRW',
    0,
    symbol: '₩',
    pattern: 'S#,##0',
    country: 'South Korean',
    unit: 'Won',
    name: 'Won'
  );

  /// Kuwaiti Dinar
  final kwd = Currency.create(
    'KWD',
    3,
    symbol: 'د.ك',
    pattern: '#,##0.000S',
    country: 'Kuwait',
    unit: 'Dinar',
    name: 'Kuwaiti Dinar'
  );

  /// Cayman Islands Dollar
  final kyd = Currency.create(
    'KYD',
    2,
    country: 'Cayman Islands',
    unit: 'Dollar',
    name: 'Cayman Islands Dollar'
  );

  /// Tenge
  final kzt = Currency.create(
    'KZT',
    2,
    symbol: '₸',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Kazakhstan',
    unit: 'Tenge',
    name: 'Tenge'
  );

  /// Lao Kip
  final lak = Currency.create(
    'LAK',
    2,
    symbol: '₭',
    country: 'Laos',
    unit: 'Kip',
    name: 'Lao Kip'
  );

  /// Lebanese Pound
  final lbp = Currency.create(
    'LBP',
    2,
    symbol: 'ل.ل',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Lebanon',
    unit: 'Pound',
    name: 'Lebanese Pound'
  );

  /// Sri Lanka Rupee
  final lkr = Currency.create(
    'LKR',
    2,
    symbol: 'Rs',
    country: 'Sri Lanka',
    unit: 'Rupee',
    name: 'Sri Lanka Rupee'
  );

  /// Liberian Dollar
  final lrd = Currency.create(
    'LRD',
    2,
    country: 'Liberia',
    unit: 'Dollar',
    name: 'Liberian Dollar'
  );

  /// Loti
  final lsl = Currency.create(
    'LSL',
    2,
    symbol: 'L',
    country: 'Lesotho',
    unit: 'Loti',
    name: 'Loti'
  );

  /// Litecoin
  final ltc = Currency.create(
    'LTC',
    8,
    isIso: false,
    country: 'Digital',
    unit: 'Litecoin',
    name: 'Litecoin'
  );

  /// Libyan Dinar
  final lyd = Currency.create(
    'LYD',
    3,
    symbol: 'ل.د',
    pattern: '#,##0.000S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Libya',
    unit: 'Dinar',
    name: 'Libyan Dinar'
  );

  /// Moroccan Dirham
  final mad = Currency.create(
    'MAD',
    2,
    symbol: 'د.م.',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    decimalSeparator: ',',
    country: 'Morocco',
    unit: 'Dirham',
    name: 'Moroccan Dirham'
  );

  /// Moldovan Leu
  final mdl = Currency.create(
    'MDL',
    2,
    symbol: 'L',
    pattern: '#,##0.00 S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Moldova',
    unit: 'Leu',
    name: 'Moldovan Leu'
  );

  /// Malagasy Ariary
  final mga = Currency.create(
    'MGA',
    2,
    symbol: 'Ar',
    country: 'Madagascar',
    unit: 'Ariary',
    name: 'Malagasy Ariary'
  );

  /// Denar
  final mkd = Currency.create(
    'MKD',
    2,
    symbol: 'ден',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'North Macedonia',
    unit: 'Denar',
    name: 'Denar'
  );

  /// Kyat
  final mmk = Currency.create(
    'MMK',
    2,
    symbol: 'K',
    country: 'Myanmar (Burma)',
    unit: 'Kyat',
    name: 'Kyat'
  );

  /// Tugrik
  final mnt = Currency.create(
    'MNT',
    2,
    symbol: '₮',
    country: 'Mongolia',
    unit: 'Tugrik',
    name: 'Tugrik'
  );

  /// Pataca
  final mop = Currency.create(
    'MOP',
    2,
    country: 'Macao',
    unit: 'Pataca',
    name: 'Pataca'
  );

  /// Ouguiya
  final mru = Currency.create(
    'MRU',
    2,
    symbol: 'UM',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Mauritania',
    unit: 'Ouguiya',
    name: 'Ouguiya'
  );

  /// Mauritius Rupee
  final mur = Currency.create(
    'MUR',
    2,
    symbol: '₨',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Mauritius',
    unit: 'Rupee',
    name: 'Mauritius Rupee'
  );

  /// Rufiyaa
  final mvr = Currency.create(
    'MVR',
    2,
    symbol: 'ރ.',
    country: 'Maldives',
    unit: 'Rufiyaa',
    name: 'Rufiyaa'
  );

  /// Malawi Kwacha
  final mwk = Currency.create(
    'MWK',
    2,
    symbol: 'MK',
    country: 'Malawi',
    unit: 'Kwacha',
    name: 'Malawi Kwacha'
  );

  /// Mexican Peso
  final mxn = Currency.create(
    'MXN',
    2,
    country: 'Mexican',
    unit: 'Peso',
    name: 'Mexican Peso'
  );

  /// Mexican Unidad de Inversion (UDI)
  final mxv = Currency.create(
    'MXV',
    2,
    country: 'MEXICO',
    unit: 'Mexican Unidad de Inversion (UDI)',
    name: 'Mexican Unidad de Inversion (UDI)'
  );

  /// Malaysian Ringgit
  final myr = Currency.create(
    'MYR',
    2,
    symbol: 'RM',
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Malaysia',
    unit: 'Ringgit',
    name: 'Malaysian Ringgit'
  );

  /// Mozambique Metical
  final mzn = Currency.create(
    'MZN',
    2,
    symbol: 'MT',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Mozambique',
    unit: 'Metical',
    name: 'Mozambique Metical'
  );

  /// Namibia Dollar
  final nad = Currency.create(
    'NAD',
    2,
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Namibia',
    unit: 'Dollar',
    name: 'Namibia Dollar'
  );

  /// Naira
  final ngn = Currency.create(
    'NGN',
    2,
    symbol: '₦',
    country: 'Nigerian',
    unit: 'Naira',
    name: 'Naira'
  );

  /// Cordoba Oro
  final nio = Currency.create(
    'NIO',
    2,
    country: 'Nicaragua',
    unit: 'Córdoba',
    name: 'Cordoba Oro'
  );

  /// Norwegian Krone
  final nok = Currency.create(
    'NOK',
    2,
    symbol: 'kr',
    country: 'Norwegian',
    unit: 'Krone',
    name: 'Norwegian Krone'
  );

  /// Nepalese Rupee
  final npr = Currency.create(
    'NPR',
    2,
    symbol: 'रू',
    country: 'Nepal',
    unit: 'Rupee',
    name: 'Nepalese Rupee'
  );

  /// New Zealand Dollar
  final nzd = Currency.create(
    'NZD',
    2,
    country: 'New Zealand',
    unit: 'Dollar',
    name: 'New Zealand Dollar'
  );

  /// Rial Omani
  final omr = Currency.create(
    'OMR',
    3,
    symbol: 'ر.ع.',
    pattern: '#,##0.000S',
    country: 'Oman',
    unit: 'Rial',
    name: 'Rial Omani'
  );

  /// Balboa
  final pab = Currency.create(
    'PAB',
    2,
    symbol: 'B/.',
    country: 'Panama',
    unit: 'Balboa',
    name: 'Balboa'
  );

  /// Sol
  final pen = Currency.create(
    'PEN',
    2,
    symbol: 'S/.',
    pattern: 'S #,##0.00',
    country: 'Peru',
    unit: 'Sol',
    name: 'Sol'
  );

  /// Kina
  final pgk = Currency.create(
    'PGK',
    2,
    symbol: 'K',
    country: 'Papua New Guinea',
    unit: 'Kina',
    name: 'Kina'
  );

  /// Philippine Peso
  final php = Currency.create(
    'PHP',
    2,
    symbol: '₱',
    country: 'Philippines',
    unit: 'Peso',
    name: 'Philippine Peso'
  );

  /// Pakistan Rupee
  final pkr = Currency.create(
    'PKR',
    2,
    symbol: '₨',
    country: 'Pakistan',
    unit: 'Rupee',
    name: 'Pakistan Rupee'
  );

  /// Zloty
  final pln = Currency.create(
    'PLN',
    2,
    symbol: 'zł',
    pattern: '#,##0.00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Polish',
    unit: 'Zloty',
    name: 'Zloty'
  );

  /// Guarani
  final pyg = Currency.create(
    'PYG',
    0,
    symbol: '₲',
    pattern: 'S#,##0',
    groupSeparator: '.',
    country: 'Paraguay',
    unit: 'Guarani',
    name: 'Guarani'
  );

  /// Qatari Rial
  final qar = Currency.create(
    'QAR',
    2,
    symbol: 'ر.ق',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Qatar',
    unit: 'Riyal',
    name: 'Qatari Rial'
  );

  /// Romanian Leu
  final ron = Currency.create(
    'RON',
    2,
    symbol: 'lei',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Romania',
    unit: 'Leu',
    name: 'Romanian Leu'
  );

  /// Serbian Dinar
  final rsd = Currency.create(
    'RSD',
    2,
    symbol: 'дин',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Serbia',
    unit: 'Dinar',
    name: 'Serbian Dinar'
  );

  /// Russian Ruble
  final rub = Currency.create(
    'RUB',
    2,
    symbol: '₽',
    country: 'Russia',
    unit: 'Ruble',
    name: 'Russian Ruble'
  );

  /// Rwanda Franc
  final rwf = Currency.create(
    'RWF',
    0,
    symbol: 'RF',
    pattern: 'S#,##0',
    country: 'Rwanda',
    unit: 'Franc',
    name: 'Rwanda Franc'
  );

  /// Saudi Riyal
  final sar = Currency.create(
    'SAR',
    2,
    symbol: 'ر.س',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Saudi Arabia',
    unit: 'Riyal',
    name: 'Saudi Riyal'
  );

  /// Solomon Islands Dollar
  final sbd = Currency.create(
    'SBD',
    2,
    country: 'Solomon Islands',
    unit: 'Dollar',
    name: 'Solomon Islands Dollar'
  );

  /// Seychelles Rupee
  final scr = Currency.create(
    'SCR',
    2,
    symbol: '₨',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Seychelles',
    unit: 'Rupee',
    name: 'Seychelles Rupee'
  );

  /// Sudanese Pound
  final sdg = Currency.create(
    'SDG',
    2,
    symbol: '£',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Sudan',
    unit: 'Pound',
    name: 'Sudanese Pound'
  );

  /// Swedish Krona
  final sek = Currency.create(
    'SEK',
    2,
    symbol: 'kr',
    decimalSeparator: ',',
    country: 'Sweden',
    unit: 'Krona',
    name: 'Swedish Krona'
  );

  /// Singapore Dollar
  final sgd = Currency.create(
    'SGD',
    2,
    country: 'Singapore',
    unit: 'Dollar',
    name: 'Singapore Dollar'
  );

  /// Saint Helena Pound
  final shp = Currency.create(
    'SHP',
    2,
    symbol: '£',
    country: 'Saint Helena',
    unit: 'Pound',
    name: 'Saint Helena Pound'
  );

  /// Leone
  final sle = Currency.create(
    'SLE',
    2,
    symbol: 'Le',
    country: 'Sierra Leone',
    unit: 'Leone',
    name: 'Leone'
  );

  /// Solana
  final sol = Currency.create(
    'SOL',
    9,
    isIso: false,
    country: 'Digital',
    unit: 'Solana',
    name: 'Solana'
  );

  /// Somali Shilling
  final sos = Currency.create(
    'SOS',
    2,
    symbol: 'Sh',
    country: 'Somalia',
    unit: 'Shilling',
    name: 'Somali Shilling'
  );

  /// Surinam Dollar
  final srd = Currency.create(
    'SRD',
    2,
    pattern: 'S #,##0.00;S -#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Suriname',
    unit: 'Dollar',
    name: 'Surinam Dollar'
  );

  /// South Sudanese Pound
  final ssp = Currency.create(
    'SSP',
    2,
    symbol: '£',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'South Sudan',
    unit: 'Pound',
    name: 'South Sudanese Pound'
  );

  /// Dobra
  final stn = Currency.create(
    'STN',
    2,
    symbol: 'Db',
    pattern: '#,##0.00 S',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'São Tomé and Príncipe',
    unit: 'Dobra',
    name: 'Dobra'
  );

  /// El Salvador Colon
  final svc = Currency.create(
    'SVC',
    2,
    country: 'EL SALVADOR',
    unit: 'El Salvador Colon',
    name: 'El Salvador Colon'
  );

  /// Syrian Pound
  final syp = Currency.create(
    'SYP',
    2,
    symbol: '£',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Syria',
    unit: 'Pound',
    name: 'Syrian Pound'
  );

  /// Lilangeni
  final szl = Currency.create(
    'SZL',
    2,
    symbol: 'E',
    country: 'Eswatini',
    unit: 'Lilangeni',
    name: 'Lilangeni'
  );

  /// Baht
  final thb = Currency.create(
    'THB',
    2,
    symbol: '฿',
    country: 'Thailand',
    unit: 'Baht',
    name: 'Baht'
  );

  /// Somoni
  final tjs = Currency.create(
    'TJS',
    2,
    symbol: 'ЅМ',
    country: 'Tajikistan',
    unit: 'Somoni',
    name: 'Somoni'
  );

  /// Turkmenistan New Manat
  final tmt = Currency.create(
    'TMT',
    2,
    symbol: 'm',
    country: 'Turkmenistan',
    unit: 'Manat',
    name: 'Turkmenistan New Manat'
  );

  /// Tunisian Dinar
  final tnd = Currency.create(
    'TND',
    3,
    symbol: 'د.ت',
    pattern: '#,##0.000S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Tunisia',
    unit: 'Dinar',
    name: 'Tunisian Dinar'
  );

  /// Pa’anga
  final top = Currency.create(
    'TOP',
    2,
    country: 'Tonga',
    unit: 'Paʻanga',
    name: 'Pa’anga'
  );

  /// Turkish Lira
  final ltry = Currency.create(
    'TRY',
    2,
    symbol: '₺',
    country: 'Turkish',
    unit: 'Lira',
    name: 'Turkish Lira'
  );

  /// Trinidad and Tobago Dollar
  final ttd = Currency.create(
    'TTD',
    2,
    country: 'Trinidad and Tobago',
    unit: 'Dollar',
    name: 'Trinidad and Tobago Dollar'
  );

  /// New Taiwan Dollar
  final twd = Currency.create(
    'TWD',
    2,
    pattern: 'S#,##0',
    country: 'New Taiwan',
    unit: 'Dollar',
    name: 'New Taiwan Dollar'
  );

  /// Tanzanian Shilling
  final tzs = Currency.create(
    'TZS',
    2,
    symbol: 'Sh',
    country: 'Tanzania',
    unit: 'Shilling',
    name: 'Tanzanian Shilling'
  );

  /// Hryvnia
  final uah = Currency.create(
    'UAH',
    2,
    symbol: '₴',
    country: 'Ukraine',
    unit: 'Hryvnia',
    name: 'Hryvnia'
  );

  /// Uganda Shilling
  final ugx = Currency.create(
    'UGX',
    0,
    symbol: 'USh',
    pattern: 'S#,##0',
    country: 'Uganda',
    unit: 'Shilling',
    name: 'Uganda Shilling'
  );

  /// US Dollar
  final usd = Currency.create(
    'USD',
    2,
    country: 'United States of America',
    unit: 'Dollar',
    name: 'US Dollar'
  );

  /// USD Coin
  final usdc = Currency.create(
    'USDC',
    6,
    isIso: false,
    country: 'Digital',
    unit: 'USD Coin',
    name: 'USD Coin'
  );

  /// Tether
  final usdt = Currency.create(
    'USDT',
    6,
    isIso: false,
    country: 'Digital',
    unit: 'Tether',
    name: 'Tether'
  );

  /// US Dollar (Next day)
  final usn = Currency.create(
    'USN',
    2,
    country: 'UNITED STATES OF AMERICA (THE)',
    unit: 'US Dollar (Next day)',
    name: 'US Dollar (Next day)'
  );

  /// Uruguay Peso en Unidades Indexadas (UI)
  final uyi = Currency.create(
    'UYI',
    0,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'URUGUAY',
    unit: 'Uruguay Peso en Unidades Indexadas (UI)',
    name: 'Uruguay Peso en Unidades Indexadas (UI)'
  );

  /// Peso Uruguayo
  final uyu = Currency.create(
    'UYU',
    2,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Uruguay',
    unit: 'Peso',
    name: 'Peso Uruguayo'
  );

  /// Unidad Previsional
  final uyw = Currency.create(
    'UYW',
    4,
    pattern: 'S #,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'URUGUAY',
    unit: 'Unidad Previsional',
    name: 'Unidad Previsional'
  );

  /// Uzbekistan Sum
  final uzs = Currency.create(
    'UZS',
    2,
    symbol: 'soʻm',
    country: 'Uzbekistan',
    unit: 'Som',
    name: 'Uzbekistan Sum'
  );

  /// Bolívar Soberano
  final ved = Currency.create(
    'VED',
    2,
    pattern: 'S#,##0.00;S-#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'VENEZUELA (BOLIVARIAN REPUBLIC OF)',
    unit: 'Bolívar Soberano',
    name: 'Bolívar Soberano'
  );

  /// Bolívar Soberano
  final ves = Currency.create(
    'VES',
    2,
    symbol: 'Bs',
    pattern: 'S#,##0.00;S-#,##0.00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Venezuela',
    unit: 'Bolívar',
    name: 'Bolívar Soberano'
  );

  /// Dong
  final vnd = Currency.create(
    'VND',
    0,
    symbol: '₫',
    pattern: 'S#,##0',
    groupSeparator: '.',
    country: 'Vietnam',
    unit: 'Dong',
    name: 'Dong'
  );

  /// Vatu
  final vuv = Currency.create(
    'VUV',
    0,
    symbol: 'Vt',
    pattern: 'S#,##0',
    country: 'Vanuatu',
    unit: 'Vatu',
    name: 'Vatu'
  );

  /// Tala
  final wst = Currency.create(
    'WST',
    2,
    country: 'Samoa',
    unit: 'Tala',
    name: 'Tala'
  );

  /// Arab Accounting Dinar
  final xad = Currency.create(
    'XAD',
    2,
    country: 'ARAB MONETARY FUND',
    unit: 'Arab Accounting Dinar',
    name: 'Arab Accounting Dinar'
  );

  /// CFA Franc BEAC
  final xaf = Currency.create(
    'XAF',
    0,
    symbol: 'FCFA',
    pattern: 'S#,##0',
    country: 'Central African States',
    unit: 'Franc',
    name: 'CFA Franc BEAC'
  );

  /// Silver
  final xag = Currency.create(
    'XAG',
    0,
    country: 'ZZ11_Silver',
    unit: 'Silver',
    name: 'Silver'
  );

  /// Gold
  final xau = Currency.create(
    'XAU',
    0,
    country: 'ZZ08_Gold',
    unit: 'Gold',
    name: 'Gold'
  );

  /// Bond Markets Unit European Composite Unit (EURCO)
  final xba = Currency.create(
    'XBA',
    0,
    country: 'ZZ01_Bond Markets Unit European_EURCO',
    unit: 'Bond Markets Unit European Composite Unit (EURCO)',
    name: 'Bond Markets Unit European Composite Unit (EURCO)'
  );

  /// Bond Markets Unit European Monetary Unit (E.M.U.-6)
  final xbb = Currency.create(
    'XBB',
    0,
    country: 'ZZ02_Bond Markets Unit European_EMU-6',
    unit: 'Bond Markets Unit European Monetary Unit (E.M.U.-6)',
    name: 'Bond Markets Unit European Monetary Unit (E.M.U.-6)'
  );

  /// Bond Markets Unit European Unit of Account 9 (E.U.A.-9)
  final xbc = Currency.create(
    'XBC',
    0,
    country: 'ZZ03_Bond Markets Unit European_EUA-9',
    unit: 'Bond Markets Unit European Unit of Account 9 (E.U.A.-9)',
    name: 'Bond Markets Unit European Unit of Account 9 (E.U.A.-9)'
  );

  /// Bond Markets Unit European Unit of Account 17 (E.U.A.-17)
  final xbd = Currency.create(
    'XBD',
    0,
    country: 'ZZ04_Bond Markets Unit European_EUA-17',
    unit: 'Bond Markets Unit European Unit of Account 17 (E.U.A.-17)',
    name: 'Bond Markets Unit European Unit of Account 17 (E.U.A.-17)'
  );

  /// East Caribbean Dollar
  final xcd = Currency.create(
    'XCD',
    2,
    country: 'East Caribbean',
    unit: 'Dollar',
    name: 'East Caribbean Dollar'
  );

  /// Caribbean Guilder
  final xcg = Currency.create(
    'XCG',
    2,
    country: 'Multiple',
    unit: 'Caribbean Guilder',
    name: 'Caribbean Guilder'
  );

  /// SDR (Special Drawing Right)
  final xdr = Currency.create(
    'XDR',
    0,
    country: 'INTERNATIONAL MONETARY FUND (IMF)',
    unit: 'SDR (Special Drawing Right)',
    name: 'SDR (Special Drawing Right)'
  );

  /// CFA Franc BCEAO
  final xof = Currency.create(
    'XOF',
    0,
    symbol: 'CFA',
    pattern: 'S#,##0',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'West African States',
    unit: 'Franc',
    name: 'CFA Franc BCEAO'
  );

  /// Palladium
  final xpd = Currency.create(
    'XPD',
    0,
    country: 'ZZ09_Palladium',
    unit: 'Palladium',
    name: 'Palladium'
  );

  /// CFP Franc
  final xpf = Currency.create(
    'XPF',
    0,
    symbol: 'F',
    pattern: 'S#,##0',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'French Polynesia, New Caledonia, Wallis and Futuna',
    unit: 'Franc',
    name: 'CFP Franc'
  );

  /// Platinum
  final xpt = Currency.create(
    'XPT',
    0,
    country: 'ZZ10_Platinum',
    unit: 'Platinum',
    name: 'Platinum'
  );

  /// XRP
  final xrp = Currency.create(
    'XRP',
    6,
    isIso: false,
    country: 'Digital',
    unit: 'XRP',
    name: 'XRP'
  );

  /// Sucre
  final xsu = Currency.create(
    'XSU',
    0,
    country: 'SISTEMA UNITARIO DE COMPENSACION REGIONAL DE PAGOS "SUCRE"',
    unit: 'Sucre',
    name: 'Sucre'
  );

  /// Codes specifically reserved for testing purposes
  final xts = Currency.create(
    'XTS',
    0,
    country: 'ZZ06_Testing_Code',
    unit: 'Codes specifically reserved for testing purposes',
    name: 'Codes specifically reserved for testing purposes'
  );

  /// ADB Unit of Account
  final xua = Currency.create(
    'XUA',
    0,
    country: 'MEMBER COUNTRIES OF THE AFRICAN DEVELOPMENT BANK GROUP',
    unit: 'ADB Unit of Account',
    name: 'ADB Unit of Account'
  );

  /// The codes assigned for transactions where no currency is involved
  final xxx = Currency.create(
    'XXX',
    0,
    country: 'ZZ07_No_Currency',
    unit: 'The codes assigned for transactions where no currency is involved',
    name: 'The codes assigned for transactions where no currency is involved'
  );

  /// Yemeni Rial
  final yer = Currency.create(
    'YER',
    2,
    symbol: '﷼',
    pattern: '‏#,##0.00 S;‏-#,##0.00 S',
    country: 'Yemen',
    unit: 'Rial',
    name: 'Yemeni Rial'
  );

  /// Rand
  final zar = Currency.create(
    'ZAR',
    2,
    symbol: 'R',
    country: 'South African',
    unit: 'Rand',
    name: 'Rand'
  );

  /// Zambian Kwacha
  final zmw = Currency.create(
    'ZMW',
    2,
    symbol: 'ZK',
    country: 'Zambia',
    unit: 'Kwacha',
    name: 'Zambian Kwacha'
  );

  /// Zimbabwe Gold
  final zwg = Currency.create(
    'ZWG',
    2,
    country: 'ZIMBABWE',
    unit: 'Zimbabwe Gold',
    name: 'Zimbabwe Gold'
  );

  factory CommonCurrencies() => _self;
  CommonCurrencies._();

  List<Currency> asList() => [
    ada,
    aed,
    afn,
    all,
    amd,
    ang,
    aoa,
    ars,
    aud,
    awg,
    azn,
    bam,
    bbd,
    bch,
    bdt,
    bgn,
    bhd,
    bif,
    bmd,
    bnb,
    bnd,
    bob,
    bov,
    brl,
    bsd,
    btc,
    btn,
    bwp,
    byn,
    bzd,
    cad,
    cdf,
    che,
    chf,
    chw,
    clf,
    clp,
    cny,
    cop,
    cou,
    crc,
    cup,
    cve,
    czk,
    djf,
    dkk,
    doge,
    dop,
    dzd,
    egp,
    ern,
    etb,
    eth,
    euro,
    fjd,
    fkp,
    gbp,
    gel,
    ghs,
    gip,
    gmd,
    gnf,
    gtq,
    gyd,
    hkd,
    hnl,
    htg,
    huf,
    idr,
    ils,
    inr,
    iqd,
    irr,
    isk,
    jmd,
    jod,
    jpy,
    kes,
    kgs,
    khr,
    kmf,
    kpw,
    krw,
    kwd,
    kyd,
    kzt,
    lak,
    lbp,
    lkr,
    lrd,
    lsl,
    ltc,
    lyd,
    mad,
    mdl,
    mga,
    mkd,
    mmk,
    mnt,
    mop,
    mru,
    mur,
    mvr,
    mwk,
    mxn,
    mxv,
    myr,
    mzn,
    nad,
    ngn,
    nio,
    nok,
    npr,
    nzd,
    omr,
    pab,
    pen,
    pgk,
    php,
    pkr,
    pln,
    pyg,
    qar,
    ron,
    rsd,
    rub,
    rwf,
    sar,
    sbd,
    scr,
    sdg,
    sek,
    sgd,
    shp,
    sle,
    sol,
    sos,
    srd,
    ssp,
    stn,
    svc,
    syp,
    szl,
    thb,
    tjs,
    tmt,
    tnd,
    top,
    ltry,
    ttd,
    twd,
    tzs,
    uah,
    ugx,
    usd,
    usdc,
    usdt,
    usn,
    uyi,
    uyu,
    uyw,
    uzs,
    ved,
    ves,
    vnd,
    vuv,
    wst,
    xad,
    xaf,
    xag,
    xau,
    xba,
    xbb,
    xbc,
    xbd,
    xcd,
    xcg,
    xdr,
    xof,
    xpd,
    xpf,
    xpt,
    xrp,
    xsu,
    xts,
    xua,
    xxx,
    yer,
    zar,
    zmw,
    zwg,
  ];
}
