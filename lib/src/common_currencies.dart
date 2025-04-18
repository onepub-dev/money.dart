/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'currency.dart';

/// Provides a list of the most common currencies.
///
/// The full list of currencies are available when you
/// parse an amount.
///
/// ```dart
/// Currencies.parse('$AUD10.00', pattern: 'SCCC#.#');
/// ```
///
class CommonCurrencies {
  /// Factory constructor providing
  /// access to all common currencies.
  factory CommonCurrencies() => _self;

  CommonCurrencies._internal();

  static final CommonCurrencies _self = CommonCurrencies._internal();

  /// Afghan Afghani
  final Currency afn = Currency.create(
    'AFN',
    2,
    symbol: '؋',
    country: 'Afghanistan',
    unit: 'Afghani',
    name: 'Afghan Afghani',
  );

  /// Albanian Lek
  final Currency all = Currency.create(
    'ALL',
    2,
    symbol: 'L',
    country: 'Albania',
    unit: 'Lek',
    name: 'Albanian Lek',
  );

  /// Algerian Dinar
  final Currency dzd = Currency.create(
    'DZD',
    2,
    symbol: 'د.ج',
    pattern: '0.00S',
    country: 'Algeria',
    unit: 'Dinar',
    name: 'Algerian Dinar',
  );

  /// Angolan Kwanza
  final Currency aoa = Currency.create(
    'AOA',
    2,
    symbol: 'Kz',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Angola',
    unit: 'Kwanza',
    name: 'Angolan Kwanza',
  );

  /// Argentine Peso
  final Currency ars = Currency.create(
    'ARS',
    2,
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Argentina',
    unit: 'Peso',
    name: 'Argentine Peso',
  );

  /// Armenian Dram
  final Currency amd = Currency.create(
    'AMD',
    2,
    symbol: '֏',
    pattern: '0.00S',
    country: 'Armenia',
    unit: 'Dram',
    name: 'Armenian Dram',
  );

  /// Aruban Florin
  final Currency awg = Currency.create(
    'AWG',
    2,
    symbol: 'ƒ',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Aruba',
    unit: 'Florin',
    name: 'Aruban Florin',
  );

  /// Australian Dollar
  final Currency aud = Currency.create('AUD', 2,
      country: 'Australian', unit: 'Dollar', name: 'Australian Dollar');

  /// Azerbaijani Manat
  final Currency azn = Currency.create(
    'AZN',
    2,
    symbol: '₼',
    country: 'Azerbaijan',
    unit: 'Manat',
    name: 'Azerbaijani Manat',
  );

  /// Bahamian Dollar
  final Currency bsd = Currency.create(
    'BSD',
    2,
    country: 'Bahamas',
    unit: 'Dollar',
    name: 'Bahamian Dollar',
  );

  /// Bahraini Dinar
  final Currency bhd = Currency.create(
    'BHD',
    3,
    symbol: '.د.ب',
    pattern: '0.000S',
    country: 'Bahrain',
    unit: 'Dinar',
    name: 'Bahraini Dinar',
  );

  /// Bangladeshi Taka
  final Currency bdt = Currency.create(
    'BDT',
    2,
    symbol: '৳',
    country: 'Bangladesh',
    unit: 'Taka',
    name: 'Bangladeshi Taka',
  );

  /// Barbadian Dollar
  final Currency bbd = Currency.create(
    'BBD',
    2,
    country: 'Barbados',
    unit: 'Dollar',
    name: 'Barbadian Dollar',
  );

  /// Belarusian Ruble
  final Currency byn = Currency.create(
    'BYN',
    2,
    symbol: 'Br',
    pattern: 'S0,00',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Belarus',
    unit: 'Ruble',
    name: 'Belarusian Ruble',
  );

  /// Belize Dollar
  final Currency bzd = Currency.create(
    'BZD',
    2,
    symbol: r'BZ$',
    country: 'Belize',
    unit: 'Dollar',
    name: 'Belize Dollar',
  );

  /// Bermudian Dollar
  final Currency bmd = Currency.create(
    'BMD',
    2,
    country: 'Bermuda',
    unit: 'Dollar',
    name: 'Bermudian Dollar',
  );

  /// Bhutanese Ngultrum
  final Currency btn = Currency.create(
    'BTN',
    2,
    symbol: 'Nu.',
    country: 'Bhutan',
    unit: 'Ngultrum',
    name: 'Bhutanese Ngultrum',
  );

  /// Bitcoin
  final Currency btc = Currency.create('BTC', 8,
      symbol: '₿',
      pattern: 'S0.00000000',
      country: 'Digital',
      unit: 'Bitcoin',
      name: 'Bitcon');

