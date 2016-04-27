//
//  CurrencyStore.m
//  YahooApiTest
//
//  Created by Serge Sychov on 13.11.15.
//  Copyright © 2015 Serge Sychov. All rights reserved.
//

#import "CurrencyStore.h"

@implementation CurrencyStore

#pragma mark Currancies strings
 #define KRW NSLocalizedStringFromTable(@"KRW",@"ItcCalcCurenciesTable", @"Южнокорейский Вон")
 #define VND NSLocalizedStringFromTable(@"VND",@"ItcCalcCurenciesTable", @"Вьетнамский Донг")
 #define BOB NSLocalizedStringFromTable(@"BOB",@"ItcCalcCurenciesTable", @"Боливийский Боливано")
 #define MOP NSLocalizedStringFromTable(@"MOP",@"ItcCalcCurenciesTable", @"Макао Патака")
 #define BDT NSLocalizedStringFromTable(@"BDT",@"ItcCalcCurenciesTable", @"Бангладешская Така")
 #define MDL NSLocalizedStringFromTable(@"MDL",@"ItcCalcCurenciesTable", @"Молдавский Лей")
 #define VEF NSLocalizedStringFromTable(@"VEF",@"ItcCalcCurenciesTable", @"Венесуэльский Боливар")
 #define GEL NSLocalizedStringFromTable(@"GEL",@"ItcCalcCurenciesTable", @"Грузинский Лари")
 #define ISK NSLocalizedStringFromTable(@"ISK",@"ItcCalcCurenciesTable", @"Исландская Крона")
 #define BYR NSLocalizedStringFromTable(@"BYR",@"ItcCalcCurenciesTable", @"Белорусский Рубль")
 #define THB NSLocalizedStringFromTable(@"THB",@"ItcCalcCurenciesTable", @"Тайландский Бат")
 #define MXV NSLocalizedStringFromTable(@"MXV",@"ItcCalcCurenciesTable", @"Мексиканский Унидад De Заворот")
 #define TND NSLocalizedStringFromTable(@"TND",@"ItcCalcCurenciesTable", @"Тунисский Динар")
 #define JMD NSLocalizedStringFromTable(@"JMD",@"ItcCalcCurenciesTable", @"Ямайский Доллар")
 #define DKK NSLocalizedStringFromTable(@"DKK",@"ItcCalcCurenciesTable", @"Датская Крона")
 #define SRD NSLocalizedStringFromTable(@"SRD",@"ItcCalcCurenciesTable", @"Суринамский Доллар")
 #define BWP NSLocalizedStringFromTable(@"BWP",@"ItcCalcCurenciesTable", @"Ботсвана Пула")
 #define NOK NSLocalizedStringFromTable(@"NOK",@"ItcCalcCurenciesTable", @"Норвежская Крона")
 #define MUR NSLocalizedStringFromTable(@"MUR",@"ItcCalcCurenciesTable", @"Маврикийская Рупия")
 #define AZN NSLocalizedStringFromTable(@"AZN",@"ItcCalcCurenciesTable", @"Азербаиджанский Манат")
 #define INR NSLocalizedStringFromTable(@"INR",@"ItcCalcCurenciesTable", @"Индийская Рупия")
 #define MGA NSLocalizedStringFromTable(@"MGA",@"ItcCalcCurenciesTable", @"Малагасийской Ариари")
 #define CAD NSLocalizedStringFromTable(@"CAD",@"ItcCalcCurenciesTable", @"Канадский Доллар")
 #define XAF NSLocalizedStringFromTable(@"XAF",@"ItcCalcCurenciesTable", @"Центрально-африканский Франк ")
 #define LBP NSLocalizedStringFromTable(@"LBP",@"ItcCalcCurenciesTable", @"Ливанский Фунт")
 #define IDR NSLocalizedStringFromTable(@"IDR",@"ItcCalcCurenciesTable", @"Индонезийская Рупия")
 #define IEP NSLocalizedStringFromTable(@"IEP",@"ItcCalcCurenciesTable", @"Ирландский Фунт")
 #define AUD NSLocalizedStringFromTable(@"AUD",@"ItcCalcCurenciesTable", @"Австралийский Доллар")
 #define MMK NSLocalizedStringFromTable(@"MMK",@"ItcCalcCurenciesTable", @"Мьянманский Кьят")
 #define LYD NSLocalizedStringFromTable(@"LYD",@"ItcCalcCurenciesTable", @"Ливийский Динар")
 #define ZAR NSLocalizedStringFromTable(@"ZAR",@"ItcCalcCurenciesTable", @"Южноафриканский Рэнд")
 #define IQD NSLocalizedStringFromTable(@"IQD",@"ItcCalcCurenciesTable", @"Иракский Динар")
 #define XPF NSLocalizedStringFromTable(@"XPF",@"ItcCalcCurenciesTable", @"Французский Тихоокеанский Франк")
 #define TJS NSLocalizedStringFromTable(@"TJS",@"ItcCalcCurenciesTable", @"Таджикский Сомони")
 #define CUP NSLocalizedStringFromTable(@"CUP",@"ItcCalcCurenciesTable", @"Кубинское Песо")
 #define UGX NSLocalizedStringFromTable(@"UGX",@"ItcCalcCurenciesTable", @"Угандийский Шиллинг")
 #define NGN NSLocalizedStringFromTable(@"NGN",@"ItcCalcCurenciesTable", @"Нигерийское Найра")
 #define PGK NSLocalizedStringFromTable(@"PGK",@"ItcCalcCurenciesTable", @"Папуа-Новая Гвинея Кина")
 #define TOP NSLocalizedStringFromTable(@"TOP",@"ItcCalcCurenciesTable", @"Тонганская Паанга")
 #define KES NSLocalizedStringFromTable(@"KES",@"ItcCalcCurenciesTable", @"Кенийский Шиллинг")
 #define TMT NSLocalizedStringFromTable(@"TMT",@"ItcCalcCurenciesTable", @"Туркменский манат")
 #define CRC NSLocalizedStringFromTable(@"CRC",@"ItcCalcCurenciesTable", @"Костариканский Колон")
 #define MZN NSLocalizedStringFromTable(@"MZN",@"ItcCalcCurenciesTable", @"Мозамбикский Метикал")
 #define SYP NSLocalizedStringFromTable(@"SYP",@"ItcCalcCurenciesTable", @"Сирийский Фунт")
 #define ANG NSLocalizedStringFromTable(@"ANG",@"ItcCalcCurenciesTable", @"Нидерланды Антильские острова Гульден")
 #define ZMW NSLocalizedStringFromTable(@"ZMW",@"ItcCalcCurenciesTable", @"Замбийская Квача")
 #define BRL NSLocalizedStringFromTable(@"BRL",@"ItcCalcCurenciesTable", @"Бразильский Реал")
 #define BSD NSLocalizedStringFromTable(@"BSD",@"ItcCalcCurenciesTable", @"Багамский Доллар")
 #define NIO NSLocalizedStringFromTable(@"NIO",@"ItcCalcCurenciesTable", @"Никарагуанский Кордоба")
 #define GNF NSLocalizedStringFromTable(@"GNF",@"ItcCalcCurenciesTable", @"Гинейский Франк")
 #define BMD NSLocalizedStringFromTable(@"BMD",@"ItcCalcCurenciesTable", @"Бермудский Доллар")
 #define SLL NSLocalizedStringFromTable(@"SLL",@"ItcCalcCurenciesTable", @"Сьерра-Леонейская Леоне")
 #define MKD NSLocalizedStringFromTable(@"MKD",@"ItcCalcCurenciesTable", @"Македонский Динар")
 #define BIF NSLocalizedStringFromTable(@"BIF",@"ItcCalcCurenciesTable", @"Бурундийский Франк")
 #define LAK NSLocalizedStringFromTable(@"LAK",@"ItcCalcCurenciesTable", @"Лаосский Кип")
 #define BHD NSLocalizedStringFromTable(@"BHD",@"ItcCalcCurenciesTable", @"Бахрейнский Динар")
 #define SHP NSLocalizedStringFromTable(@"SHP",@"ItcCalcCurenciesTable", @"Фунт Святой Елены")
 #define BGN NSLocalizedStringFromTable(@"BGN",@"ItcCalcCurenciesTable", @"Болгарский Лев")
 #define SGD NSLocalizedStringFromTable(@"SGD",@"ItcCalcCurenciesTable", @"Сингапурский Доллар")
 #define CNY NSLocalizedStringFromTable(@"CNY",@"ItcCalcCurenciesTable", @"Китайского Юань")
 #define EUR NSLocalizedStringFromTable(@"EUR",@"ItcCalcCurenciesTable", @"Евро")
 #define TTD NSLocalizedStringFromTable(@"TTD",@"ItcCalcCurenciesTable", @"Тринидада и Тобаго Доллар")
 #define SCR NSLocalizedStringFromTable(@"SCR",@"ItcCalcCurenciesTable", @"Сейшельская Рупия")
 #define BBD NSLocalizedStringFromTable(@"BBD",@"ItcCalcCurenciesTable", @"Барбадосский Доллар")
 #define SBD NSLocalizedStringFromTable(@"SBD",@"ItcCalcCurenciesTable", @"Соломоновы Острова Доллар")
 #define MAD NSLocalizedStringFromTable(@"MAD",@"ItcCalcCurenciesTable", @"Марокканский Дирхам")
 #define GTQ NSLocalizedStringFromTable(@"GTQ",@"ItcCalcCurenciesTable", @"Гватемальский Кетсаль")
 #define MWK NSLocalizedStringFromTable(@"MWK",@"ItcCalcCurenciesTable", @"Малавийская Квача")
 #define PKR NSLocalizedStringFromTable(@"PKR",@"ItcCalcCurenciesTable", @"Пакистанская Рупия")
 #define PEN NSLocalizedStringFromTable(@"PEN",@"ItcCalcCurenciesTable", @"Перуанский Соль")
 #define AED NSLocalizedStringFromTable(@"AED",@"ItcCalcCurenciesTable", @"ОАЭ Дихрам")
 #define LVL NSLocalizedStringFromTable(@"LVL",@"ItcCalcCurenciesTable", @"Латвийский Лат")
 #define UAH NSLocalizedStringFromTable(@"UAH",@"ItcCalcCurenciesTable", @"Украинская Гривна")
 #define LRD NSLocalizedStringFromTable(@"LRD",@"ItcCalcCurenciesTable", @"Либерийский Доллар")
 #define LSL NSLocalizedStringFromTable(@"LSL",@"ItcCalcCurenciesTable", @"Лесотовская Лоти")
 #define SEK NSLocalizedStringFromTable(@"SEK",@"ItcCalcCurenciesTable", @"Шведская Крона")
 #define RON NSLocalizedStringFromTable(@"RON",@"ItcCalcCurenciesTable", @"Румынский Лей")
 #define XOF NSLocalizedStringFromTable(@"XOF",@"ItcCalcCurenciesTable", @"Колумбийское Песо")
 #define CDF NSLocalizedStringFromTable(@"CDF",@"ItcCalcCurenciesTable", @"Конголезский Франк")
 #define USD NSLocalizedStringFromTable(@"USD",@"ItcCalcCurenciesTable", @"Американский Доллар")
 #define TZS NSLocalizedStringFromTable(@"TZS",@"ItcCalcCurenciesTable", @"Танзанийский Шиллинг")
 #define NPR NSLocalizedStringFromTable(@"NPR",@"ItcCalcCurenciesTable", @"Непальская Рупия")
 #define GHS NSLocalizedStringFromTable(@"GHS",@"ItcCalcCurenciesTable", @"Ганский Седи")
 #define ZWL NSLocalizedStringFromTable(@"ZWL",@"ItcCalcCurenciesTable", @"Зимбабвийский Доллар")
 #define SOS NSLocalizedStringFromTable(@"SOS",@"ItcCalcCurenciesTable", @"Сомалийский Шиллинг")
 #define DZD NSLocalizedStringFromTable(@"DZD",@"ItcCalcCurenciesTable", @"Алжирский Динар")
 #define LKR NSLocalizedStringFromTable(@"LKR",@"ItcCalcCurenciesTable", @"Шри-Ланкийская Рупия")
 #define FKP NSLocalizedStringFromTable(@"FKP",@"ItcCalcCurenciesTable", @"Фунт Фолклендских островов")
 #define JPY NSLocalizedStringFromTable(@"JPY",@"ItcCalcCurenciesTable", @"Японская Иена")
 #define CHF NSLocalizedStringFromTable(@"CHF",@"ItcCalcCurenciesTable", @"Швейцарский Франк")
 #define KYD NSLocalizedStringFromTable(@"KYD",@"ItcCalcCurenciesTable", @"Кайманские острова Доллар")
 #define CLP NSLocalizedStringFromTable(@"CLP",@"ItcCalcCurenciesTable", @"Чилийское Песо")
 #define IRR NSLocalizedStringFromTable(@"IRR",@"ItcCalcCurenciesTable", @"Иранский риал")
 #define AFN NSLocalizedStringFromTable(@"AFN",@"ItcCalcCurenciesTable", @"Афганское Афгани")
 #define DJF NSLocalizedStringFromTable(@"DJF",@"ItcCalcCurenciesTable", @"Джибутийский франк")
 #define SVC NSLocalizedStringFromTable(@"SVC",@"ItcCalcCurenciesTable", @"Сальвадорский Колон")
 #define PLN NSLocalizedStringFromTable(@"PLN",@"ItcCalcCurenciesTable", @"Польский Злотый")
 #define PYG NSLocalizedStringFromTable(@"PYG",@"ItcCalcCurenciesTable", @"Парагвайский Гуарани")
 #define ERN NSLocalizedStringFromTable(@"ERN",@"ItcCalcCurenciesTable", @"Эритрейская Накфа")
 #define ETB NSLocalizedStringFromTable(@"ETB",@"ItcCalcCurenciesTable", @"Эфиопский Быр")
 #define ILS NSLocalizedStringFromTable(@"ILS",@"ItcCalcCurenciesTable", @"Израильский Шекель")
 #define TWD NSLocalizedStringFromTable(@"TWD",@"ItcCalcCurenciesTable", @"Тайваньский Доллар")
 #define KPW NSLocalizedStringFromTable(@"KPW",@"ItcCalcCurenciesTable", @"Северокорейская Вона")
 #define GIP NSLocalizedStringFromTable(@"GIP",@"ItcCalcCurenciesTable", @"Гибралтарский Фунт")
 #define SIT NSLocalizedStringFromTable(@"SIT",@"ItcCalcCurenciesTable", @"Словенский Толар")
 #define BND NSLocalizedStringFromTable(@"BND",@"ItcCalcCurenciesTable", @"Брунейский Доллар")
 #define HNL NSLocalizedStringFromTable(@"HNL",@"ItcCalcCurenciesTable", @"Гондурасская Лемпира")
 #define CZK NSLocalizedStringFromTable(@"CZK",@"ItcCalcCurenciesTable", @"Чешская Крона")
 #define HUF NSLocalizedStringFromTable(@"HUF",@"ItcCalcCurenciesTable", @"Венгерский Форинт")
 #define BZD NSLocalizedStringFromTable(@"BZD",@"ItcCalcCurenciesTable", @"Белизский Доллар")
 #define JOD NSLocalizedStringFromTable(@"JOD",@"ItcCalcCurenciesTable", @"Иорданский Динар")
 #define RWF NSLocalizedStringFromTable(@"RWF",@"ItcCalcCurenciesTable", @"Руандский Франк")
 #define LTL NSLocalizedStringFromTable(@"LTL",@"ItcCalcCurenciesTable", @"Литовский Лит")
 #define RUB NSLocalizedStringFromTable(@"RUB",@"ItcCalcCurenciesTable", @"Российский Рубль")
 #define RSD NSLocalizedStringFromTable(@"RSD",@"ItcCalcCurenciesTable", @"Сербский Динар")
 #define WST NSLocalizedStringFromTable(@"WST",@"ItcCalcCurenciesTable", @"Самоанский Тала")
 #define PAB NSLocalizedStringFromTable(@"PAB",@"ItcCalcCurenciesTable", @"Панамская Бальбоа")
 #define NAD NSLocalizedStringFromTable(@"NAD",@"ItcCalcCurenciesTable", @"Намибимйский Доллар")
 #define DOP NSLocalizedStringFromTable(@"DOP",@"ItcCalcCurenciesTable", @"Доминиканское Песо")
 #define ALL NSLocalizedStringFromTable(@"ALL",@"ItcCalcCurenciesTable", @"Албанский Лек")
 #define HTG NSLocalizedStringFromTable(@"HTG",@"ItcCalcCurenciesTable", @"Гаитянский Гурд")
 #define KMF NSLocalizedStringFromTable(@"KMF",@"ItcCalcCurenciesTable", @"Коморский Франк")
 #define AMD NSLocalizedStringFromTable(@"AMD",@"ItcCalcCurenciesTable", @"Армянский Драм")
 #define MRO NSLocalizedStringFromTable(@"MRO",@"ItcCalcCurenciesTable", @"Мавританская Угия")
 #define HRK NSLocalizedStringFromTable(@"HRK",@"ItcCalcCurenciesTable", @"Хорватская Куна")
 #define ECS NSLocalizedStringFromTable(@"ECS",@"ItcCalcCurenciesTable", @"Эквадорский Сукре")
 #define KHR NSLocalizedStringFromTable(@"KHR",@"ItcCalcCurenciesTable", @"Камбоджийский Риель")
 #define PHP NSLocalizedStringFromTable(@"PHP",@"ItcCalcCurenciesTable", @"Филиппинское Песо")
 #define CYP NSLocalizedStringFromTable(@"CYP",@"ItcCalcCurenciesTable", @"Кипрскый Фун")
 #define KWD NSLocalizedStringFromTable(@"KWD",@"ItcCalcCurenciesTable", @"Кувейтский Динар")
 #define XCD NSLocalizedStringFromTable(@"XCD",@"ItcCalcCurenciesTable", @"Карибский Доллар")
 #define CNH NSLocalizedStringFromTable(@"CNH",@"ItcCalcCurenciesTable", @"Китайский Оффшорный Юань")
 #define SDG NSLocalizedStringFromTable(@"SDG",@"ItcCalcCurenciesTable", @"Суданский Фунт")
 #define CLF NSLocalizedStringFromTable(@"CLF",@"ItcCalcCurenciesTable", @"Чилийский Унидад")
 #define KZT NSLocalizedStringFromTable(@"KZT",@"ItcCalcCurenciesTable", @"Казахский Тенге")
 #define TRY NSLocalizedStringFromTable(@"TRY",@"ItcCalcCurenciesTable", @"Турецкая Лира")
 #define NZD NSLocalizedStringFromTable(@"NZD",@"ItcCalcCurenciesTable", @"Новозеландский Доллар")
 #define FJD NSLocalizedStringFromTable(@"FJD",@"ItcCalcCurenciesTable", @"Фиджийский Доллар")
 #define BAM NSLocalizedStringFromTable(@"BAM",@"ItcCalcCurenciesTable", @"Боснийская Марка")
 #define BTN NSLocalizedStringFromTable(@"BTN",@"ItcCalcCurenciesTable", @"Бутанский Нгултрум")
 #define STD NSLocalizedStringFromTable(@"STD",@"ItcCalcCurenciesTable", @"Добра")
 #define VUV NSLocalizedStringFromTable(@"VUV",@"ItcCalcCurenciesTable", @"Вануатский Вату")
 #define MVR NSLocalizedStringFromTable(@"MVR",@"ItcCalcCurenciesTable", @"Мальдивская Руфия")
 #define AOA NSLocalizedStringFromTable(@"AOA",@"ItcCalcCurenciesTable", @"Ангольская Кванза")
 #define EGP NSLocalizedStringFromTable(@"EGP",@"ItcCalcCurenciesTable", @"Египетский Фунт")
 #define QAR NSLocalizedStringFromTable(@"QAR",@"ItcCalcCurenciesTable", @"Катарский Риал")
 #define OMR NSLocalizedStringFromTable(@"OMR",@"ItcCalcCurenciesTable", @"Оманский Риал")
 #define CVE NSLocalizedStringFromTable(@"CVE",@"ItcCalcCurenciesTable", @"Островов Зелёного Мыса Эскудо")
 #define KGS NSLocalizedStringFromTable(@"KGS",@"ItcCalcCurenciesTable", @"Киргизского Сома")
 #define MXN NSLocalizedStringFromTable(@"MXN",@"ItcCalcCurenciesTable", @"Мексиканское Песо")
 #define MYR NSLocalizedStringFromTable(@"MYR",@"ItcCalcCurenciesTable", @"Малайзийский Ринггит")
 #define GYD NSLocalizedStringFromTable(@"GYD",@"ItcCalcCurenciesTable", @"Гайанский Доллар")
 #define SZL NSLocalizedStringFromTable(@"SZL",@"ItcCalcCurenciesTable", @"Свазилендский Лилангени")
 #define YER NSLocalizedStringFromTable(@"YER",@"ItcCalcCurenciesTable", @"Йеменский Риал")
 #define SAR NSLocalizedStringFromTable(@"SAR",@"ItcCalcCurenciesTable", @"Саудовский Риял")
 #define UYU NSLocalizedStringFromTable(@"UYU",@"ItcCalcCurenciesTable", @"Уругвайское Песо")
 #define GBP NSLocalizedStringFromTable(@"GBP",@"ItcCalcCurenciesTable", @"Британский Фунт")
 #define UZS NSLocalizedStringFromTable(@"UZS",@"ItcCalcCurenciesTable", @"узбекский Сум")
 #define GMD NSLocalizedStringFromTable(@"GMD",@"ItcCalcCurenciesTable", @"Гамбийские Даласи")
 #define AWG NSLocalizedStringFromTable(@"AWG",@"ItcCalcCurenciesTable", @"Арубанский флорин")
 #define MNT NSLocalizedStringFromTable(@"MNT",@"ItcCalcCurenciesTable", @"Монгольский Тугрик")
 #define HKD NSLocalizedStringFromTable(@"HKD",@"ItcCalcCurenciesTable", @"Гонконгский Доллар")
 #define ARS NSLocalizedStringFromTable(@"ARS",@"ItcCalcCurenciesTable", @"Аргентинское Песо")

