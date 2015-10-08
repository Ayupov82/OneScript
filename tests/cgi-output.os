﻿Перем юТест;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_ПолучитьПутьКOscript");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьРазделениеСтрокПриВыводе");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапроса");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапросаСтрокой");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапросаСтрокойВAnsi");
	
	Возврат ВсеТесты;
	
КонецФункции

Процедура ТестДолжен_ПолучитьПутьКOscript() Экспорт
	
	Путь = Новый Файл(ПутьОСкрипт());
	
	юТест.ПроверитьИстину(Путь.Существует());
	
КонецПроцедуры

Функция СтрокаЗапускаОСкрипта(Знач ПутьКИсполняемомуМодулю)

	СИ = Новый СистемнаяИнформация;
	Если Найти(СИ.ВерсияОС, "Windows") > 0 Тогда
		Возврат ПутьКИсполняемомуМодулю;
	КонецЕсли;

	Возврат "mono """ + ПутьКИСполняемомуМодулю + """";

КонецФункции

Функция УникальнаяЧастьИмени(Знач Расширение = "")
	Возврат СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-","") + Расширение;
КонецФункции

Функция ПолучитьВыводДляСкрипта(Знач Путь, Знач ТекстСкрипта, Знач ДанныеЗапроса = "", Знач КодировкаДанных = Неопределено)
	
	Перем ИмяФайла, СтрокаЗапуска;

	ИмяФайлаОСкрипта = КаталогВременныхФайлов() + УникальнаяЧастьИмени(".os");
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаОСкрипта);
	ЗаписьТекста.Записать(ТекстСкрипта);
	ЗаписьТекста.Закрыть();

	Если Не ПустаяСтрока(ДанныеЗапроса) Тогда

		Если КодировкаДанных = Неопределено Тогда
			КодировкаДанных = КодировкаТекста.UTF8NoBOM;
		КонецЕсли;

		ИмяФайлаДанныхЗапроса = КаталогВременныхФайлов() + "/" + УникальнаяЧастьИмени(".txt");
		ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаДанныхЗапроса, КодировкаДанных);
		ЗаписьТекста.Записать(ДанныеЗапроса);
		ЗаписьТекста.Закрыть();

		Ф = Новый Файл(ИмяФайлаДанныхЗапроса);
		РазмерДанныхЗапроса = Строка(Ф.Размер()); // тут надо Формат

	КонецЕсли;
	
	ИмяФайлаВывода = КаталогВременныхФайлов() + УникальнаяЧастьИмени(".txt");

	СИ = Новый СистемнаяИнформация;
	Если Найти(СИ.ВерсияОС, "Windows") > 0 Тогда
	
		ИмяФайлаСистемногоСкриптаЗапуска = КаталогВременныхФайлов() + УникальнаяЧастьИмени(".cmd");
		ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаСистемногоСкриптаЗапуска);
		ЗаписьТекста.ЗаписатьСтроку("@echo off");
		ЗаписьТекста.ЗаписатьСтроку("set SCRIPT_FILENAME=" + ИмяФайлаОСкрипта);
		ЗаписьТекста.ЗаписатьСтроку("set CONTENT_LENGTH=" + РазмерДанныхЗапроса);
		ЗаписьТекста.ЗаписатьСтроку(СтрокаЗапускаОСкрипта(Путь) + " -cgi"
			+ ?(ПустаяСтрока(ДанныеЗапроса), "", " < " + ИмяФайлаДанныхЗапроса)
			+ " > " + ИмяФайлаВывода
		);
		ЗаписьТекста.Закрыть();

		СтрокаЗапуска = ИмяФайлаСистемногоСкриптаЗапуска;

	Иначе
	
		ИмяФайлаСистемногоСкриптаЗапуска = КаталогВременныхФайлов() + УникальнаяЧастьИмени(".sh");
		ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаСистемногоСкриптаЗапуска);
		ЗаписьТекста.ЗаписатьСтроку("bash -s <<<CALLEOF");
		ЗаписьТекста.ЗаписатьСтроку("SCRIPT_FILENAME=" + ИмяФайлаОСкрипта + " " 
			+ ?(ПустаяСтрока(ДанныеЗапроса), "", " CONTENT_LENGTH=" + РазмерДанныхЗапроса) + " "
			+ СтрокаЗапускаОСкрипта(Путь) + " -cgi"
			+ ?(ПустаяСтрока(ДанныеЗапроса), "", " < " + ИмяФайлаДанныхЗапроса)
			+ " > " + ИмяФайлаВывода
		);
		ЗаписьТекста.ЗаписатьСтроку("CALLEOF");
		ЗаписьТекста.Закрыть();

		СтрокаЗапуска = "bash " + ИмяФайлаСистемногоСкриптаЗапуска;

	КонецЕсли;
	
	Процесс = СоздатьПроцесс(СтрокаЗапуска,,Истина);
	Процесс.Запустить();
	//Поток = Процесс.ПотокВывода;
	
	Приостановить(1000); // Костыль
	
	Текст = Новый ТекстовыйДокумент;
	Текст.Прочитать(ИмяФайлаВывода, КодировкаТекста.UTF8);
	
	Стр = НормализоватьПереводыСтрок(Текст.ПолучитьТекст());

	Возврат Стр;

КонецФункции

Процедура ТестДолжен_ПроверитьРазделениеСтрокПриВыводе() Экспорт
	
	Путь = ПутьОСкрипт();

	ОжидаемыеЗаголовки = 
		"Content-type: text/html
		|Content-encoding: utf-8
		|
		|"
	;
	
	ПроверкаПереводаСтрок = ПолучитьВыводДляСкрипта(Путь,
		"Сообщить(""Строка1""); Сообщить(""Строка2"");"
	);
	
	ОжидаемыйВывод = ОжидаемыеЗаголовки +
		"Строка1
		|Строка2
		|"
	;
	юТест.ПроверитьРавенство(ОжидаемыйВывод, ПроверкаПереводаСтрок);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапроса() Экспорт

	Путь = ПутьОСкрипт();

	ПроверочнаяСтрока = "ПроверочнаяСтрока
		|на несколько строк с невероятным символом " + Символ(12500)
	;
	Данные = ПолучитьВыводДляСкрипта(Путь,
		"ИмяФайла = ПолучитьИмяВременногоФайла(""txt"");
		|ВебЗапрос.ПолучитьТелоКакДвоичныеДанные().Записать(ИмяФайла);
		|Текст = Новый ТекстовыйДокумент;
		|Текст.Прочитать(ИмяФайла, ""UTF-8"");
		|Сообщить(Текст.ПолучитьТекст());
		|",
		ПроверочнаяСтрока
	);

	ОжидаемыеЗаголовки = 
		"Content-type: text/html
		|Content-encoding: utf-8
		|
		|"
	;

	ПроверочнаяСтрока = ОжидаемыеЗаголовки + ПроверочнаяСтрока;

	Данные = СокрЛП(Данные);
	ПроверочнаяСтрока = СокрЛП(ПроверочнаяСтрока);

	юТест.ПроверитьРавенство(Данные, ПроверочнаяСтрока);

КонецПроцедуры



Процедура ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапросаСтрокой() Экспорт

	Путь = ПутьОСкрипт();

	ПроверочнаяСтрока = "ПроверочнаяСтрока
		|на несколько строк с невероятным символом " + Символ(12500)
	;
	Данные = ПолучитьВыводДляСкрипта(Путь,
		"
		|Сообщить(ВебЗапрос.ПолучитьТелоКакСтроку());
		|",
		ПроверочнаяСтрока
	);

	ОжидаемыеЗаголовки = 
		"Content-type: text/html
		|Content-encoding: utf-8
		|
		|"
	;

	ПроверочнаяСтрока = ОжидаемыеЗаголовки + ПроверочнаяСтрока;

	Данные = СокрЛП(Данные);
	ПроверочнаяСтрока = СокрЛП(ПроверочнаяСтрока);

	юТест.ПроверитьРавенство(Данные, ПроверочнаяСтрока);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьПолучениеСырыхДанныхЗапросаСтрокойВAnsi() Экспорт

	Путь = ПутьОСкрипт();

	ПроверочнаяСтрока = "ПроверочнаяСтрока
		|на несколько строк без utf"
	;
	Данные = ПолучитьВыводДляСкрипта(Путь,
		"
		|Сообщить(ВебЗапрос.ПолучитьТелоКакСтроку(КодировкаТекста.Ansi));
		|",
		ПроверочнаяСтрока, КодировкаТекста.Ansi
	);

	ОжидаемыеЗаголовки = 
		"Content-type: text/html
		|Content-encoding: utf-8
		|
		|"
	;

	ПроверочнаяСтрока = ОжидаемыеЗаголовки + ПроверочнаяСтрока;

	Данные = СокрЛП(Данные);
	ПроверочнаяСтрока = СокрЛП(ПроверочнаяСтрока);

	юТест.ПроверитьРавенство(Данные, ПроверочнаяСтрока);

КонецПроцедуры

Функция ПутьОСкрипт()
	Возврат КаталогПрограммы() + "/oscript.exe";
КонецФункции

Функция НормализоватьПереводыСтрок(Знач ИсходнаяСтрока)
	Возврат СтрЗаменить(ИсходнаяСтрока, Символы.ВК, "");
КонецФункции