  /// Bolivian Boliviano
  final Currency bob = Currency.create(
    'BOB',
    2,
    symbol: 'Bs.',
    country: 'Bolivia',
    unit: 'Boliviano',
    name: 'Bolivian Boliviano',
  );

  /// Bosnia and Herzegovina Convertible Mark
  final Currency bam = Currency.create(
    'BAM',
    2,
    symbol: 'KM',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Bosnia and Herzegovina',
    unit: 'Mark',
    name: 'Bosnia and Herzegovina Convertible Mark',
  );

  /// Botswana Pula
  final Currency bwp = Currency.create(
    'BWP',
    2,
    symbol: 'P',
    country: 'Botswana',
    unit: 'Pula',
    name: 'Botswana Pula',
  );

  /// Brazilian Real
  final Currency brl = Currency.create('BRL', 2,
      symbol: r'R$',
      groupSeparator: '.',
      decimalSeparator: ',',
      country: 'Brazil',
      unit: 'Real',
      name: 'Brazilian Real');

  /// British Pound Sterling
  final Currency gbp = Currency.create('GBP', 2,
      symbol: '£',
      country: 'Britan',
      unit: 'Pound Sterling',
      name: 'British Pound Sterling');

  /// Brunei Dollar
  final Currency bnd = Currency.create(
    'BND',
    2,
    country: 'Brunei',
    unit: 'Dollar',
    name: 'Brunei Dollar',
  );

  /// Bulgarian Lev
  final Currency bgn = Currency.create(
    'BGN',
    2,
    symbol: 'лв',
    pattern: 'S0,00',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Bulgaria',
    unit: 'Lev',
    name: 'Bulgarian Lev',
  );

  /// Burundian Franc
  final Currency bif = Currency.create(
    'BIF',
    0,
    symbol: 'FBu',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Burundi',
    unit: 'Franc',
    name: 'Burundian Franc',
  );

  /// Cambodian Riel
  final Currency khr = Currency.create(
    'KHR',
    2,
    symbol: '៛',
    country: 'Cambodia',
    unit: 'Riel',
    name: 'Cambodian Riel',
  );

  /// Canadian Dollar
  final Currency cad = Currency.create('CAD', 2,
      country: 'Canada', unit: 'Dollar', name: 'Canadian Dollar');

  /// Cape Verdean Escudo
  final Currency cve = Currency.create(
    'CVE',
    2,
    country: 'Cape Verde',
    unit: 'Escudo',
    name: 'Cape Verdean Escudo',
  );

  /// Cayman Islands Dollar
  final Currency kyd = Currency.create(
    'KYD',
    2,
    country: 'Cayman Islands',
    unit: 'Dollar',
    name: 'Cayman Islands Dollar',
  );

  /// Central African CFA Franc
  final Currency xaf = Currency.create(
    'XAF',
    0,
    symbol: 'FCFA',
    pattern: 'S0',
    groupSeparator: ' ',
    decimalSeparator: '',
    country: 'Central African States',
    unit: 'Franc',
    name: 'Central African CFA Franc',
  );

  /// CFP Franc
  final Currency xpf = Currency.create(
    'XPF',
    0,
    symbol: '₣',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'French Polynesia, New Caledonia, Wallis and Futuna',
    unit: 'Franc',
    name: 'CFP Franc',
  );

  /// Chilean Peso
  final Currency clp = Currency.create(
    'CLP',
    0,
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Chile',
    unit: 'Peso',
    name: 'Chilean Peso',
  );

  /// Chinese Renminbi
  final Currency cny = Currency.create('CNY', 2,
      symbol: '¥',
      country: 'China',
      unit: 'Renminbi',
      name: 'Chinese Renminbi');

  /// Colombian Peso
  final Currency cop = Currency.create(
    'COP',
    2,
    pattern: '0,00S',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Colombia',
    unit: 'Peso',
    name: 'Colombian Peso',
  );

  /// Comorian Franc
  final Currency kmf = Currency.create(
    'KMF',
    0,
    symbol: 'CF',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Comoros',
    unit: 'Franc',
    name: 'Comorian Franc',
  );

  /// Congolese Franc
  final Currency cdf = Currency.create(
    'CDF',
    2,
    symbol: 'FC',
    country: 'Congo (DRC)',
    unit: 'Franc',
    name: 'Congolese Franc',
  );

  /// Costa Rican Colón
  final Currency crc = Currency.create(
    'CRC',
    2,
    symbol: '₡',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Costa Rica',
    unit: 'Colón',
    name: 'Costa Rican Colón',
  );

  /// Cuban Peso
  final Currency cup = Currency.create(
    'CUP',
    2,
    country: 'Cuba',
    unit: 'Peso',
    name: 'Cuban Peso',
  );