/*

#define KRW NSLocalizedStringFromTable(@"Южнокорейский",@"ItcCalcCurenciesTable", @"Южнокорейский")
#define VND NSLocalizedStringFromTable(@"Вьетнамский",@"ItcCalcCurenciesTable", @"Вьетнамский")
#define BOB NSLocalizedStringFromTable(@"Боливийский",@"ItcCalcCurenciesTable", @"Боливийский")
#define MOP NSLocalizedStringFromTable(@"Макао",@"ItcCalcCurenciesTable", @"Макао")
#define BDT NSLocalizedStringFromTable(@"Бангладешская",@"ItcCalcCurenciesTable", @"Бангладешская")
#define MDL NSLocalizedStringFromTable(@"Молдавский",@"ItcCalcCurenciesTable", @"Молдавский")
#define VEF NSLocalizedStringFromTable(@"Венесуэльский",@"ItcCalcCurenciesTable", @"Венесуэльский")
#define GEL NSLocalizedStringFromTable(@"Грузинский",@"ItcCalcCurenciesTable", @"Грузинский")
#define ISK NSLocalizedStringFromTable(@"Исландская",@"ItcCalcCurenciesTable", @"Исландская")
#define BYR NSLocalizedStringFromTable(@"Белорусский",@"ItcCalcCurenciesTable", @"Белорусский")
#define THB NSLocalizedStringFromTable(@"Тайландский",@"ItcCalcCurenciesTable", @"Тайландский")
#define MXV NSLocalizedStringFromTable(@"Мексиканский",@"ItcCalcCurenciesTable", @"Мексиканский")
#define TND NSLocalizedStringFromTable(@"Тунисский",@"ItcCalcCurenciesTable", @"Тунисский")
#define JMD NSLocalizedStringFromTable(@"Ямайский",@"ItcCalcCurenciesTable", @"Ямайский")
#define DKK NSLocalizedStringFromTable(@"Датская",@"ItcCalcCurenciesTable", @"Датская")
#define SRD NSLocalizedStringFromTable(@"Суринамский",@"ItcCalcCurenciesTable", @"Суринамский")
#define BWP NSLocalizedStringFromTable(@"Ботсвана",@"ItcCalcCurenciesTable", @"Ботсвана")
#define NOK NSLocalizedStringFromTable(@"Норвежская",@"ItcCalcCurenciesTable", @"Норвежская")
#define MUR NSLocalizedStringFromTable(@"Маврикийская",@"ItcCalcCurenciesTable", @"Маврикийская")
#define AZN NSLocalizedStringFromTable(@"Азербаиджанский",@"ItcCalcCurenciesTable", @"Азербаиджанский")
#define INR NSLocalizedStringFromTable(@"Индийская",@"ItcCalcCurenciesTable", @"Индийская")
#define MGA NSLocalizedStringFromTable(@"Малагасийской",@"ItcCalcCurenciesTable", @"Малагасийской")
#define CAD NSLocalizedStringFromTable(@"Канадский",@"ItcCalcCurenciesTable", @"Канадский")
#define XAF NSLocalizedStringFromTable(@"Центрально-африканский",@"ItcCalcCurenciesTable", @"Центрально-африканский")
#define LBP NSLocalizedStringFromTable(@"Ливанский",@"ItcCalcCurenciesTable", @"Ливанский")
#define IDR NSLocalizedStringFromTable(@"Индонезийская",@"ItcCalcCurenciesTable", @"Индонезийская")
#define IEP NSLocalizedStringFromTable(@"Ирландский",@"ItcCalcCurenciesTable", @"Ирландский")
#define AUD NSLocalizedStringFromTable(@"Австралийский",@"ItcCalcCurenciesTable", @"Австралийский")
#define MMK NSLocalizedStringFromTable(@"Мьянманский",@"ItcCalcCurenciesTable", @"Мьянманский")
#define LYD NSLocalizedStringFromTable(@"Ливийский",@"ItcCalcCurenciesTable", @"Ливийский")
#define ZAR NSLocalizedStringFromTable(@"Южноафриканский",@"ItcCalcCurenciesTable", @"Южноафриканский")
#define IQD NSLocalizedStringFromTable(@"Иракский",@"ItcCalcCurenciesTable", @"Иракский")
#define XPF NSLocalizedStringFromTable(@"Французский Тихоокеанский",@"ItcCalcCurenciesTable", @"Французский Тихоокеанский")
#define TJS NSLocalizedStringFromTable(@"Таджикский",@"ItcCalcCurenciesTable", @"Таджикский")
#define CUP NSLocalizedStringFromTable(@"Кубинское",@"ItcCalcCurenciesTable", @"Кубинское")
#define UGX NSLocalizedStringFromTable(@"Угандийский",@"ItcCalcCurenciesTable", @"Угандийский")
#define NGN NSLocalizedStringFromTable(@"Нигерийское",@"ItcCalcCurenciesTable", @"Нигерийское")
#define PGK NSLocalizedStringFromTable(@"Папуа-Новая Гвинея",@"ItcCalcCurenciesTable", @"Папуа-Новая Гвинея")
#define TOP NSLocalizedStringFromTable(@"Тонганская",@"ItcCalcCurenciesTable", @"Тонганская")
#define KES NSLocalizedStringFromTable(@"Кенийский",@"ItcCalcCurenciesTable", @"Кенийский")
#define TMT NSLocalizedStringFromTable(@"Туркменский",@"ItcCalcCurenciesTable", @"Туркменский")
#define CRC NSLocalizedStringFromTable(@"Костариканский",@"ItcCalcCurenciesTable", @"Костариканский")
#define MZN NSLocalizedStringFromTable(@"Мозамбикский",@"ItcCalcCurenciesTable", @"Мозамбикский")
#define SYP NSLocalizedStringFromTable(@"Сирийский",@"ItcCalcCurenciesTable", @"Сирийский")
#define ANG NSLocalizedStringFromTable(@"Антильские острова",@"ItcCalcCurenciesTable", @"Антильские острова")
#define ZMW NSLocalizedStringFromTable(@"Замбийская",@"ItcCalcCurenciesTable", @"Замбийская")
#define BRL NSLocalizedStringFromTable(@"Бразильский",@"ItcCalcCurenciesTable", @"Бразильский")
#define BSD NSLocalizedStringFromTable(@"Багамский",@"ItcCalcCurenciesTable", @"Багамский")
#define NIO NSLocalizedStringFromTable(@"Никарагуанский",@"ItcCalcCurenciesTable", @"Никарагуанский")
#define GNF NSLocalizedStringFromTable(@"Гвинейский",@"ItcCalcCurenciesTable", @"Гвинейский")
#define BMD NSLocalizedStringFromTable(@"Бермудский",@"ItcCalcCurenciesTable", @"Бермудский")
#define SLL NSLocalizedStringFromTable(@"Сьерра-Леонейская",@"ItcCalcCurenciesTable", @"Сьерра-Леонейская")
#define MKD NSLocalizedStringFromTable(@"Македонский",@"ItcCalcCurenciesTable", @"Македонский")
#define BIF NSLocalizedStringFromTable(@"Бурундийский",@"ItcCalcCurenciesTable", @"Бурундийский")
#define LAK NSLocalizedStringFromTable(@"Лаосский",@"ItcCalcCurenciesTable", @"Лаосский")
#define BHD NSLocalizedStringFromTable(@"Бахрейнский",@"ItcCalcCurenciesTable", @"Бахрейнский")
#define SHP NSLocalizedStringFromTable(@"Остров Святой Елены",@"ItcCalcCurenciesTable", @"Остров Святой Елены")
#define BGN NSLocalizedStringFromTable(@"Болгарский",@"ItcCalcCurenciesTable", @"Болгарский")
#define SGD NSLocalizedStringFromTable(@"Сингапурский",@"ItcCalcCurenciesTable", @"Сингапурский")
#define CNY NSLocalizedStringFromTable(@"Китайский",@"ItcCalcCurenciesTable", @"Китайский")
#define EUR NSLocalizedStringFromTable(@"Евро",@"ItcCalcCurenciesTable", @"Евро")
#define TTD NSLocalizedStringFromTable(@"Тринидада и Тобаго",@"ItcCalcCurenciesTable", @"Тринидада и Тобаго")
#define SCR NSLocalizedStringFromTable(@"Сейшельская",@"ItcCalcCurenciesTable", @"Сейшельская")
#define BBD NSLocalizedStringFromTable(@"Барбадосский",@"ItcCalcCurenciesTable", @"Барбадосский")
#define SBD NSLocalizedStringFromTable(@"Соломоновы Острова",@"ItcCalcCurenciesTable", @"Соломоновы Острова")
#define MAD NSLocalizedStringFromTable(@"Марокканский",@"ItcCalcCurenciesTable", @"Марокканский")
#define GTQ NSLocalizedStringFromTable(@"Гватемальский",@"ItcCalcCurenciesTable", @"Гватемальский")
#define MWK NSLocalizedStringFromTable(@"Малавийская",@"ItcCalcCurenciesTable", @"Малавийская")
#define PKR NSLocalizedStringFromTable(@"Пакистанская",@"ItcCalcCurenciesTable", @"Пакистанская")
#define PEN NSLocalizedStringFromTable(@"Перуанский",@"ItcCalcCurenciesTable", @"Перуанский")
#define AED NSLocalizedStringFromTable(@"ОАЭ",@"ItcCalcCurenciesTable", @"ОАЭ")
#define LVL NSLocalizedStringFromTable(@"Латвийский",@"ItcCalcCurenciesTable", @"Латвийский")
#define UAH NSLocalizedStringFromTable(@"Украинская",@"ItcCalcCurenciesTable", @"Украинская")
#define LRD NSLocalizedStringFromTable(@"Либерийский",@"ItcCalcCurenciesTable", @"Либерийский")
#define LSL NSLocalizedStringFromTable(@"Лесотовская",@"ItcCalcCurenciesTable", @"Лесотовская")
#define SEK NSLocalizedStringFromTable(@"Шведская",@"ItcCalcCurenciesTable", @"Шведская")
#define RON NSLocalizedStringFromTable(@"Румынский",@"ItcCalcCurenciesTable", @"Румынский")
#define XOF NSLocalizedStringFromTable(@"Колумбийское",@"ItcCalcCurenciesTable", @"Колумбийское")
#define CDF NSLocalizedStringFromTable(@"Конголезский",@"ItcCalcCurenciesTable", @"Конголезский")
#define USD NSLocalizedStringFromTable(@"Американский",@"ItcCalcCurenciesTable", @"Американский")
#define TZS NSLocalizedStringFromTable(@"Танзанийский",@"ItcCalcCurenciesTable", @"Танзанийский")
#define NPR NSLocalizedStringFromTable(@"Непальская",@"ItcCalcCurenciesTable", @"Непальская")
#define GHS NSLocalizedStringFromTable(@"Ганский",@"ItcCalcCurenciesTable", @"Ганский")
#define ZWL NSLocalizedStringFromTable(@"Зимбабвийский",@"ItcCalcCurenciesTable", @"Зимбабвийский")
#define SOS NSLocalizedStringFromTable(@"Сомалийский",@"ItcCalcCurenciesTable", @"Сомалийский")
#define DZD NSLocalizedStringFromTable(@"Алжирский",@"ItcCalcCurenciesTable", @"Алжирский")
#define LKR NSLocalizedStringFromTable(@"Шри-Ланкийская",@"ItcCalcCurenciesTable", @"Шри-Ланкийская")
#define FKP NSLocalizedStringFromTable(@"Фолклендский",@"ItcCalcCurenciesTable", @"Фолклендский")
#define JPY NSLocalizedStringFromTable(@"Японская",@"ItcCalcCurenciesTable", @"Японская")
#define CHF NSLocalizedStringFromTable(@"Швейцарский",@"ItcCalcCurenciesTable", @"Швейцарский")
#define KYD NSLocalizedStringFromTable(@"Каймановы острова",@"ItcCalcCurenciesTable", @"Каймановы острова")
#define CLP NSLocalizedStringFromTable(@"Чилийское",@"ItcCalcCurenciesTable", @"Чилийское")
#define IRR NSLocalizedStringFromTable(@"Иранский",@"ItcCalcCurenciesTable", @"Иранский")
#define AFN NSLocalizedStringFromTable(@"Афганское",@"ItcCalcCurenciesTable", @"Афганское")
#define DJF NSLocalizedStringFromTable(@"Южнокорейская",@"ItcCalcCurenciesTable", @"Джибутийский")
#define SVC NSLocalizedStringFromTable(@"Сальвадорский",@"ItcCalcCurenciesTable", @"Сальвадорский")
#define PLN NSLocalizedStringFromTable(@"Польский",@"ItcCalcCurenciesTable", @"Польский")
#define PYG NSLocalizedStringFromTable(@"Парагвайский",@"ItcCalcCurenciesTable", @"Парагвайский")
#define ERN NSLocalizedStringFromTable(@"Эритрейская",@"ItcCalcCurenciesTable", @"Эритрейская")
#define ETB NSLocalizedStringFromTable(@"Эфиопский",@"ItcCalcCurenciesTable", @"Эфиопский")
#define ILS NSLocalizedStringFromTable(@"Израильский",@"ItcCalcCurenciesTable", @"Израильский")
#define TWD NSLocalizedStringFromTable(@"Тайваньский",@"ItcCalcCurenciesTable", @"Тайваньский")
#define KPW NSLocalizedStringFromTable(@"Северокорейская",@"ItcCalcCurenciesTable", @"Северокорейская")
#define GIP NSLocalizedStringFromTable(@"Гибралтарский",@"ItcCalcCurenciesTable", @"Гибралтарский")
#define SIT NSLocalizedStringFromTable(@"Словенский",@"ItcCalcCurenciesTable", @"Словенский")
#define BND NSLocalizedStringFromTable(@"Брунейский",@"ItcCalcCurenciesTable", @"Брунейский")
#define HNL NSLocalizedStringFromTable(@"Гондурасская",@"ItcCalcCurenciesTable", @"Гондурасская")
#define CZK NSLocalizedStringFromTable(@"Чешская",@"ItcCalcCurenciesTable", @"Чешская")
#define HUF NSLocalizedStringFromTable(@"Венгерский",@"ItcCalcCurenciesTable", @"Венгерский")
#define BZD NSLocalizedStringFromTable(@"Белизский",@"ItcCalcCurenciesTable", @"Белизский")
#define JOD NSLocalizedStringFromTable(@"Иорданский",@"ItcCalcCurenciesTable", @"Иорданский")
#define RWF NSLocalizedStringFromTable(@"Руандский",@"ItcCalcCurenciesTable", @"Руандский")
#define LTL NSLocalizedStringFromTable(@"Литовский",@"ItcCalcCurenciesTable", @"Литовский")
#define RUB NSLocalizedStringFromTable(@"Российский",@"ItcCalcCurenciesTable", @"Российский")
#define RSD NSLocalizedStringFromTable(@"Сербский",@"ItcCalcCurenciesTable", @"Сербский")
#define WST NSLocalizedStringFromTable(@"Самоанский",@"ItcCalcCurenciesTable", @"Самоанский")
#define PAB NSLocalizedStringFromTable(@"Панамская",@"ItcCalcCurenciesTable", @"Панамская")
#define NAD NSLocalizedStringFromTable(@"Намибимйский",@"ItcCalcCurenciesTable", @"Намибимйский")
#define DOP NSLocalizedStringFromTable(@"Доминиканское",@"ItcCalcCurenciesTable", @"Доминиканское")
#define ALL NSLocalizedStringFromTable(@"Албанский",@"ItcCalcCurenciesTable", @"Албанский")
#define HTG NSLocalizedStringFromTable(@"Гаитянский",@"ItcCalcCurenciesTable", @"Гаитянский")
#define KMF NSLocalizedStringFromTable(@"Коморский",@"ItcCalcCurenciesTable", @"Коморский")
#define AMD NSLocalizedStringFromTable(@"Армянский",@"ItcCalcCurenciesTable", @"Армянский")
#define MRO NSLocalizedStringFromTable(@"Мавританская",@"ItcCalcCurenciesTable", @"Мавританская")
#define HRK NSLocalizedStringFromTable(@"Хорватская",@"ItcCalcCurenciesTable", @"Хорватская")
#define ECS NSLocalizedStringFromTable(@"Эквадорский",@"ItcCalcCurenciesTable", @"Эквадорский")
#define KHR NSLocalizedStringFromTable(@"Камбоджийский",@"ItcCalcCurenciesTable", @"Камбоджийский")
#define PHP NSLocalizedStringFromTable(@"Филиппинское",@"ItcCalcCurenciesTable", @"Филиппинское")
#define CYP NSLocalizedStringFromTable(@"Кипрский",@"ItcCalcCurenciesTable", @"Кипрский")
#define KWD NSLocalizedStringFromTable(@"Кувейтский",@"ItcCalcCurenciesTable", @"Кувейтский")
#define XCD NSLocalizedStringFromTable(@"Карибский",@"ItcCalcCurenciesTable", @"Карибский")
#define CNH NSLocalizedStringFromTable(@"Китайский оффшорный",@"ItcCalcCurenciesTable", @"Китайский оффшорный")
#define SDG NSLocalizedStringFromTable(@"Суданский",@"ItcCalcCurenciesTable", @"Суданский")
#define CLF NSLocalizedStringFromTable(@"Чилийский",@"ItcCalcCurenciesTable", @"Чилийский")
#define KZT NSLocalizedStringFromTable(@"Казахский",@"ItcCalcCurenciesTable", @"Казахский")
#define TRY NSLocalizedStringFromTable(@"Турецкая",@"ItcCalcCurenciesTable", @"Турецкая")
#define NZD NSLocalizedStringFromTable(@"Новозеландский",@"ItcCalcCurenciesTable", @"Новозеландский")
#define FJD NSLocalizedStringFromTable(@"Фиджийский",@"ItcCalcCurenciesTable", @"Фиджийский")
#define BAM NSLocalizedStringFromTable(@"Боснийская",@"ItcCalcCurenciesTable", @"Боснийская")
#define BTN NSLocalizedStringFromTable(@"Бутанский",@"ItcCalcCurenciesTable", @"Бутанский")
#define STD NSLocalizedStringFromTable(@"Добра",@"ItcCalcCurenciesTable", @"Добра")
#define VUV NSLocalizedStringFromTable(@"Вануатский",@"ItcCalcCurenciesTable", @"Вануатский")
#define MVR NSLocalizedStringFromTable(@"Мальдивская",@"ItcCalcCurenciesTable", @"Мальдивская")
#define AOA NSLocalizedStringFromTable(@"Ангольская",@"ItcCalcCurenciesTable", @"Ангольская")
#define EGP NSLocalizedStringFromTable(@"Египетский",@"ItcCalcCurenciesTable", @"Египетский")
#define QAR NSLocalizedStringFromTable(@"Катарский",@"ItcCalcCurenciesTable", @"Катарский")
#define OMR NSLocalizedStringFromTable(@"Оманский",@"ItcCalcCurenciesTable", @"Оманский")
#define CVE NSLocalizedStringFromTable(@"Кабо-Верде",@"ItcCalcCurenciesTable", @"Кабо-Верде")
#define KGS NSLocalizedStringFromTable(@"Киргизский",@"ItcCalcCurenciesTable", @"Киргизский")
#define MXN NSLocalizedStringFromTable(@"Мексиканское",@"ItcCalcCurenciesTable", @"Мексиканское")
#define MYR NSLocalizedStringFromTable(@"Малайзийский",@"ItcCalcCurenciesTable", @"Малайзийский")
#define GYD NSLocalizedStringFromTable(@"Гайанский",@"ItcCalcCurenciesTable", @"Гайанский")
#define SZL NSLocalizedStringFromTable(@"Свазилендский",@"ItcCalcCurenciesTable", @"Свазилендский")
#define YER NSLocalizedStringFromTable(@"Йеменский",@"ItcCalcCurenciesTable", @"Йеменский")
#define SAR NSLocalizedStringFromTable(@"Саудовский",@"ItcCalcCurenciesTable", @"Саудовский")
#define UYU NSLocalizedStringFromTable(@"Уругвайское",@"ItcCalcCurenciesTable", @"Уругвайское")
#define GBP NSLocalizedStringFromTable(@"Британский",@"ItcCalcCurenciesTable", @"Британский")
#define UZS NSLocalizedStringFromTable(@"Узбекский",@"ItcCalcCurenciesTable", @"Узбекский")
#define GMD NSLocalizedStringFromTable(@"Гамбийские",@"ItcCalcCurenciesTable", @"Гамбийские")
#define AWG NSLocalizedStringFromTable(@"Арубанский",@"ItcCalcCurenciesTable", @"Арубанский")
#define MNT NSLocalizedStringFromTable(@"Монгольский",@"ItcCalcCurenciesTable", @"Монгольский")
#define HKD NSLocalizedStringFromTable(@"Гонконгский",@"ItcCalcCurenciesTable", @"Гонконгский")
#define ARS NSLocalizedStringFromTable(@"Аргентинское",@"ItcCalcCurenciesTable", @"Аргентинское")
 */

