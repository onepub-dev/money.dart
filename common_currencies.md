# Common Currencies

This document is auto-generated from `tool/currencies.yaml` by `tool/generate_currencies.dart`.

Each row represents a currency available via the `CommonCurrencies` class:

```dart
final common = CommonCurrencies();
final usd = common.usd;
final amount = Money.fromIntWithCurrency(2500, usd);
print(amount); // $25.00
```

Empty fields indicate the value matches the default below:
- Decimal Digits: 2
- Symbol: "$"
- Pattern: "S#,##0.00"
- Group Separator: ","
- Decimal Separator: "."

**Total currencies:** 154

| ISO | Common | Name | Country | Unit | Symbol | Pattern | Group Sep | Decimal Sep | Decimal Digits |
|-----|--------|------|---------|------|--------|----------|------------|--------------|----------------|
| AED | `aed` | United Arab Emirates Dirham | United Arab Emirates | Dirham | `د.إ` |  |  |  |  |
| AFN | `afn` | Afghan Afghani | Afghanistan | Afghani | `؋` |  |  |  |  |
| ALL | `all` | Albanian Lek | Albania | Lek | `L` |  |  |  |  |
| AMD | `amd` | Armenian Dram | Armenia | Dram | `֏` | `#,##0.00S` |  |  |  |
| ANG | `ang` | Netherlands Antillean Guilder | Curaçao and Sint Maarten | Guilder | `ƒ` |  |  |  |  |
| AOA | `aoa` | Angolan Kwanza | Angola | Kwanza | `Kz` |  | `.` | `,` |  |
| ARS | `ars` | Argentine Peso | Argentina | Peso |  |  | `.` | `,` |  |
| AUD | `aud` | Australian Dollar | Australian | Dollar |  |  |  |  |  |
| AWG | `awg` | Aruban Florin | Aruba | Florin | `ƒ` |  | `.` | `,` |  |
| AZN | `azn` | Azerbaijani Manat | Azerbaijan | Manat | `₼` |  |  |  |  |
| BAM | `bam` | Bosnia and Herzegovina Convertible Mark | Bosnia and Herzegovina | Mark | `KM` |  | `.` | `,` |  |
| BBD | `bbd` | Barbadian Dollar | Barbados | Dollar |  |  |  |  |  |
| BDT | `bdt` | Bangladeshi Taka | Bangladesh | Taka | `৳` |  |  |  |  |
| BGN | `bgn` | Bulgarian Lev | Bulgaria | Lev | `лв` |  | ` ` | `,` |  |
| BHD | `bhd` | Bahraini Dinar | Bahrain | Dinar | `.د.ب` | `#,##0.000S` |  |  | 3 |
| BIF | `bif` | Burundian Franc | Burundi | Franc | `FBu` | `S#,##0` |  |  | 0 |
| BMD | `bmd` | Bermudian Dollar | Bermuda | Dollar |  |  |  |  |  |
| BND | `bnd` | Brunei Dollar | Brunei | Dollar |  |  |  |  |  |
| BOB | `bob` | Bolivian Boliviano | Bolivia | Boliviano | `Bs.` |  |  |  |  |
| BRL | `brl` | Brazilian Real | Brazil | Real | `R$` |  | `.` | `,` |  |
| BSD | `bsd` | Bahamian Dollar | Bahamas | Dollar |  |  |  |  |  |
| BTC | `btc` | Bitcon | Digital | Bitcoin | `₿` | `S#,##0.00000000` |  |  | 8 |
| BTN | `btn` | Bhutanese Ngultrum | Bhutan | Ngultrum | `Nu.` |  |  |  |  |
| BWP | `bwp` | Botswana Pula | Botswana | Pula | `P` |  |  |  |  |
| BYN | `byn` | Belarusian Ruble | Belarus | Ruble | `Br` |  | ` ` | `,` |  |
| BZD | `bzd` | Belize Dollar | Belize | Dollar |  |  |  |  |  |
| CAD | `cad` | Canadian Dollar | Canada | Dollar |  |  |  |  |  |
| CDF | `cdf` | Congolese Franc | Congo (DRC) | Franc | `FC` |  |  |  |  |
| CHF | `chf` | Swiss Franc | Switzerland | Franc | `fr` |  |  |  |  |
| CLP | `clp` | Chilean Peso | Chile | Peso |  | `S#,##0` |  |  | 0 |
| CNY | `cny` | Chinese Renminbi | China | Renminbi | `¥` |  |  |  |  |
| COP | `cop` | Colombian Peso | Colombia | Peso |  | `#,##0.00S` | `.` | `,` |  |
| CRC | `crc` | Costa Rican Colón | Costa Rica | Colón | `₡` |  | `.` | `,` |  |
| CUP | `cup` | Cuban Peso | Cuba | Peso |  |  |  |  |  |
| CVE | `cve` | Cape Verdean Escudo | Cape Verde | Escudo |  |  |  |  |  |
| CZK | `czk` | Czech Koruna | Czech | Koruna | `Kč` | `#,##0.00S` | `.` | `,` |  |
| DJF | `djf` | Djiboutian Franc | Djibouti | Franc | `Fdj` | `S#,##0` |  |  | 0 |
| DKK | `dkk` | Danish Krone | Denmark | Krone | `kr` |  | `.` | `,` |  |
| DOP | `dop` | Dominican Peso | Dominican Republic | Peso |  |  |  |  |  |
| DZD | `dzd` | Algerian Dinar | Algeria | Dinar | `د.ج` | `#,##0.00S` |  |  |  |
| EGP | `egp` | Egyptian Pound | Egypt | Pound | `£` |  |  |  |  |
| ERN | `ern` | Eritrean Nakfa | Eritrea | Nakfa | `Nfk` |  |  |  |  |
| ETB | `etb` | Ethiopian Birr | Ethiopia | Birr | `Br` |  |  |  |  |
| EUR | `euro` | European Union Euro | European Union | Euro | `€` | `#,##0.00S` | `.` | `,` |  |
| FJD | `fjd` | Fijian Dollar | Fiji | Dollar |  |  |  |  |  |
| FKP | `fkp` | Falkland Islands Pound | Falkland Islands | Pound | `£` |  |  |  |  |
| GBP | `gbp` | British Pound Sterling | Britan | Pound Sterling | `£` |  |  |  |  |
| GEL | `gel` | Georgian Lari | Georgia | Lari | `₾` |  | ` ` | `,` |  |
| GHS | `ghs` | Ghana Cedi | Ghana | Cedi | `₵` |  |  |  |  |
| GIP | `gip` | Gibraltar Pound | Gibraltar | Pound | `£` |  |  |  |  |
| GMD | `gmd` | Gambian Dalasi | Gambia | Dalasi | `D` |  |  |  |  |
| GNF | `gnf` | Guinean Franc | Guinea | Franc | `FG` | `S#,##0` |  |  | 0 |
| GTQ | `gtq` | Guatemalan Quetzal | Guatemala | Quetzal | `Q` |  |  |  |  |
| GYD | `gyd` | Guyanese Dollar | Guyana | Dollar |  |  |  |  |  |
| HKD | `hkd` | Hong Kong Dollar | Hong Kong | Dollar |  |  |  |  |  |
| HNL | `hnl` | Honduran Lempira | Honduras | Lempira | `L` |  |  |  |  |
| HTG | `htg` | Haitian Gourde | Haiti | Gourde | `G` |  |  |  |  |
| HUF | `huf` | Hungarian Forint | Hungary | Forint | `Ft` | `S#,##0` |  |  | 0 |
| IDR | `idr` | Indonesian Rupiah | Indonesia | Rupiah | `Rp` |  |  |  |  |
| ILS | `ils` | Israeli New Shekel | Israel | Shekel | `₪` |  |  |  |  |
| INR | `inr` | Indian Rupee | Indian | Rupee | `₹` | `S##,###.00` |  |  |  |
| IQD | `iqd` | Iraqi Dinar | Iraq | Dinar | `ع.د` | `#,##0.000S` |  |  | 3 |
| IRR | `irr` | Iranian Rial | Iran | Rial | `﷼` |  |  |  |  |
| ISK | `isk` | Icelandic Krona | Iceland | Krona | `kr` | `S#,##0` |  |  | 0 |
| JMD | `jmd` | Jamaican Dollar | Jamaica | Dollar |  |  |  |  |  |
| JOD | `jod` | Jordanian Dinar | Jordan | Dinar | `د.ا` | `#,##0.000S` |  |  | 3 |
| JPY | `jpy` | Japanese Yen | Japanese | Yen | `¥` | `S#,##0` |  |  | 0 |
| KES | `kes` | Kenyan Shilling | Kenya | Shilling | `KSh` |  |  |  |  |
| KGS | `kgs` | Kyrgyzstani Som | Kyrgyzstan | Som | `с` |  |  |  |  |
| KHR | `khr` | Cambodian Riel | Cambodia | Riel | `៛` |  |  |  |  |
| KMF | `kmf` | Comorian Franc | Comoros | Franc | `CF` | `S#,##0` |  |  | 0 |
| KPW | `kpw` | North Korean Won | North Korea | Won | `₩` |  |  |  |  |
| KRW | `krw` | South Korean Won | South Korean | Won | `₩` | `S#,##0` |  |  | 0 |
| KWD | `kwd` | Kuwaiti Dinar | Kuwait | Dinar | `د.ك` | `#,##0.000S` |  |  | 3 |
| KYD | `kyd` | Cayman Islands Dollar | Cayman Islands | Dollar |  |  |  |  |  |
| KZT | `kzt` | Kazakhstani Tenge | Kazakhstan | Tenge | `₸` |  |  |  |  |
| LAK | `lak` | Lao Kip | Laos | Kip | `₭` |  |  |  |  |
| LBP | `lbp` | Lebanese Pound | Lebanon | Pound | `ل.ل` |  |  |  |  |
| LKR | `lkr` | Sri Lankan Rupee | Sri Lanka | Rupee | `Rs` |  |  |  |  |
| LRD | `lrd` | Liberian Dollar | Liberia | Dollar |  |  |  |  |  |
| LSL | `lsl` | Lesotho Loti | Lesotho | Loti | `L` |  |  |  |  |
| LYD | `lyd` | Libyan Dinar | Libya | Dinar | `ل.د` | `#,##0.000S` |  |  | 3 |
| MAD | `mad` | Moroccan Dirham | Morocco | Dirham | `د.م.` |  | ` ` | `,` |  |
| MDL | `mdl` | Moldovan Leu | Moldova | Leu | `L` |  |  |  |  |
| MGA | `mga` | Malagasy Ariary | Madagascar | Ariary | `Ar` |  |  |  |  |
| MKD | `mkd` | Macedonian Denar | North Macedonia | Denar | `ден` |  | `.` | `,` |  |
| MMK | `mmk` | Myanmar Kyat | Myanmar (Burma) | Kyat | `K` |  |  |  |  |
| MNT | `mnt` | Mongolian Tugrik | Mongolia | Tugrik | `₮` |  |  |  |  |
| MOP | `mop` | Macanese Pataca | Macao | Pataca |  |  |  |  |  |
| MRU | `mru` | Mauritanian Ouguiya | Mauritania | Ouguiya | `UM` |  |  |  |  |
| MUR | `mur` | Mauritian Rupee | Mauritius | Rupee | `₨` |  |  |  |  |
| MVR | `mvr` | Maldivian Rufiyaa | Maldives | Rufiyaa | `ރ.` |  |  |  |  |
| MWK | `mwk` | Malawian Kwacha | Malawi | Kwacha | `MK` |  |  |  |  |
| MXN | `mxn` | Mexican Peso | Mexican | Peso |  |  |  |  |  |
| MYR | `myr` | Malaysian Ringgit | Malaysia | Ringgit | `RM` |  |  |  |  |
| MZN | `mzn` | Mozambican Metical | Mozambique | Metical | `MT` |  |  |  |  |
| NAD | `nad` | Namibian Dollar | Namibia | Dollar |  |  |  |  |  |
| NGN | `ngn` | Nigerian Naira | Nigerian | Naira | `₦` |  |  |  |  |
| NIO | `nio` | Nicaraguan Córdoba | Nicaragua | Córdoba |  |  |  |  |  |
| NOK | `nok` | Norwegian Krone | Norwegian | Krone | `kr` |  |  |  |  |
| NPR | `npr` | Nepalese Rupee | Nepal | Rupee | `रू` |  |  |  |  |
| NZD | `nzd` | New Zealand Dollar | New Zealand | Dollar |  |  |  |  |  |
| OMR | `omr` | Omani Rial | Oman | Rial | `ر.ع.` | `#,##0.000S` |  |  | 3 |
| PAB | `pab` | Panamanian Balboa | Panama | Balboa | `B/.` |  |  |  |  |
| PEN | `pen` | Peruvian Sol | Peru | Sol | `S/.` |  |  |  |  |
| PGK | `pgk` | Papua New Guinean Kina | Papua New Guinea | Kina | `K` |  |  |  |  |
| PHP | `php` | Philippine Peso | Philippines | Peso | `₱` |  |  |  |  |
| PKR | `pkr` | Pakistani Rupee | Pakistan | Rupee | `₨` |  |  |  |  |
| PLN | `pln` | Polish Zloty | Polish | Zloty | `zł` | `#,##0.00S` | `.` | `,` |  |
| PYG | `pyg` | Paraguayan Guarani | Paraguay | Guarani | `₲` | `S#,##0` | `.` |  | 0 |
| QAR | `qar` | Qatari Riyal | Qatar | Riyal | `ر.ق` |  |  |  |  |
| RON | `ron` | Romanian Leu | Romania | Leu | `lei` |  | `.` | `,` |  |
| RSD | `rsd` | Serbian Dinar | Serbia | Dinar | `дин` |  | `.` | `,` |  |
| RUB | `rub` | Russian Ruble | Russia | Ruble | `₽` |  |  |  |  |
| RWF | `rwf` | Rwandan Franc | Rwanda | Franc | `RF` | `S#,##0` |  |  | 0 |
| SAR | `sar` | Saudi Riyal | Saudi Arabia | Riyal | `ر.س` |  |  |  |  |
| SBD | `sbd` | Solomon Islands Dollar | Solomon Islands | Dollar |  |  |  |  |  |
| SCR | `scr` | Seychellois Rupee | Seychelles | Rupee | `₨` |  |  |  |  |
| SDG | `sdg` | Sudanese Pound | Sudan | Pound | `£` |  |  |  |  |
| SEK | `sek` | Swedish Krona | Sweden | Krona | `kr` |  | ` ` | `,` |  |
| SGD | `sgd` | Singapore Dollar | Singapore | Dollar |  |  |  |  |  |
| SHP | `shp` | Saint Helena Pound | Saint Helena | Pound | `£` |  |  |  |  |
| SLE | `sle` | Sierra Leonean Leone | Sierra Leone | Leone | `Le` |  |  |  |  |
| SOS | `sos` | Somali Shilling | Somalia | Shilling | `Sh` |  |  |  |  |
| SRD | `srd` | Surinamese Dollar | Suriname | Dollar |  |  |  |  |  |
| SSP | `ssp` | South Sudanese Pound | South Sudan | Pound | `£` |  |  |  |  |
| STN | `stn` | São Tomé and Príncipe Dobra | São Tomé and Príncipe | Dobra | `Db` |  |  |  |  |
| SYP | `syp` | Syrian Pound | Syria | Pound | `£` |  |  |  |  |
| SZL | `szl` | Swazi Lilangeni | Eswatini | Lilangeni | `E` |  |  |  |  |
| THB | `thb` | Thai Baht | Thailand | Baht | `฿` |  |  |  |  |
| TJS | `tjs` | Tajikistani Somoni | Tajikistan | Somoni | `ЅМ` |  |  |  |  |
| TMT | `tmt` | Turkmenistani Manat | Turkmenistan | Manat | `m` |  |  |  |  |
| TND | `tnd` | Tunisian Dinar | Tunisia | Dinar | `د.ت` | `#,##0.000S` |  |  | 3 |
| TOP | `top` | Tongan Paʻanga | Tonga | Paʻanga |  |  |  |  |  |
| TRY | `ltry` | Turkish Lira | Turkish | Lira | `₺` |  |  |  |  |
| TTD | `ttd` | Trinidad and Tobago Dollar | Trinidad and Tobago | Dollar |  |  |  |  |  |
| TWD | `twd` | New Taiwan Dollar | New Taiwan | Dollar |  | `S#,##0` |  |  | 0 |
| TZS | `tzs` | Tanzanian Shilling | Tanzania | Shilling | `Sh` |  |  |  |  |
| UAH | `uah` | Ukrainian Hryvnia | Ukraine | Hryvnia | `₴` |  |  |  |  |
| UGX | `ugx` | Ugandan Shilling | Uganda | Shilling | `USh` | `S#,##0` |  |  | 0 |
| USD | `usd` | United States Dollar | United States of America | Dollar |  |  |  |  |  |
| UYU | `uyu` | Uruguayan Peso | Uruguay | Peso |  |  |  |  |  |
| UZS | `uzs` | Uzbekistani Som | Uzbekistan | Som | `soʻm` |  |  |  |  |
| VES | `ves` | Venezuelan Bolívar | Venezuela | Bolívar | `Bs` |  | `.` | `,` |  |
| VND | `vnd` | Vietnamese Dong | Vietnam | Dong | `₫` | `S#,##0` | `.` |  | 0 |
| VUV | `vuv` | Vanuatu Vatu | Vanuatu | Vatu | `Vt` | `S#,##0` |  |  | 0 |
| WST | `wst` | Samoan Tala | Samoa | Tala |  |  |  |  |  |
| XAF | `xaf` | Central African CFA Franc | Central African States | Franc | `FCFA` | `S#,##0` | ` ` |  | 0 |
| XCD | `xcd` | East Caribbean Dollar | East Caribbean | Dollar |  |  |  |  |  |
| XOF | `xof` | West African CFA Franc | West African States | Franc | `CFA` | `S#,##0` | ` ` |  | 0 |
| XPF | `xpf` | CFP Franc | French Polynesia, New Caledonia, Wallis and Futuna | Franc | `F` | `S#,##0` |  |  | 0 |
| YER | `yer` | Yemeni Rial | Yemen | Rial | `﷼` |  |  |  |  |
| ZAR | `zar` | South African Rand | South African | Rand | `R` |  |  |  |  |
| ZMW | `zmw` | Zambian Kwacha | Zambia | Kwacha | `ZK` |  |  |  |  |

> Regenerate with:
>
> ```bash
> dart tool/generate_currencies.dart
> ```