  /// Czech Koruna
  final Currency czk = Currency.create('CZK', 2,
      symbol: 'Kč',
      groupSeparator: '.',
      decimalSeparator: ',',
      pattern: '0.00S',
      country: 'Czech',
      unit: 'Koruna',
      name: 'Czech Koruna');

  /// Danish Krone
  final Currency dkk = Currency.create(
    'DKK',
    2,
    symbol: 'kr',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Denmark',
    unit: 'Krone',
    name: 'Danish Krone',
  );

  /// Djiboutian Franc
  final Currency djf = Currency.create(
    'DJF',
    0,
    symbol: 'Fdj',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Djibouti',
    unit: 'Franc',
    name: 'Djiboutian Franc',
  );

  /// Dominican Peso
  final Currency dop = Currency.create(
    'DOP',
    2,
    country: 'Dominican Republic',
    unit: 'Peso',
    name: 'Dominican Peso',
  );

  /// East Caribbean Dollar
  final Currency xcd = Currency.create(
    'XCD',
    2,
    country: 'East Caribbean',
    unit: 'Dollar',
    name: 'East Caribbean Dollar',
  );

  /// Egyptian Pound
  final Currency egp = Currency.create(
    'EGP',
    2,
    symbol: '£',
    country: 'Egypt',
    unit: 'Pound',
    name: 'Egyptian Pound',
  );

  /// Eritrean Nakfa
  final Currency ern = Currency.create(
    'ERN',
    2,
    symbol: 'Nfk',
    country: 'Eritrea',
    unit: 'Nakfa',
    name: 'Eritrean Nakfa',
  );

  /// Ethiopian Birr
  final Currency etb = Currency.create(
    'ETB',
    2,
    symbol: 'Br',
    country: 'Ethiopia',
    unit: 'Birr',
    name: 'Ethiopian Birr',
  );

  /// European Union Euro
  final Currency euro = Currency.create('EUR', 2,
      symbol: '€',
      groupSeparator: '.',
      decimalSeparator: ',',
      pattern: '0.00S',
      country: 'European Union',
      unit: 'Euro',
      name: 'European Union Euro');

  /// Falkland Islands Pound
  final Currency fkp = Currency.create(
    'FKP',
    2,
    symbol: '£',
    country: 'Falkland Islands',
    unit: 'Pound',
    name: 'Falkland Islands Pound',
  );

  /// Fijian Dollar
  final Currency fjd = Currency.create(
    'FJD',
    2,
    country: 'Fiji',
    unit: 'Dollar',
    name: 'Fijian Dollar',
  );

  /// Gambian Dalasi
  final Currency gmd = Currency.create(
    'GMD',
    2,
    symbol: 'D',
    country: 'Gambia',
    unit: 'Dalasi',
    name: 'Gambian Dalasi',
  );

  /// Georgian Lari
  final Currency gel = Currency.create(
    'GEL',
    2,
    symbol: '₾',
    pattern: 'S0,00',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Georgia',
    unit: 'Lari',
    name: 'Georgian Lari',
  );

  /// Ghana Cedi
  final Currency ghs = Currency.create('GHS', 2,
      symbol: '₵', country: 'Ghana', unit: 'Cedi', name: 'Ghana Cedi');

  /// Gibraltar Pound
  final Currency gip = Currency.create(
    'GIP',
    2,
    symbol: '£',
    country: 'Gibraltar',
    unit: 'Pound',
    name: 'Gibraltar Pound',
  );

  /// Guatemalan Quetzal
  final Currency gtq = Currency.create(
    'GTQ',
    2,
    symbol: 'Q',
    country: 'Guatemala',
    unit: 'Quetzal',
    name: 'Guatemalan Quetzal',
  );

  /// Guinean Franc
  final Currency gnf = Currency.create(
    'GNF',
    0,
    symbol: 'FG',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Guinea',
    unit: 'Franc',
    name: 'Guinean Franc',
  );

  /// Guyanese Dollar
  final Currency gyd = Currency.create(
    'GYD',
    2,
    country: 'Guyana',
    unit: 'Dollar',
    name: 'Guyanese Dollar',
  );

  /// Haitian Gourde
  final Currency htg = Currency.create(
    'HTG',
    2,
    symbol: 'G',
    country: 'Haiti',
    unit: 'Gourde',
    name: 'Haitian Gourde',
  );

  /// Honduran Lempira
  final Currency hnl = Currency.create(
    'HNL',
    2,
    symbol: 'L',
    country: 'Honduras',
    unit: 'Lempira',
    name: 'Honduran Lempira',
  );