//create array object for each currenkcy
-(NSArray*) currDescript:(NSString*)symbol flag:(NSString*)flag
{
    return [[NSArray alloc] initWithObjects:symbol,flag, nil];
}

-(NSDictionary*) currensyWithDescription {
    if(!_currensyWithDescription){
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [self currDescript:@"KRW" flag:@"🇰🇷"],KRW ,
                          [self currDescript:@"VND" flag:@"🇻🇳"],VND,
                          [self currDescript:@"BOB" flag:@"🇧🇴"],BOB,
                          [self currDescript:@"MOP" flag:@"🇲🇴"],MOP,
                          [self currDescript:@"BDT" flag:@"🇧🇩"],BDT,
                          [self currDescript:@"MDL" flag:@"🇲🇩"],MDL,
                          [self currDescript:@"VEF" flag:@"🇻🇪"],VEF,
                          [self currDescript:@"GEL" flag:@"🇬🇪"],GEL,
                          [self currDescript:@"ISK" flag:@"🇮🇸"],ISK,
                          [self currDescript:@"BYR" flag:@"🇧🇾"],BYR,
                          [self currDescript:@"THB" flag:@"🇹🇭"],THB,
                          [self currDescript:@"MXV" flag:@"🇲🇽"],MXV,
                          [self currDescript:@"TND" flag:@"🇹🇳"],TND,
                          [self currDescript:@"JMD" flag:@"🇯🇲"],JMD,
                          [self currDescript:@"DKK" flag:@"🇩🇰"],DKK,
                          [self currDescript:@"SRD" flag:@"🇸🇷"],SRD,
                          [self currDescript:@"BWP" flag:@"🇧🇼"],BWP,
                          [self currDescript:@"NOK" flag:@"🇳🇴"],NOK,
                          [self currDescript:@"MUR" flag:@"🇲🇺"],MUR,
                          [self currDescript:@"AZN" flag:@"🇦🇿"],AZN,
                          [self currDescript:@"INR" flag:@"🇮🇳"],INR,
                          [self currDescript:@"MGA" flag:@"🇲🇬"],MGA,
                          [self currDescript:@"CAD" flag:@"🇨🇦"],CAD,
                          [self currDescript:@"XAF" flag:@"🇨🇫"],XAF,
                          [self currDescript:@"LBP" flag:@"🇱🇧"],LBP,
                          [self currDescript:@"IDR" flag:@"🇮🇩"],IDR,
                          [self currDescript:@"IEP" flag:@"🇮🇪"],IEP,
                          [self currDescript:@"AUD" flag:@"🇦🇺"],AUD,
                          [self currDescript:@"MMK" flag:@"🇲🇲"],MMK,
                          [self currDescript:@"LYD" flag:@"🇱🇾"],LYD,
                          [self currDescript:@"ZAR" flag:@"🇿🇦"],ZAR,
                          [self currDescript:@"IQD" flag:@"🇮🇶"],IQD,
                          [self currDescript:@"XPF" flag:@"🇵🇫"],XPF,
                          [self currDescript:@"TJS" flag:@"🇹🇯"],TJS,
                          [self currDescript:@"CUP" flag:@"🇨🇺"],CUP,
                          [self currDescript:@"UGX" flag:@"🇺🇬"],UGX,
                          [self currDescript:@"NGN" flag:@"🇳🇬"],NGN,
                          [self currDescript:@"PGK" flag:@"🇵🇬"],PGK,
                          [self currDescript:@"TOP" flag:@"🇹🇴"],TOP,
                          [self currDescript:@"KES" flag:@"🇰🇪"],KES,
                          [self currDescript:@"TMT" flag:@"🇹🇲"],TMT,
                          [self currDescript:@"CRC" flag:@"🇨🇷"],CRC,
                          [self currDescript:@"MZN" flag:@"🇲🇿"],MZN,
                          [self currDescript:@"SYP" flag:@"🇸🇾"],SYP,
                          [self currDescript:@"ANG" flag:@"🇨🇼"],ANG,
                          [self currDescript:@"ZMW" flag:@"🇿🇲"],ZMW,
                          [self currDescript:@"BRL" flag:@"🇧🇷"],BRL,
                          [self currDescript:@"BSD" flag:@"🇧🇸"],BSD,
                          [self currDescript:@"NIO" flag:@"🇳🇮"],NIO,
                          [self currDescript:@"GNF" flag:@"🇬🇳"],GNF,
                          [self currDescript:@"BMD" flag:@"🇧🇲"],BMD,
                          [self currDescript:@"SLL" flag:@"🇸🇱"],SLL,
                          [self currDescript:@"MKD" flag:@"🇲🇰"],MKD,
                          [self currDescript:@"BIF" flag:@"🇧🇮"],BIF,
                          [self currDescript:@"LAK" flag:@"🇱🇦"],LAK,
                          [self currDescript:@"BHD" flag:@"🇧🇭"],BHD,
                          [self currDescript:@"SHP" flag:@"🇸🇭"],SHP,
                          [self currDescript:@"BGN" flag:@"🇧🇬"],BGN,
                          [self currDescript:@"SGD" flag:@"🇸🇬"],SGD,
                          [self currDescript:@"CNY" flag:@"🇨🇳"],CNY,//China third
                          [self currDescript:@"EUR" flag:@"🇪🇺"],EUR,//Euro first
                          [self currDescript:@"TTD" flag:@"🇹🇹"],TTD,
                          [self currDescript:@"SCR" flag:@"🇸🇨"],SCR,
                          [self currDescript:@"BBD" flag:@"🇧🇧"],BBD,
                          [self currDescript:@"SBD" flag:@"🇸🇧"],SBD,
                          [self currDescript:@"MAD" flag:@"🇲🇦"],MAD,
                          [self currDescript:@"GTQ" flag:@"🇬🇹"],GTQ,
                          [self currDescript:@"MWK" flag:@"🇲🇼"],MWK,
                          [self currDescript:@"PKR" flag:@"🇵🇰"],PKR,
                          [self currDescript:@"PEN" flag:@"🇵🇪"],PEN,
                          [self currDescript:@"AED" flag:@"🇦🇪"],AED,
                          [self currDescript:@"LVL" flag:@"🇱🇻"],LVL,
                          [self currDescript:@"UAH" flag:@"🇺🇦"],UAH,
                          [self currDescript:@"LRD" flag:@"🇱🇷"],LRD,
                          [self currDescript:@"LSL" flag:@"🇱🇸"],LSL,
                          [self currDescript:@"SEK" flag:@"🇸🇪"],SEK,
                          [self currDescript:@"RON" flag:@"🇷🇴"],RON,
                          [self currDescript:@"XOF" flag:@"🇨🇴"],XOF,
                          [self currDescript:@"CDF" flag:@"🇨🇩"],CDF,
                          [self currDescript:@"USD" flag:@"🇺🇸"],USD,//USD second
                          [self currDescript:@"TZS" flag:@"🇹🇿"],TZS,
                          [self currDescript:@"NPR" flag:@"🇳🇵"],NPR,
                          [self currDescript:@"GHS" flag:@"🇬🇭"],GHS,
                          [self currDescript:@"ZWL" flag:@"🇿🇼"],ZWL,
                          [self currDescript:@"SOS" flag:@"🇸🇴"],SOS,
                          [self currDescript:@"DZD" flag:@"🇩🇿"],DZD,
                          [self currDescript:@"LKR" flag:@"🇱🇰"],LKR,
                          [self currDescript:@"FKP" flag:@"🇫🇰"],FKP,
                          [self currDescript:@"JPY" flag:@"🇯🇵"],JPY,//Yena five
                          [self currDescript:@"CHF" flag:@"🇨🇭"],CHF,
                          [self currDescript:@"KYD" flag:@"🇰🇾"],KYD,
                          [self currDescript:@"CLP" flag:@"🇨🇱"],CLP,
                          [self currDescript:@"IRR" flag:@"🇮🇷"],IRR,
                          [self currDescript:@"AFN" flag:@"🇦🇫"],AFN,
                          [self currDescript:@"DJF" flag:@"🇩🇯"],DJF,
                          [self currDescript:@"SVC" flag:@"🇸🇻"],SVC,
                          [self currDescript:@"PLN" flag:@"🇵🇱"],PLN,
                          [self currDescript:@"PYG" flag:@"🇵🇾"],PYG,
                          [self currDescript:@"ERN" flag:@"🇪🇷"],ERN,
                          [self currDescript:@"ETB" flag:@"🇪🇹"],ETB,
                          [self currDescript:@"ILS" flag:@"🇮🇱"],ILS,
                          [self currDescript:@"TWD" flag:@"🇹🇼"],TWD,
                          [self currDescript:@"KPW" flag:@"🇰🇵"],KPW,
                          [self currDescript:@"GIP" flag:@"🇬🇮"],GIP,
                          [self currDescript:@"SIT" flag:@"🇸🇮"],SIT,
                          [self currDescript:@"BND" flag:@"🇧🇳"],BND,
                          [self currDescript:@"HNL" flag:@"🇭🇳"],HNL,
                          [self currDescript:@"CZK" flag:@"🇨🇿"],CZK,
                          [self currDescript:@"HUF" flag:@"🇭🇺"],HUF,
                          [self currDescript:@"JOD" flag:@"🇯🇴"],JOD,
                          [self currDescript:@"RWF" flag:@"🇷🇼"],RWF,
                          [self currDescript:@"LTL" flag:@"🇱🇹"],LTL,
                          [self currDescript:@"RUB" flag:@"🇷🇺"],RUB,
                          [self currDescript:@"RSD" flag:@"🇷🇸"],RSD,
                          [self currDescript:@"WST" flag:@"🇼🇸"],WST,
                          [self currDescript:@"PAB" flag:@"🇵🇦"],PAB,
                          [self currDescript:@"NAD" flag:@"🇳🇦"],NAD,
                          [self currDescript:@"DOP" flag:@"🇩🇴"],DOP,
                          [self currDescript:@"ALL" flag:@"🇦🇱"],ALL,
                          [self currDescript:@"HTG" flag:@"🇭🇹"],HTG,
                          [self currDescript:@"KMF" flag:@"🇰🇲"],KMF,
                          [self currDescript:@"AMD" flag:@"🇦🇲"],AMD,
                          [self currDescript:@"MRO" flag:@"🇲🇷"],MRO,
                          [self currDescript:@"HRK" flag:@"🇭🇷"],HRK,
                          [self currDescript:@"KHR" flag:@"🇰🇭"],KHR,
                          [self currDescript:@"USD" flag:@"🇵🇭"],PHP,
                          [self currDescript:@"PHP" flag:@"🇨🇾"],CYP,
                          [self currDescript:@"KWD" flag:@"🇰🇼"],KWD,
                          [self currDescript:@"XCD" flag:@"🇩🇲"],XCD,
                          [self currDescript:@"CNH" flag:@"🇨🇳"],CNH,
                          [self currDescript:@"SDG" flag:@"🇸🇩"],SDG,
                          [self currDescript:@"CLF" flag:@"🇨🇱"],CLF,
                          [self currDescript:@"KZT" flag:@"🇰🇿"],KZT,
                          [self currDescript:@"TRY" flag:@"🇹🇷"],TRY,
                          [self currDescript:@"NZD" flag:@"🇳🇿"],NZD,
                          [self currDescript:@"FJD" flag:@"🇫🇯"],FJD,
                          [self currDescript:@"BAM" flag:@"🇧🇦"],BAM,
                          [self currDescript:@"BTN" flag:@"🇧🇹"],BTN,
                          [self currDescript:@"STD" flag:@"🇸🇹"],STD,
                          [self currDescript:@"VUV" flag:@"🇻🇺"],VUV,
                          [self currDescript:@"MVR" flag:@"🇲🇻"],MVR,
                          [self currDescript:@"AOA" flag:@"🇦🇴"],AOA,
                          [self currDescript:@"EGP" flag:@"🇪🇬"],EGP,
                          [self currDescript:@"QAR" flag:@"🇶🇦"],QAR,
                          [self currDescript:@"OMR" flag:@"🇴🇲"],OMR,
                          [self currDescript:@"CVE" flag:@"🇨🇻"],CVE,
                          [self currDescript:@"KGS" flag:@"🇰🇬"],KGS,
                          [self currDescript:@"MXN" flag:@"🇲🇽"],MXN,
                          [self currDescript:@"MYR" flag:@"🇲🇾"],MYR,
                          [self currDescript:@"GYD" flag:@"🇭🇹"],GYD,
                          [self currDescript:@"SZL" flag:@"🇸🇿"],SZL,
                          [self currDescript:@"YER" flag:@"🇾🇪"],YER,
                          [self currDescript:@"SAR" flag:@"🇸🇦"],SAR,
                          [self currDescript:@"UYU" flag:@"🇺🇾"],UYU,
                          [self currDescript:@"GBP" flag:@"🇬🇧"],GBP,//Britisch phound four
                          [self currDescript:@"UZS" flag:@"🇺🇿"],UZS,
                          [self currDescript:@"GMD" flag:@"🇬🇲"],GMD,
                          [self currDescript:@"AWG" flag:@"🇦🇼"],AWG,
                          [self currDescript:@"MNT" flag:@"🇲🇳"],MNT,
                          [self currDescript:@"HKD" flag:@"🇭🇰"],HKD,
                          [self currDescript:@"ARS" flag:@"🇦🇷"],ARS, nil];
    _currensyWithDescription = dict;
    }
    return _currensyWithDescription;
}

