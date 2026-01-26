# Common Currencies

This document is auto-generated from `tool/currencies.yaml` by `tool/update_currencies.dart`.

Each row represents a currency available via the `CommonCurrencies` class:

```dart
final common = CommonCurrencies();
final usd = common.usd;
final amount = Money.fromIntWithCurrency(2500, usd);
print(amount); // $25.00
```

**Total currencies:** 191

Run:

```bash
dart tool/update_currencies.dart
```

| Code | Common | ISO | Name | Country | Unit | Symbol | Pattern | Group Sep | Decimal Sep | Decimal Digits |
|------|--------|-----|------|---------|------|--------|---------|-----------|-------------|----------------|
| ADA | ada | No | Cardano | Digital | Cardano | $ | S#,##0.00 | , | . | 6 |
| AED | aed | Yes | UAE Dirham | United Arab Emirates | Dirham | د.إ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| AFN | afn | Yes | Afghani | Afghanistan | Afghani | ؋ | S #,##0.00 | , | . | 2 |
| ALL | all | Yes | Lek | Albania | Lek | L | S#,##0.00 | , | . | 2 |
| AMD | amd | Yes | Armenian Dram | Armenia | Dram | ֏ | #,##0.00S | , | . | 2 |
| ANG | ang | No | Netherlands Antillean Guilder | Curaçao and Sint Maarten | Guilder | ƒ | S #,##0.00;S -#,##0.00 | . | , | 2 |
| AOA | aoa | Yes | Kwanza | Angola | Kwanza | Kz | #,##0.00 S | . | , | 2 |
| ARS | ars | Yes | Argentine Peso | Argentina | Peso | $ | S #,##0.00 | . | , | 2 |
| AUD | aud | Yes | Australian Dollar | Australian | Dollar | $ | S#,##0.00 | , | . | 2 |
| AWG | awg | Yes | Aruban Florin | Aruba | Florin | ƒ | S #,##0.00;S -#,##0.00 | . | , | 2 |
| AZN | azn | Yes | Azerbaijan Manat | Azerbaijan | Manat | ₼ | S#,##0.00 | , | . | 2 |
| BAM | bam | Yes | Convertible Mark | Bosnia and Herzegovina | Mark | KM | S#,##0.00 | . | , | 2 |
| BBD | bbd | Yes | Barbados Dollar | Barbados | Dollar | $ | S#,##0.00 | , | . | 2 |
| BCH | bch | No | Bitcoin Cash | Digital | Bitcoin Cash | ₿ | S#,##0.00000000 | , | . | 8 |
| BDT | bdt | Yes | Taka | Bangladesh | Taka | ৳ | S#,##0.00 | , | . | 2 |
| BGN | bgn | No | Bulgarian Lev | Bulgaria | Lev | лв | S#,##0.00 | , | , | 2 |
| BHD | bhd | Yes | Bahraini Dinar | Bahrain | Dinar | .د.ب | #,##0.000S | , | . | 3 |
| BIF | bif | Yes | Burundi Franc | Burundi | Franc | FBu | S#,##0 | , | . | 0 |
| BMD | bmd | Yes | Bermudian Dollar | Bermuda | Dollar | $ | S#,##0.00 | , | . | 2 |
| BNB | bnb | No | BNB | Digital | BNB | $ | S#,##0.00 | , | . | 18 |
| BND | bnd | Yes | Brunei Dollar | Brunei | Dollar | $ | S #,##0.00 | . | , | 2 |
| BOB | bob | Yes | Boliviano | Bolivia | Boliviano | Bs. | S#,##0.00 | . | , | 2 |
| BOV | bov | Yes | Mvdol | BOLIVIA (PLURINATIONAL STATE OF) | Mvdol | $ | S#,##0.00 | . | , | 2 |
| BRL | brl | Yes | Brazilian Real | Brazil | Real | R$ | S#,##0.00 | . | , | 2 |
| BSD | bsd | Yes | Bahamian Dollar | Bahamas | Dollar | $ | S#,##0.00 | , | . | 2 |
| BTC | btc | No | Bitcoin | Digital | Bitcoin | ₿ | S#,##0.00000000 | , | . | 8 |
| BTN | btn | Yes | Ngultrum | Bhutan | Ngultrum | Nu. | S#,##0.00 | , | . | 2 |
| BWP | bwp | Yes | Pula | Botswana | Pula | P | S#,##0.00 | , | . | 2 |
| BYN | byn | Yes | Belarusian Ruble | Belarus | Ruble | Br | #,##0.00 S |   | , | 2 |
| BZD | bzd | Yes | Belize Dollar | Belize | Dollar | $ | S#,##0.00 | , | . | 2 |
| CAD | cad | Yes | Canadian Dollar | Canada | Dollar | $ | S#,##0.00 | , | . | 2 |
| CDF | cdf | Yes | Congolese Franc | Congo (DRC) | Franc | FC | #,##0.00 S |   | , | 2 |
| CHE | che | Yes | WIR Euro | SWITZERLAND | WIR Euro | $ | S #,##0.00;S-#,##0.00 | ' | . | 2 |
| CHF | chf | Yes | Swiss Franc | Switzerland | Franc | fr | S #,##0.00;S-#,##0.00 | ' | . | 2 |
| CHW | chw | Yes | WIR Franc | SWITZERLAND | WIR Franc | $ | S #,##0.00;S-#,##0.00 | ' | . | 2 |
| CLF | clf | Yes | Unidad de Fomento | CHILE | Unidad de Fomento | $ | S#,##0.00;S-#,##0.00 | . | , | 4 |
| CLP | clp | Yes | Chilean Peso | Chile | Peso | $ | S#,##0 | , | . | 0 |
| CNY | cny | Yes | Yuan Renminbi | China | Renminbi | ¥ | S#,##0.00 | , | . | 2 |
| COP | cop | Yes | Colombian Peso | Colombia | Peso | $ | #,##0.00S | . | , | 2 |
| COU | cou | Yes | Unidad de Valor Real | COLOMBIA | Unidad de Valor Real | $ | S #,##0.00 | . | , | 2 |
| CRC | crc | Yes | Costa Rican Colon | Costa Rica | Colón | ₡ | S#,##0.00 | . | , | 2 |
| CUP | cup | Yes | Cuban Peso | Cuba | Peso | $ | S#,##0.00 | , | . | 2 |
| CVE | cve | Yes | Cabo Verde Escudo | Cape Verde | Escudo | $ | #,##0.00 S |   | , | 2 |
| CZK | czk | Yes | Czech Koruna | Czech | Koruna | Kč | #,##0.00S | . | , | 2 |
| DJF | djf | Yes | Djiboutian Franc | Djibouti | Franc | Fdj | S#,##0 | , | . | 0 |
| DKK | dkk | Yes | Danish Krone | Denmark | Krone | kr | S#,##0.00 | . | , | 2 |
| DOGE | doge | No | Dogecoin | Digital | Dogecoin | $ | S#,##0.00 | , | . | 8 |
| DOP | dop | Yes | Dominican Peso | Dominican Republic | Peso | $ | S#,##0.00 | , | . | 2 |
| DZD | dzd | Yes | Algerian Dinar | Algeria | Dinar | د.ج | #,##0.00S | , | . | 2 |
| EGP | egp | Yes | Egyptian Pound | Egypt | Pound | £ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| ERN | ern | Yes | Nakfa | Eritrea | Nakfa | Nfk | S#,##0.00 | , | . | 2 |
| ETB | etb | Yes | Ethiopian Birr | Ethiopia | Birr | Br | S#,##0.00 | , | . | 2 |
| ETH | eth | No | Ethereum | Digital | Ether | $ | S#,##0.00 | , | . | 18 |
| EUR | euro | Yes | Euro | European Union | Euro | € | #,##0.00S | . | , | 2 |
| FJD | fjd | Yes | Fiji Dollar | Fiji | Dollar | $ | S#,##0.00 | , | . | 2 |
| FKP | fkp | Yes | Falkland Islands Pound | Falkland Islands | Pound | £ | S#,##0.00 | , | . | 2 |
| GBP | gbp | Yes | Pound Sterling | Britan | Pound Sterling | £ | S#,##0.00 | , | . | 2 |
| GEL | gel | Yes | Lari | Georgia | Lari | ₾ | S#,##0.00 | , | , | 2 |
| GHS | ghs | Yes | Ghana Cedi | Ghana | Cedi | ₵ | S#,##0.00 | , | . | 2 |
| GIP | gip | Yes | Gibraltar Pound | Gibraltar | Pound | £ | S#,##0.00 | , | . | 2 |
| GMD | gmd | Yes | Dalasi | Gambia | Dalasi | D | S#,##0.00 | , | . | 2 |
| GNF | gnf | Yes | Guinean Franc | Guinea | Franc | FG | S#,##0 | , | . | 0 |
| GTQ | gtq | Yes | Quetzal | Guatemala | Quetzal | Q | S#,##0.00 | , | . | 2 |
| GYD | gyd | Yes | Guyana Dollar | Guyana | Dollar | $ | S#,##0.00 | , | . | 2 |
| HKD | hkd | Yes | Hong Kong Dollar | Hong Kong | Dollar | $ | S#,##0.00 | , | . | 2 |
| HNL | hnl | Yes | Lempira | Honduras | Lempira | L | S#,##0.00 | , | . | 2 |
| HTG | htg | Yes | Gourde | Haiti | Gourde | G | S#,##0.00 | , | . | 2 |
| HUF | huf | Yes | Forint | Hungary | Forint | Ft | S#,##0 | , | . | 2 |
| IDR | idr | Yes | Rupiah | Indonesia | Rupiah | Rp | S#,##0.00 | , | . | 2 |
| ILS | ils | Yes | New Israeli Sheqel | Israel | Shekel | ₪ | S#,##0.00 | , | . | 2 |
| INR | inr | Yes | Indian Rupee | Indian | Rupee | ₹ | S##,###.00 | , | . | 2 |
| IQD | iqd | Yes | Iraqi Dinar | Iraq | Dinar | ع.د | #,##0.000S | , | . | 3 |
| IRR | irr | Yes | Iranian Rial | Iran | Rial | ﷼ | S#,##0.00 | , | . | 2 |
| ISK | isk | Yes | Iceland Krona | Iceland | Krona | kr | S#,##0 | , | . | 0 |
| JMD | jmd | Yes | Jamaican Dollar | Jamaica | Dollar | $ | S#,##0.00 | , | . | 2 |
| JOD | jod | Yes | Jordanian Dinar | Jordan | Dinar | د.ا | #,##0.000S | , | . | 3 |
| JPY | jpy | Yes | Yen | Japanese | Yen | ¥ | S#,##0 | , | . | 0 |
| KES | kes | Yes | Kenyan Shilling | Kenya | Shilling | KSh | S #,##0.00 | , | . | 2 |
| KGS | kgs | Yes | Som | Kyrgyzstan | Som | с | S#,##0.00 | , | . | 2 |
| KHR | khr | Yes | Riel | Cambodia | Riel | ៛ | S#,##0.00 | , | . | 2 |
| KMF | kmf | Yes | Comorian Franc | Comoros | Franc | CF | S#,##0 | , | . | 0 |
| KPW | kpw | Yes | North Korean Won | North Korea | Won | ₩ | S#,##0.00 | , | . | 2 |
| KRW | krw | Yes | Won | South Korean | Won | ₩ | S#,##0 | , | . | 0 |
| KWD | kwd | Yes | Kuwaiti Dinar | Kuwait | Dinar | د.ك | #,##0.000S | , | . | 3 |
| KYD | kyd | Yes | Cayman Islands Dollar | Cayman Islands | Dollar | $ | S#,##0.00 | , | . | 2 |
| KZT | kzt | Yes | Tenge | Kazakhstan | Tenge | ₸ | #,##0.00 S |   | , | 2 |
| LAK | lak | Yes | Lao Kip | Laos | Kip | ₭ | S#,##0.00 | , | . | 2 |
| LBP | lbp | Yes | Lebanese Pound | Lebanon | Pound | ل.ل | ‏#,##0.00 S;‏-#,##0.00 S | . | , | 2 |
| LKR | lkr | Yes | Sri Lanka Rupee | Sri Lanka | Rupee | Rs | S#,##0.00 | , | . | 2 |
| LRD | lrd | Yes | Liberian Dollar | Liberia | Dollar | $ | S#,##0.00 | , | . | 2 |
| LSL | lsl | Yes | Loti | Lesotho | Loti | L | S#,##0.00 | , | . | 2 |
| LTC | ltc | No | Litecoin | Digital | Litecoin | $ | S#,##0.00 | , | . | 8 |
| LYD | lyd | Yes | Libyan Dinar | Libya | Dinar | ل.د | #,##0.000S | . | , | 3 |
| MAD | mad | Yes | Moroccan Dirham | Morocco | Dirham | د.م. | ‏#,##0.00 S;‏-#,##0.00 S | , | , | 2 |
| MDL | mdl | Yes | Moldovan Leu | Moldova | Leu | L | #,##0.00 S | . | , | 2 |
| MGA | mga | Yes | Malagasy Ariary | Madagascar | Ariary | Ar | S#,##0.00 | , | . | 2 |
| MKD | mkd | Yes | Denar | North Macedonia | Denar | ден | S#,##0.00 | . | , | 2 |
| MMK | mmk | Yes | Kyat | Myanmar (Burma) | Kyat | K | S#,##0.00 | , | . | 2 |
| MNT | mnt | Yes | Tugrik | Mongolia | Tugrik | ₮ | S#,##0.00 | , | . | 2 |
| MOP | mop | Yes | Pataca | Macao | Pataca | $ | S#,##0.00 | , | . | 2 |
| MRU | mru | Yes | Ouguiya | Mauritania | Ouguiya | UM | ‏#,##0.00 S;‏-#,##0.00 S | . | , | 2 |
| MUR | mur | Yes | Mauritius Rupee | Mauritius | Rupee | ₨ | #,##0.00 S |   | , | 2 |
| MVR | mvr | Yes | Rufiyaa | Maldives | Rufiyaa | ރ. | S#,##0.00 | , | . | 2 |
| MWK | mwk | Yes | Malawi Kwacha | Malawi | Kwacha | MK | S#,##0.00 | , | . | 2 |
| MXN | mxn | Yes | Mexican Peso | Mexican | Peso | $ | S#,##0.00 | , | . | 2 |
| MXV | mxv | Yes | Mexican Unidad de Inversion (UDI) | MEXICO | Mexican Unidad de Inversion (UDI) | $ | S#,##0.00 | , | . | 2 |
| MYR | myr | Yes | Malaysian Ringgit | Malaysia | Ringgit | RM | S #,##0.00 | . | , | 2 |
| MZN | mzn | Yes | Mozambique Metical | Mozambique | Metical | MT | #,##0.00 S |   | , | 2 |
| NAD | nad | Yes | Namibia Dollar | Namibia | Dollar | $ | S#,##0.00 |   | , | 2 |
| NGN | ngn | Yes | Naira | Nigerian | Naira | ₦ | S#,##0.00 | , | . | 2 |
| NIO | nio | Yes | Cordoba Oro | Nicaragua | Córdoba | $ | S#,##0.00 | , | . | 2 |
| NOK | nok | Yes | Norwegian Krone | Norwegian | Krone | kr | S#,##0.00 | , | . | 2 |
| NPR | npr | Yes | Nepalese Rupee | Nepal | Rupee | रू | S#,##0.00 | , | . | 2 |
| NZD | nzd | Yes | New Zealand Dollar | New Zealand | Dollar | $ | S#,##0.00 | , | . | 2 |
| OMR | omr | Yes | Rial Omani | Oman | Rial | ر.ع. | #,##0.000S | , | . | 3 |
| PAB | pab | Yes | Balboa | Panama | Balboa | B/. | S#,##0.00 | , | . | 2 |
| PEN | pen | Yes | Sol | Peru | Sol | S/. | S #,##0.00 | , | . | 2 |
| PGK | pgk | Yes | Kina | Papua New Guinea | Kina | K | S#,##0.00 | , | . | 2 |
| PHP | php | Yes | Philippine Peso | Philippines | Peso | ₱ | S#,##0.00 | , | . | 2 |
| PKR | pkr | Yes | Pakistan Rupee | Pakistan | Rupee | ₨ | S#,##0.00 | , | . | 2 |
| PLN | pln | Yes | Zloty | Polish | Zloty | zł | #,##0.00S | . | , | 2 |
| PYG | pyg | Yes | Guarani | Paraguay | Guarani | ₲ | S#,##0 | . | . | 0 |
| QAR | qar | Yes | Qatari Rial | Qatar | Riyal | ر.ق | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| RON | ron | Yes | Romanian Leu | Romania | Leu | lei | S#,##0.00 | . | , | 2 |
| RSD | rsd | Yes | Serbian Dinar | Serbia | Dinar | дин | S#,##0.00 | . | , | 2 |
| RUB | rub | Yes | Russian Ruble | Russia | Ruble | ₽ | S#,##0.00 | , | . | 2 |
| RWF | rwf | Yes | Rwanda Franc | Rwanda | Franc | RF | S#,##0 | , | . | 0 |
| SAR | sar | Yes | Saudi Riyal | Saudi Arabia | Riyal | ر.س | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| SBD | sbd | Yes | Solomon Islands Dollar | Solomon Islands | Dollar | $ | S#,##0.00 | , | . | 2 |
| SCR | scr | Yes | Seychelles Rupee | Seychelles | Rupee | ₨ | #,##0.00 S |   | , | 2 |
| SDG | sdg | Yes | Sudanese Pound | Sudan | Pound | £ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| SEK | sek | Yes | Swedish Krona | Sweden | Krona | kr | S#,##0.00 | , | , | 2 |
| SGD | sgd | Yes | Singapore Dollar | Singapore | Dollar | $ | S#,##0.00 | , | . | 2 |
| SHP | shp | Yes | Saint Helena Pound | Saint Helena | Pound | £ | S#,##0.00 | , | . | 2 |
| SLE | sle | Yes | Leone | Sierra Leone | Leone | Le | S#,##0.00 | , | . | 2 |
| SOL | sol | No | Solana | Digital | Solana | $ | S#,##0.00 | , | . | 9 |
| SOS | sos | Yes | Somali Shilling | Somalia | Shilling | Sh | S#,##0.00 | , | . | 2 |
| SRD | srd | Yes | Surinam Dollar | Suriname | Dollar | $ | S #,##0.00;S -#,##0.00 | . | , | 2 |
| SSP | ssp | Yes | South Sudanese Pound | South Sudan | Pound | £ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| STN | stn | Yes | Dobra | São Tomé and Príncipe | Dobra | Db | #,##0.00 S |   | , | 2 |
| SVC | svc | Yes | El Salvador Colon | EL SALVADOR | El Salvador Colon | $ | S#,##0.00 | , | . | 2 |
| SYP | syp | Yes | Syrian Pound | Syria | Pound | £ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| SZL | szl | Yes | Lilangeni | Eswatini | Lilangeni | E | S#,##0.00 | , | . | 2 |
| THB | thb | Yes | Baht | Thailand | Baht | ฿ | S#,##0.00 | , | . | 2 |
| TJS | tjs | Yes | Somoni | Tajikistan | Somoni | ЅМ | S#,##0.00 | , | . | 2 |
| TMT | tmt | Yes | Turkmenistan New Manat | Turkmenistan | Manat | m | S#,##0.00 | , | . | 2 |
| TND | tnd | Yes | Tunisian Dinar | Tunisia | Dinar | د.ت | #,##0.000S | . | , | 3 |
| TOP | top | Yes | Pa’anga | Tonga | Paʻanga | $ | S#,##0.00 | , | . | 2 |
| TRY | ltry | Yes | Turkish Lira | Turkish | Lira | ₺ | S#,##0.00 | , | . | 2 |
| TTD | ttd | Yes | Trinidad and Tobago Dollar | Trinidad and Tobago | Dollar | $ | S#,##0.00 | , | . | 2 |
| TWD | twd | Yes | New Taiwan Dollar | New Taiwan | Dollar | $ | S#,##0 | , | . | 0 |
| TZS | tzs | Yes | Tanzanian Shilling | Tanzania | Shilling | Sh | S#,##0.00 | , | . | 2 |
| UAH | uah | Yes | Hryvnia | Ukraine | Hryvnia | ₴ | S#,##0.00 | , | . | 2 |
| UGX | ugx | Yes | Uganda Shilling | Uganda | Shilling | USh | S#,##0 | , | . | 0 |
| USD | usd | Yes | US Dollar | United States of America | Dollar | $ | S#,##0.00 | , | . | 2 |
| USDC | usdc | No | USD Coin | Digital | USD Coin | $ | S#,##0.00 | , | . | 6 |
| USDT | usdt | No | Tether | Digital | Tether | $ | S#,##0.00 | , | . | 6 |
| USN | usn | Yes | US Dollar (Next day) | UNITED STATES OF AMERICA (THE) | US Dollar (Next day) | $ | S#,##0.00 | , | . | 2 |
| UYI | uyi | Yes | Uruguay Peso en Unidades Indexadas (UI) | URUGUAY | Uruguay Peso en Unidades Indexadas (UI) | $ | S #,##0.00 | . | , | 0 |
| UYU | uyu | Yes | Peso Uruguayo | Uruguay | Peso | $ | S #,##0.00 | . | , | 2 |
| UYW | uyw | Yes | Unidad Previsional | URUGUAY | Unidad Previsional | $ | S #,##0.00 | . | , | 4 |
| UZS | uzs | Yes | Uzbekistan Sum | Uzbekistan | Som | soʻm | S#,##0.00 | , | . | 2 |
| VED | ved | Yes | Bolívar Soberano | VENEZUELA (BOLIVARIAN REPUBLIC OF) | Bolívar Soberano | $ | S#,##0.00;S-#,##0.00 | . | , | 2 |
| VES | ves | Yes | Bolívar Soberano | Venezuela | Bolívar | Bs | S#,##0.00;S-#,##0.00 | . | , | 2 |
| VND | vnd | Yes | Dong | Vietnam | Dong | ₫ | S#,##0 | . | . | 0 |
| VUV | vuv | Yes | Vatu | Vanuatu | Vatu | Vt | S#,##0 | , | . | 0 |
| WST | wst | Yes | Tala | Samoa | Tala | $ | S#,##0.00 | , | . | 2 |
| XAD | xad | Yes | Arab Accounting Dinar | ARAB MONETARY FUND | Arab Accounting Dinar | $ | S#,##0.00 | , | . | 2 |
| XAF | xaf | Yes | Central African CFA Franc | Central African States | Franc | FCFA | S#,##0 |   | . | 0 |
| XAG | xag | Yes | Silver | ZZ11_Silver | Silver | $ | S#,##0.00 | , | . | 0 |
| XAU | xau | Yes | Gold | ZZ08_Gold | Gold | $ | S#,##0.00 | , | . | 0 |
| XBA | xba | Yes | Bond Markets Unit European Composite Unit (EURCO) | ZZ01_Bond Markets Unit European_EURCO | Bond Markets Unit European Composite Unit (EURCO) | $ | S#,##0.00 | , | . | 0 |
| XBB | xbb | Yes | Bond Markets Unit European Monetary Unit (E.M.U.-6) | ZZ02_Bond Markets Unit European_EMU-6 | Bond Markets Unit European Monetary Unit (E.M.U.-6) | $ | S#,##0.00 | , | . | 0 |
| XBC | xbc | Yes | Bond Markets Unit European Unit of Account 9 (E.U.A.-9) | ZZ03_Bond Markets Unit European_EUA-9 | Bond Markets Unit European Unit of Account 9 (E.U.A.-9) | $ | S#,##0.00 | , | . | 0 |
| XBD | xbd | Yes | Bond Markets Unit European Unit of Account 17 (E.U.A.-17) | ZZ04_Bond Markets Unit European_EUA-17 | Bond Markets Unit European Unit of Account 17 (E.U.A.-17) | $ | S#,##0.00 | , | . | 0 |
| XCD | xcd | Yes | East Caribbean Dollar | East Caribbean | Dollar | $ | S#,##0.00 | , | . | 2 |
| XCG | xcg | Yes | Caribbean Guilder | Multiple | Caribbean Guilder | $ | S#,##0.00 | , | . | 2 |
| XDR | xdr | Yes | SDR (Special Drawing Right) | INTERNATIONAL MONETARY FUND (IMF) | SDR (Special Drawing Right) | $ | S#,##0.00 | , | . | 0 |
| XOF | xof | Yes | CFA Franc BCEAO | West African States | Franc | CFA | S#,##0 |   | , | 0 |
| XPD | xpd | Yes | Palladium | ZZ09_Palladium | Palladium | $ | S#,##0.00 | , | . | 0 |
| XPF | xpf | Yes | CFP Franc | French Polynesia, New Caledonia, Wallis and Futuna | Franc | F | S#,##0 | , | . | 0 |
| XPT | xpt | Yes | Platinum | ZZ10_Platinum | Platinum | $ | S#,##0.00 | , | . | 0 |
| XRP | xrp | No | XRP | Digital | XRP | $ | S#,##0.00 | , | . | 6 |
| XSU | xsu | Yes | Sucre | SISTEMA UNITARIO DE COMPENSACION REGIONAL DE PAGOS "SUCRE" | Sucre | $ | S#,##0.00 | , | . | 0 |
| XTS | xts | Yes | Codes specifically reserved for testing purposes | ZZ06_Testing_Code | Codes specifically reserved for testing purposes | $ | S#,##0.00 | , | . | 0 |
| XUA | xua | Yes | ADB Unit of Account | MEMBER COUNTRIES OF THE AFRICAN DEVELOPMENT BANK GROUP | ADB Unit of Account | $ | S#,##0.00 | , | . | 0 |
| XXX | xxx | Yes | The codes assigned for transactions where no currency is involved | ZZ07_No_Currency | The codes assigned for transactions where no currency is involved | $ | S#,##0.00 | , | . | 0 |
| YER | yer | Yes | Yemeni Rial | Yemen | Rial | ﷼ | ‏#,##0.00 S;‏-#,##0.00 S | , | . | 2 |
| ZAR | zar | Yes | Rand | South African | Rand | R | S#,##0.00 | , | . | 2 |
| ZMW | zmw | Yes | Zambian Kwacha | Zambia | Kwacha | ZK | S#,##0.00 | , | . | 2 |
| ZWG | zwg | Yes | Zimbabwe Gold | ZIMBABWE | Zimbabwe Gold | $ | S#,##0.00 | , | . | 2 |