  /// Hong Kong Dollar
  final Currency hkd = Currency.create(
    'HKD',
    2,
    country: 'Hong Kong',
    unit: 'Dollar',
    name: 'Hong Kong Dollar',
  );

  /// Hungarian Forint
  final Currency huf = Currency.create(
    'HUF',
    0,
    symbol: 'Ft',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Hungary',
    unit: 'Forint',
    name: 'Hungarian Forint',
  );

  /// Icelandic Krona
  final Currency isk = Currency.create(
    'ISK',
    0,
    symbol: 'kr',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Iceland',
    unit: 'Krona',
    name: 'Icelandic Krona',
  );

  /// Indian Rupee
  final Currency inr = Currency.create('INR', 2,
      symbol: '₹',
      country: 'Indian',
      unit: 'Rupee',
      name: 'Indian Rupee',
      pattern: 'S##,###.00');

  /// Indonesian Rupiah
  final Currency idr = Currency.create(
    'IDR',
    2,
    symbol: 'Rp',
    country: 'Indonesia',
    unit: 'Rupiah',
    name: 'Indonesian Rupiah',
  );

  /// Iranian Rial
  final Currency irr = Currency.create(
    'IRR',
    2,
    symbol: '﷼',
    pattern: 'S0,00',
    country: 'Iran',
    unit: 'Rial',
    name: 'Iranian Rial',
  );

  /// Iraqi Dinar
  final Currency iqd = Currency.create(
    'IQD',
    3,
    symbol: 'ع.د',
    pattern: '0.000S',
    country: 'Iraq',
    unit: 'Dinar',
    name: 'Iraqi Dinar',
  );

  /// Israeli New Shekel
  final Currency ils = Currency.create(
    'ILS',
    2,
    symbol: '₪',
    country: 'Israel',
    unit: 'Shekel',
    name: 'Israeli New Shekel',
  );

  /// Jamaican Dollar
  final Currency jmd = Currency.create(
    'JMD',
    2,
    country: 'Jamaica',
    unit: 'Dollar',
    name: 'Jamaican Dollar',
  );

  /// Japanese Yen
  final Currency jpy = Currency.create('JPY', 0,
      symbol: '¥',
      pattern: 'S0',
      country: 'Japanese',
      unit: 'Yen',
      name: 'Japanese Yen');

  /// Jordanian Dinar
  final Currency jod = Currency.create(
    'JOD',
    3,
    symbol: 'د.ا',
    pattern: '0.000S',
    country: 'Jordan',
    unit: 'Dinar',
    name: 'Jordanian Dinar',
  );

  /// Kazakhstani Tenge
  final Currency kzt = Currency.create(
    'KZT',
    2,
    symbol: '₸',
    country: 'Kazakhstan',
    unit: 'Tenge',
    name: 'Kazakhstani Tenge',
  );

  /// Kenyan Shilling
  final Currency kes = Currency.create(
    'KES',
    2,
    symbol: 'KSh',
    country: 'Kenya',
    unit: 'Shilling',
    name: 'Kenyan Shilling',
  );

  /// Kuwaiti Dinar
  final Currency kwd = Currency.create(
    'KWD',
    3,
    symbol: 'د.ك',
    pattern: '0.000S',
    country: 'Kuwait',
    unit: 'Dinar',
    name: 'Kuwaiti Dinar',
  );

  /// Kyrgyzstani Som
  final Currency kgs = Currency.create(
    'KGS',
    2,
    symbol: 'с',
    country: 'Kyrgyzstan',
    unit: 'Som',
    name: 'Kyrgyzstani Som',
  );

  /// Lao Kip
  final Currency lak = Currency.create(
    'LAK',
    2,
    symbol: '₭',
    country: 'Laos',
    unit: 'Kip',
    name: 'Lao Kip',
  );

  /// Lebanese Pound
  final Currency lbp = Currency.create(
    'LBP',
    2,
    symbol: 'ل.ل',
    country: 'Lebanon',
    unit: 'Pound',
    name: 'Lebanese Pound',
  );

  /// Lesotho Loti
  final Currency lsl = Currency.create(
    'LSL',
    2,
    symbol: 'L',
    country: 'Lesotho',
    unit: 'Loti',
    name: 'Lesotho Loti',
  );

  /// Liberian Dollar
  final Currency lrd = Currency.create(
    'LRD',
    2,
    country: 'Liberia',
    unit: 'Dollar',
    name: 'Liberian Dollar',
  );

  /// Libyan Dinar
  final Currency lyd = Currency.create(
    'LYD',
    3,
    symbol: 'ل.د',
    pattern: '0.000S',
    country: 'Libya',
    unit: 'Dinar',
    name: 'Libyan Dinar',
  );