+(NSArray*) initialMainCurensies
{
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    USD,
                    EUR,
                    GBP,
                    CHF,
                    JPY,
                    CNY,nil];
    return arr;
}

+(NSArray*)initialCurrensiesList
{
    NSArray *arr = [[NSArray alloc] initWithObjects:
        USD,
        EUR,
        GBP,
        CHF,
        JPY,
        CNY,
        AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT
    ,BGN,BHD,BIF,BMD,BND,BOB,BRL,BSD,BTN,BWP,BYR,CAD,CDF//,CLF
    ,CLP,CRC,CUP,CVE,CYP,CZK,DJF,DKK,DOP,DZD,EGP,ERN,ETB,FJD
    ,FKP,GEL,GHS,GIP,GMD,GNF,GTQ,GYD,HKD,HNL,HRK,HTG,HUF,IDR
    ,IEP,ILS,INR,IQD,IRR,ISK,JMD,JOD,KES,KGS,KHR,KMF,KPW,KRW
    ,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,/*LTL,LVL,*/LYD,MAD,MDL,MGA
    ,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN
    ,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PLN,PYG,QAR,RSD,RUB
    ,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SIT,SLL,SOS,SRD,STD,SVC
    ,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,UYU
    ,UZS,VEF,VND,VUV,WST,XAF,XCD,XOF,XPF,YER,ZAR,ZMW,ZWL
    , nil];
    
   // NSLog(@"Currency %@",arr[3]);
    
    return arr;
    
}

