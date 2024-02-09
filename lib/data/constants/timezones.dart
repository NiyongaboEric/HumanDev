final List<String> availableTimezones = <String>[
  'UTC/GMT−12:00 Baker, Howland Island',
  'UTC/GMT−11:00 Niue, America Samoa',
  'UTC/GMT−10:00 Honolulu',
  'UTC/GMT−09:30 Marquesas Islands',
  'UTC/GMT−09:00 Anchorage',
  'UTC/GMT−08:00 Los Angeles, Vancouver',                           // Tijuana
  'UTC/GMT−07:00 Denver, Edmonton',                                 // Ciudad Juárez
  'UTC/GMT−06:00 Mexico City, Winnipeg',                            // Tegucigalpa, Guatemala City, San José, San Salvador, Chicago
  'UTC/GMT−05:00 New York, Toronto, Havana',                        // Bogotá, Kingston, Quito, Lima
  'UTC/GMT−04:00 Santiago, Santo Domingo',                          // Caracas, La Paz, Halifax, Manaus
  'UTC/GMT−03:30 St. John"s',
  'UTC/GMT−03:00 São Paulo, Buenos Aires',                          // Montevideo
  'UTC/GMT−02:00 Fernando de Noronha',                              // Greenland, South Georgia
  'UTC/GMT−01:00 Cape Verde, Azores islands',                       // Ittoqqortoormiit
  'UTC/GMT-00:00 London, Dublin, Lisbon',                           // Accra, Dakar, Abidjan
  // 'UTC/GMT±00:00',
  'UTC/GMT+00:00 Accra, Dakar',                                     // London, Dublin, Lisbon, Abidjan,
  'UTC/GMT+01:00 Berlin, Rome, Paris, Warsaw',                      // Madrid, Lagos, Kinshasa, Algiers, Casablanca
  'UTC/GMT+02:00 Athens, Bucharest, Cairo',                         // Jerusalem, Johannesburg, Khartoum, Kyiv, Riga, Sofia, Helsinki
  'UTC/GMT+03:00 Moscow, Istanbul, Riyadh',                         // Addis Ababa, Doha, Baghdad
  'UTC/GMT+03:30 Tehran',
  'UTC/GMT+04:00 Dubai, Tbilisi, Yerevan',                          // Samara, Baku
  'UTC/GMT+04:30 Kabul',
  'UTC/GMT+05:00 Karachi, Yekaterinburg',                           // Tashkent
  'UTC/GMT+05:30 Mumbai, Colombo',
  'UTC/GMT+05:45 Kathmandu',
  'UTC/GMT+06:00 Dhaka, Almaty, Omsk',
  'UTC/GMT+06:30 Yangon Cocos Islands',
  'UTC/GMT+07:00 Jakarta, Bangkok',                                 // Krasnoyarsk, Ho Chi Minh City
  'UTC/GMT+08:00 Shanghai, Kuala Lumpur',                           // Singapore, Perth, Manila, Makassar, Irkutsk, Taipei
  'UTC/GMT+08:45 Eucla',
  'UTC/GMT+09:00 Tokyo, Seoul, Pyongyang',                          // Chita, Jayapura
  'UTC/GMT+09:30 Adelaide',
  'UTC/GMT+10:00 Sydney, Port Moresby',                             // Vladivostok
  'UTC/GMT+10:30 Lord Howe Island',
  'UTC/GMT+11:00 Nouméa',
  'UTC/GMT+12:00 Auckland',                                       // Suva Petropavlovsk-Kamchatsky
  'UTC/GMT+12:45 Chatham Islands',
  'UTC/GMT+13:00 Phoenix Islands, Tokelau',
  'UTC/GMT+14:00 Line Islands',
];

final Map<String, String> availableTimezonesConversion = {
  'UTC/GMT−12:00': '-12.0',
  'UTC/GMT−11:00': '-11.0',
  'UTC/GMT−10:00': '-10.0',
  'UTC/GMT−09:30': '-9.5',
  'UTC/GMT−09:00': '-9.0',
  'UTC/GMT−08:00': '-8.0',
  'UTC/GMT−07:00': '-7.0',
  'UTC/GMT−06:00': '-6.0',
  'UTC/GMT−05:00': '-5.0',
  'UTC/GMT−04:00': '-4.0',
  'UTC/GMT−03:30': '-3.5',
  'UTC/GMT−03:00': '-3.0',
  'UTC/GMT−02:00': '-2.0',
  'UTC/GMT−01:00': '-1.0',
  'UTC/GMT-00:00': '0.0',
  'UTC/GMT+00:00': '0.0',
  'UTC/GMT+01:00': '1.0',
  'UTC/GMT+02:00': '2.0',
  'UTC/GMT+03:00': '3.0',
  'UTC/GMT+03:30': '3.5',
  'UTC/GMT+04:00': '4.0',
  'UTC/GMT+04:30': '4.5',
  'UTC/GMT+05:00': '5.0',
  'UTC/GMT+05:30': '5.5',
  'UTC/GMT+05:45': '5.75',
  'UTC/GMT+06:00': '6.0',
  'UTC/GMT+06:30': '6.5',
  'UTC/GMT+07:00': '7.0',
  'UTC/GMT+08:00': '8.0',
  'UTC/GMT+08:45': '8.75',
  'UTC/GMT+09:00': '9.0',
  'UTC/GMT+09:30': '9.5',
  'UTC/GMT+10:00': '10.0',
  'UTC/GMT+10:30': '10.5',
  'UTC/GMT+11:00': '11.0',
  'UTC/GMT+12:00': '12.0',
  'UTC/GMT+12:45': '12.75',
  'UTC/GMT+13:00': '13.0',
  'UTC/GMT+14:00': '14.0',
};