  /// Macanese Pataca
  final Currency mop = Currency.create(
    'MOP',
    2,
    symbol: r'MOP$',
    country: 'Macao',
    unit: 'Pataca',
    name: 'Macanese Pataca',
  );

  /// Macedonian Denar
  final Currency mkd = Currency.create(
    'MKD',
    2,
    symbol: 'ден',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'North Macedonia',
    unit: 'Denar',
    name: 'Macedonian Denar',
  );

  /// Malagasy Ariary
  final Currency mga = Currency.create(
    'MGA',
    2,
    symbol: 'Ar',
    country: 'Madagascar',
    unit: 'Ariary',
    name: 'Malagasy Ariary',
  );

  /// Malawian Kwacha
  final Currency mwk = Currency.create(
    'MWK',
    2,
    symbol: 'MK',
    country: 'Malawi',
    unit: 'Kwacha',
    name: 'Malawian Kwacha',
  );

  /// Malaysian Ringgit
  final Currency myr = Currency.create(
    'MYR',
    2,
    symbol: 'RM',
    country: 'Malaysia',
    unit: 'Ringgit',
    name: 'Malaysian Ringgit',
  );

  /// Maldivian Rufiyaa
  final Currency mvr = Currency.create(
    'MVR',
    2,
    symbol: 'ރ.',
    country: 'Maldives',
    unit: 'Rufiyaa',
    name: 'Maldivian Rufiyaa',
  );

  /// Mauritanian Ouguiya
  final Currency mru = Currency.create(
    'MRU',
    2,
    symbol: 'UM',
    country: 'Mauritania',
    unit: 'Ouguiya',
    name: 'Mauritanian Ouguiya',
  );

  /// Mauritian Rupee
  final Currency mur = Currency.create(
    'MUR',
    2,
    symbol: '₨',
    country: 'Mauritius',
    unit: 'Rupee',
    name: 'Mauritian Rupee',
  );

  /// Mexican Peso
  final Currency mxn = Currency.create('MXN', 2,
      country: 'Mexican', unit: 'Peso', name: 'Mexican Peso');

  /// Moldovan Leu
  final Currency mdl = Currency.create(
    'MDL',
    2,
    symbol: 'L',
    country: 'Moldova',
    unit: 'Leu',
    name: 'Moldovan Leu',
  );

  /// Mongolian Tugrik
  final Currency mnt = Currency.create(
    'MNT',
    2,
    symbol: '₮',
    country: 'Mongolia',
    unit: 'Tugrik',
    name: 'Mongolian Tugrik',
  );

  /// Moroccan Dirham
  final Currency mad = Currency.create(
    'MAD',
    2,
    symbol: 'د.م.',
    pattern: 'S0,00',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Morocco',
    unit: 'Dirham',
    name: 'Moroccan Dirham',
  );

  /// Mozambican Metical
  final Currency mzn = Currency.create(
    'MZN',
    2,
    symbol: 'MT',
    country: 'Mozambique',
    unit: 'Metical',
    name: 'Mozambican Metical',
  );

  /// Myanmar Kyat
  final Currency mmk = Currency.create(
    'MMK',
    2,
    symbol: 'K',
    country: 'Myanmar (Burma)',
    unit: 'Kyat',
    name: 'Myanmar Kyat',
  );

  /// Namibian Dollar
  final Currency nad = Currency.create(
    'NAD',
    2,
    country: 'Namibia',
    unit: 'Dollar',
    name: 'Namibian Dollar',
  );

  /// Nepalese Rupee
  final Currency npr = Currency.create(
    'NPR',
    2,
    symbol: 'रू',
    country: 'Nepal',
    unit: 'Rupee',
    name: 'Nepalese Rupee',
  );

  /// Netherlands Antillean Guilder
  final Currency ang = Currency.create(
    'ANG',
    2,
    symbol: 'ƒ',
    country: 'Curaçao and Sint Maarten',
    unit: 'Guilder',
    name: 'Netherlands Antillean Guilder',
  );

  /// New Taiwan Dollar
  final Currency twd = Currency.create('TWD', 0,
      symbol: r'NT$',
      pattern: 'S0',
      country: 'New Taiwan',
      unit: 'Dollar',
      name: 'New Taiwan Dollar');

  /// New Zealand Dollar
  final Currency nzd = Currency.create('NZD', 2,
      country: 'New Zealand', unit: 'Dollar', name: 'New Zealand Dollar');

  /// Nicaraguan Córdoba
  final Currency nio = Currency.create(
    'NIO',
    2,
    symbol: r'C$',
    country: 'Nicaragua',
    unit: 'Córdoba',
    name: 'Nicaraguan Córdoba',
  );