+(NSSet*)initialCurrensiesSet
{
    NSSet *set = [[NSSet alloc] initWithObjects:
                     AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT
                    ,BGN,BHD,BIF,BMD,BND,BOB,BRL,BSD,BTN,BWP,BYR,CAD,CDF//,CLF
                    ,CLP,CRC,CUP,CVE,CYP,CZK,DJF,DKK,DOP,DZD,EGP,ERN,ETB,FJD
                    ,FKP,GEL,GHS,GIP,GMD,GNF,GTQ,GYD,HKD,HNL,HRK,HTG,HUF,IDR
                    ,IEP,ILS,INR,IQD,IRR,ISK,JMD,JOD,KES,KGS,KHR,KMF,KPW,KRW
                    ,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,/*LTL,LVL,*/LYD,MAD,MDL,MGA
                    ,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN
                    ,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PLN,PYG,QAR,RSD,RUB
                    ,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SIT,SLL,SOS,SRD,STD,SVC
                    ,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,UYU
                    ,UZS,VEF,VND,VUV,WST,XAF,XCD,XOF,XPF,YER,ZAR,ZMW,ZWL
                    , nil];
    
    //NSLog(@"Currency %@",set[3]);
    
    return set;
    
}
-(id)init {
    self = [super init];
    if(self){
        NSDictionary *test = self.currensyWithDescription;
    }
    return self;
    
}


@end