  /// Nigerian Naira
  final Currency ngn = Currency.create('NGN', 2,
      symbol: '₦', country: 'Nigerian', unit: 'Naira', name: 'Nigerian Naira');

  /// North Korean Won
  final Currency kpw = Currency.create(
    'KPW',
    2,
    symbol: '₩',
    country: 'North Korea',
    unit: 'Won',
    name: 'North Korean Won',
  );

  /// Norwegian Krone
  final Currency nok = Currency.create('NOK', 2,
      symbol: 'kr',
      country: 'Norwegian',
      unit: 'Krone',
      name: 'Norwegian Krone');

  /// Omani Rial
  final Currency omr = Currency.create(
    'OMR',
    3,
    symbol: 'ر.ع.',
    pattern: '0.000S',
    country: 'Oman',
    unit: 'Rial',
    name: 'Omani Rial',
  );

  /// Pakistani Rupee
  final Currency pkr = Currency.create(
    'PKR',
    2,
    symbol: '₨',
    country: 'Pakistan',
    unit: 'Rupee',
    name: 'Pakistani Rupee',
  );

  /// Panamanian Balboa
  final Currency pab = Currency.create(
    'PAB',
    2,
    symbol: 'B/.',
    country: 'Panama',
    unit: 'Balboa',
    name: 'Panamanian Balboa',
  );

  /// Papua New Guinean Kina
  final Currency pgk = Currency.create(
    'PGK',
    2,
    symbol: 'K',
    country: 'Papua New Guinea',
    unit: 'Kina',
    name: 'Papua New Guinean Kina',
  );

  /// Paraguayan Guarani
  final Currency pyg = Currency.create(
    'PYG',
    0,
    symbol: '₲',
    pattern: 'S0',
    groupSeparator: '.',
    decimalSeparator: '',
    country: 'Paraguay',
    unit: 'Guarani',
    name: 'Paraguayan Guarani',
  );

  /// Peruvian Sol
  final Currency pen = Currency.create(
    'PEN',
    2,
    symbol: 'S/.',
    country: 'Peru',
    unit: 'Sol',
    name: 'Peruvian Sol',
  );

  /// Philippine Peso
  final Currency php = Currency.create(
    'PHP',
    2,
    symbol: '₱',
    country: 'Philippines',
    unit: 'Peso',
    name: 'Philippine Peso',
  );

  /// Polish Zloty
  final Currency pln = Currency.create('PLN', 2,
      symbol: 'zł',
      groupSeparator: '.',
      decimalSeparator: ',',
      pattern: '0.00S',
      country: 'Polish',
      unit: 'Zloty',
      name: 'Polish Zloty');

  /// Qatari Riyal
  final Currency qar = Currency.create(
    'QAR',
    2,
    symbol: 'ر.ق',
    country: 'Qatar',
    unit: 'Riyal',
    name: 'Qatari Riyal',
  );

  /// Romanian Leu
  final Currency ron = Currency.create(
    'RON',
    2,
    symbol: 'lei',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Romania',
    unit: 'Leu',
    name: 'Romanian Leu',
  );

  /// Russian Ruble
  final Currency rub = Currency.create('RUB', 2,
      symbol: '₽', country: 'Russia', unit: 'Ruble', name: 'Russian Ruble');

  /// Rwandan Franc
  final Currency rwf = Currency.create(
    'RWF',
    0,
    symbol: 'RF',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Rwanda',
    unit: 'Franc',
    name: 'Rwandan Franc',
  );

  /// Saint Helena Pound
  final Currency shp = Currency.create(
    'SHP',
    2,
    symbol: '£',
    country: 'Saint Helena',
    unit: 'Pound',
    name: 'Saint Helena Pound',
  );

  /// Samoan Tala
  final Currency wst = Currency.create(
    'WST',
    2,
    symbol: r'WS$',
    country: 'Samoa',
    unit: 'Tala',
    name: 'Samoan Tala',
  );

  /// São Tomé and Príncipe Dobra
  final Currency stn = Currency.create(
    'STN',
    2,
    symbol: 'Db',
    country: 'São Tomé and Príncipe',
    unit: 'Dobra',
    name: 'São Tomé and Príncipe Dobra',
  );

  /// Saudi Riyal
  final Currency sar = Currency.create(
    'SAR',
    2,
    symbol: 'ر.س',
    country: 'Saudi Arabia',
    unit: 'Riyal',
    name: 'Saudi Riyal',
  );

  /// Serbian Dinar
  final Currency rsd = Currency.create(
    'RSD',
    2,
    symbol: 'дин',
    pattern: 'S0,00',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Serbia',
    unit: 'Dinar',
    name: 'Serbian Dinar',
  );

  /// Seychellois Rupee
  final Currency scr = Currency.create(
    'SCR',
    2,
    symbol: '₨',
    country: 'Seychelles',
    unit: 'Rupee',
    name: 'Seychellois Rupee',
  );

  /// Sierra Leonean Leone
  final Currency sle = Currency.create(
    'SLE',
    2,
    symbol: 'Le',
    country: 'Sierra Leone',
    unit: 'Leone',
    name: 'Sierra Leonean Leone',
  );

  /// Singapore Dollar
  final Currency sgd = Currency.create(
    'SGD',
    2,
    country: 'Singapore',
    unit: 'Dollar',
    name: 'Singapore Dollar',
  );

  /// Solomon Islands Dollar
  final Currency sbd = Currency.create(
    'SBD',
    2,
    country: 'Solomon Islands',
    unit: 'Dollar',
    name: 'Solomon Islands Dollar',
  );

  /// Somali Shilling
  final Currency sos = Currency.create(
    'SOS',
    2,
    symbol: 'Sh',
    country: 'Somalia',
    unit: 'Shilling',
    name: 'Somali Shilling',
  );

  /// South African Rand
  final Currency zar = Currency.create('ZAR', 2,
      symbol: 'R',
      country: 'South African',
      unit: 'Rand',
      name: 'South African Rand');

  /// South Korean Won
  final Currency krw = Currency.create('KRW', 0,
      symbol: '₩',
      pattern: 'S0',
      country: 'South Korean',
      unit: 'Won',
      name: 'South Korean Won');

  /// South Sudanese Pound
  final Currency ssp = Currency.create(
    'SSP',
    2,
    symbol: '£',
    country: 'South Sudan',
    unit: 'Pound',
    name: 'South Sudanese Pound',
  );

  /// Sri Lankan Rupee
  final Currency lkr = Currency.create(
    'LKR',
    2,
    symbol: 'Rs',
    country: 'Sri Lanka',
    unit: 'Rupee',
    name: 'Sri Lankan Rupee',
  );

  /// Sudanese Pound
  final Currency sdg = Currency.create(
    'SDG',
    2,
    symbol: '£',
    country: 'Sudan',
    unit: 'Pound',
    name: 'Sudanese Pound',
  );

  /// Surinamese Dollar
  final Currency srd = Currency.create(
    'SRD',
    2,
    country: 'Suriname',
    unit: 'Dollar',
    name: 'Surinamese Dollar',
  );

  /// Swazi Lilangeni
  final Currency szl = Currency.create(
    'SZL',
    2,
    symbol: 'E',
    country: 'Eswatini',
    unit: 'Lilangeni',
    name: 'Swazi Lilangeni',
  );

  /// Swedish Krona
  final Currency sek = Currency.create(
    'SEK',
    2,
    symbol: 'kr',
    pattern: 'S0,00',
    groupSeparator: ' ',
    decimalSeparator: ',',
    country: 'Sweden',
    unit: 'Krona',
    name: 'Swedish Krona',
  );

  /// Swiss Franc
  final Currency chf = Currency.create('CHF', 2,
      symbol: 'fr', country: 'Switzerland', unit: 'Franc', name: 'Swiss Franc');

  /// Syrian Pound
  final Currency syp = Currency.create(
    'SYP',
    2,
    symbol: '£',
    country: 'Syria',
    unit: 'Pound',
    name: 'Syrian Pound',
  );

  /// Tajikistani Somoni
  final Currency tjs = Currency.create(
    'TJS',
    2,
    symbol: 'ЅМ',
    country: 'Tajikistan',
    unit: 'Somoni',
    name: 'Tajikistani Somoni',
  );

  /// Tanzanian Shilling
  final Currency tzs = Currency.create(
    'TZS',
    2,
    symbol: 'Sh',
    country: 'Tanzania',
    unit: 'Shilling',
    name: 'Tanzanian Shilling',
  );

  /// Thai Baht
  final Currency thb = Currency.create(
    'THB',
    2,
    symbol: '฿',
    country: 'Thailand',
    unit: 'Baht',
    name: 'Thai Baht',
  );

  /// Tongan Paʻanga
  final Currency top = Currency.create(
    'TOP',
    2,
    symbol: r'T$',
    country: 'Tonga',
    unit: 'Paʻanga',
    name: 'Tongan Paʻanga',
  );

  /// Trinidad and Tobago Dollar
  final Currency ttd = Currency.create(
    'TTD',
    2,
    symbol: r'TT$',
    country: 'Trinidad and Tobago',
    unit: 'Dollar',
    name: 'Trinidad and Tobago Dollar',
  );

  /// Tunisian Dinar
  final Currency tnd = Currency.create(
    'TND',
    3,
    symbol: 'د.ت',
    pattern: '0.000S',
    country: 'Tunisia',
    unit: 'Dinar',
    name: 'Tunisian Dinar',
  );

  /// Turkish Lira
  final Currency ltry = Currency.create('TRY', 2,
      symbol: '₺', country: 'Turkish', unit: 'Lira', name: 'Turkish Lira');

  /// Turkmenistani Manat
  final Currency tmt = Currency.create(
    'TMT',
    2,
    symbol: 'm',
    country: 'Turkmenistan',
    unit: 'Manat',
    name: 'Turkmenistani Manat',
  );

  /// Ugandan Shilling
  final Currency ugx = Currency.create(
    'UGX',
    0,
    symbol: 'USh',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Uganda',
    unit: 'Shilling',
    name: 'Ugandan Shilling',
  );

  /// Ukrainian Hryvnia
  final Currency uah = Currency.create(
    'UAH',
    2,
    symbol: '₴',
    country: 'Ukraine',
    unit: 'Hryvnia',
    name: 'Ukrainian Hryvnia',
  );

  /// United Arab Emirates Dirham
  final Currency aed = Currency.create(
    'AED',
    2,
    symbol: 'د.إ',
    country: 'United Arab Emirates',
    unit: 'Dirham',
    name: 'United Arab Emirates Dirham',
  );

  /// United States Dollar
  final Currency usd = Currency.create('USD', 2,
      country: 'United States of America',
      unit: 'Dollar',
      name: 'United States Dollar');

  /// Uruguayan Peso
  final Currency uyu = Currency.create(
    'UYU',
    2,
    symbol: r'$U',
    country: 'Uruguay',
    unit: 'Peso',
    name: 'Uruguayan Peso',
  );

  /// Uzbekistani Som
  final Currency uzs = Currency.create(
    'UZS',
    2,
    symbol: 'soʻm',
    country: 'Uzbekistan',
    unit: 'Som',
    name: 'Uzbekistani Som',
  );

  /// Vanuatu Vatu
  final Currency vuv = Currency.create(
    'VUV',
    0,
    symbol: 'Vt',
    pattern: 'S0',
    decimalSeparator: '',
    country: 'Vanuatu',
    unit: 'Vatu',
    name: 'Vanuatu Vatu',
  );

  /// Venezuelan Bolívar
  final Currency ves = Currency.create(
    'VES',
    2,
    symbol: 'Bs',
    groupSeparator: '.',
    decimalSeparator: ',',
    country: 'Venezuela',
    unit: 'Bolívar',
    name: 'Venezuelan Bolívar',
  );

  /// Vietnamese Dong
  final Currency vnd = Currency.create(
    'VND',
    0,
    symbol: '₫',
    pattern: 'S0',
    groupSeparator: '.',
    decimalSeparator: '',
    country: 'Vietnam',
    unit: 'Dong',
    name: 'Vietnamese Dong',
  );

  /// West African CFA Franc
  final Currency xof = Currency.create(
    'XOF',
    0,
    symbol: 'CFA',
    pattern: 'S0',
    groupSeparator: ' ',
    decimalSeparator: '',
    country: 'West African States',
    unit: 'Franc',
    name: 'West African CFA Franc',
  );

  /// Yemeni Rial
  final Currency yer = Currency.create(
    'YER',
    2,
    symbol: '﷼',
    country: 'Yemen',
    unit: 'Rial',
    name: 'Yemeni Rial',
  );

  /// Zambian Kwacha
  final Currency zmw = Currency.create(
    'ZMW',
    2,
    symbol: 'ZK',
    country: 'Zambia',
    unit: 'Kwacha',
    name: 'Zambian Kwacha',
  );

  /// Return list of all of the common currency.
  List<Currency> asList() => [
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
        bdt,
        bgn,
        bhd,
        bif,
        bmd,
        bnd,
        bob,
        brl,
        bsd,
        btc,
        btn,
        bwp,
        byn,
        bzd,
        cad,
        cdf,
        chf,
        clp,
        cny,
        cop,
        crc,
        cup,
        cve,
        czk,
        djf,
        dkk,
        dop,
        dzd,
        egp,
        ern,
        etb,
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
        ltry,
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
        sos,
        srd,
        ssp,
        stn,
        syp,
        szl,
        thb,
        tjs,
        tmt,
        tnd,
        top,
        ttd,
        twd,
        tzs,
        uah,
        ugx,
        usd,
        uyu,
        uzs,
        ves,
        vnd,
        vuv,
        wst,
        xaf,
        xcd,
        xof,
        xpf,
        yer,
        zar,
        zmw,
      ];
}
