Перем юТест;

Перем мАдресРесурса; // URL ресурса (хоста) httpbin.org для тестирования запросов

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

	юТест = ЮнитТестирование;

	ВсеТесты = Новый Массив;

	ВсеТесты.Добавить("ТестДолжен_ПроверитьОтключениеПеренаправления");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьАвтоматическоеПеренаправление");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьАвтоматическуюРаспаковкуGZip");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьАвторизациюПрокси");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьСвойствоПортHttpСоединения");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьСвойстваПользовательПарольHttpСоединения");

	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомПолучить_GET");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомЗаписать_PUT");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомОтправитьДляОбработки_POST");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомИзменить_PATCH");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомУдалить_DELETE");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапросМетодомПолучитьЗаголовки_HEAD");

	ВсеТесты.Добавить("ТестДолжен_ПроверитьМетод_ВызватьHTTPМетод_СНесуществующимМетодомHTTP");
	ВсеТесты.Добавить("ТестДолженПроверитьЧтоКонструкторЗапросаВозвращаетКорректноеИсключение");

	Возврат ВсеТесты;
КонецФункции

Процедура ТестДолжен_ПроверитьАвтоматическуюРаспаковкуGZip() Экспорт

	Запрос = Новый HttpЗапрос("/gzip");

	Соединение = Новый HttpСоединение(мАдресРесурса);

	Ответ = Соединение.Получить(Запрос);
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьРавенство(Истина, JsonВОбъект(ТелоОтвета)["gzipped"]);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтключениеПеренаправления() Экспорт

	Запрос = Новый HttpЗапрос("/redirect-to?url=http%3A%2F%2Fhttpbin.org%2Fget&status_code=307");

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Соединение.РазрешитьАвтоматическоеПеренаправление = Ложь;
	Ответ = Соединение.Получить(Запрос);
	
	юТест.ПроверитьРавенство(307, Ответ.КодСостояния);
	юТест.ПроверитьРавенство("http://httpbin.org/get", Ответ.Заголовки["Location"]);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьАвтоматическоеПеренаправление() Экспорт

	Запрос = Новый HttpЗапрос("/redirect-to?url=http%3A%2F%2Fhttpbin.org%2Fget&status_code=307");

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.Получить(Запрос);
	
	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьАвторизациюПрокси() Экспорт

	Прокси = Новый ИнтернетПрокси();

	Прокси.Установить("http","proxy.server.lan", 8080, "someuser", "somepassword");
	
	юТест.ПроверитьРавенство("someuser",Прокси.Пользователь("http"));
	юТест.ПроверитьРавенство("somepassword",Прокси.Пароль("http"));

КонецПроцедуры

Процедура ТестДолжен_ПроверитьСвойствоПортHttpСоединения() Экспорт

	Соединение = Новый HttpСоединение("http://localhost:8080");

	юТест.ПроверитьРавенство(8080, Соединение.Порт);

	Соединение = Новый HttpСоединение("http://localhost", 8080);

	юТест.ПроверитьРавенство(8080, Соединение.Порт);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьСвойстваПользовательПарольHttpСоединения() Экспорт

	Соединение = Новый HttpСоединение("http://localhost");

КонецПроцедуры


Процедура ТестДолжен_ПроверитьЗапросМетодомПолучить_GET() Экспорт

	Запрос = Новый HttpЗапрос("/get?p1=v1&p2=v2");

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.Получить(Запрос);
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);

	юТест.ПроверитьВхождение(ТелоОтвета, """p1"": ""v1""");
	юТест.ПроверитьВхождение(ТелоОтвета, """p2"": ""v2""");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомЗаписать_PUT() Экспорт

	ТестовыеДанные = "Hello from 1Script!";

	Запрос = Новый HttpЗапрос("/put");
	Запрос.УстановитьТелоИзСтроки(ТестовыеДанные);

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.Записать(Запрос);

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьВхождение(Ответ.ПолучитьТелоКакСтроку(), ТестовыеДанные);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомОтправитьДляОбработки_POST() Экспорт

	ТестовыеДанные = "Hello from 1Script!";

	Запрос = Новый HttpЗапрос("/post");
	Запрос.УстановитьТелоИзСтроки(ТестовыеДанные);

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьВхождение(Ответ.ПолучитьТелоКакСтроку(), ТестовыеДанные);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомОтправитьДляОбработки_POST_РезультатВФайл() Экспорт

	ВремФайл = Новый Файл(ПолучитьИмяВременногоФайла());

	ТестовыеДанные = "Hello from 1Script!";

	Запрос = Новый HttpЗапрос("/post");
	Запрос.УстановитьТелоИзСтроки(ТестовыеДанные);

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьИстину(ВремФайл.Существует());

	СодержимоеФайла = Новый ЧтениеТекста(ВремФайл.ПолныйПуть);
	юТест.ПроверитьВхождение(СодержимоеФайла.Прочитать(), ТестовыеДанные);

	УдалитьФайлы(ВремФайл.ПолныйПуть);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомИзменить_PATCH() Экспорт

	ТестовыеДанные = "Hello from 1Script!";

	Запрос = Новый HttpЗапрос("/patch");
	Запрос.УстановитьТелоИзСтроки(ТестовыеДанные);

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.Изменить(Запрос);

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьВхождение(Ответ.ПолучитьТелоКакСтроку(), ТестовыеДанные);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомПолучитьЗаголовки_HEAD() Экспорт

	Запрос = Новый HttpЗапрос("/html"); // простая HTML-страница

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.ПолучитьЗаголовки(Запрос);

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);

	// Не должны получить контент, т.к. это HEAD-запрос. 
	// Сервис к сожалению возвращает метку BOM в начале ответа и получается, что строка не пустая,
	// проверяем поэтому вот таким топорным, но зато работающим способом.
	юТест.ПроверитьРавенство(0, СтрНайти(Ответ.ПолучитьТелоКакСтроку(), "<html>"));

	// А заголовки - должны получить как в случае получение методом GET.
	юТест.ПроверитьВхождение(Ответ.Заголовки.Получить("Content-Type"), "text/html");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапросМетодомУдалить_DELETE() Экспорт

	Запрос = Новый HttpЗапрос("/delete?p=v");

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.Удалить(Запрос);
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();

	юТест.ПроверитьРавенство(200, Ответ.КодСостояния);
	юТест.ПроверитьВхождение(ТелоОтвета, """p"": ""v""");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьМетод_ВызватьHTTPМетод_СНесуществующимМетодомHTTP() Экспорт

	Запрос = Новый HttpЗапрос("/get");

	Соединение = Новый HttpСоединение(мАдресРесурса);
	Ответ = Соединение.ВызватьHTTPМетод("POST", Запрос);

	юТест.ПроверитьРавенство(405, Ответ.КодСостояния);
	юТест.ПроверитьВхождение(Ответ.ПолучитьТелоКакСтроку(), "Method Not Allowed");

КонецПроцедуры

Процедура ТестДолженПроверитьЧтоКонструкторЗапросаВозвращаетКорректноеИсключение() Экспорт

	Попытка
		Запрос = Новый HTTPЗапрос("/url", Неопределено);
	Исключение
		Описание = ИнформацияОбОшибке().Описание;
		юТест.ПроверитьРавенство("Неверный тип аргумента", Описание);
		Возврат;
	КонецПопытки;
	
	ВызватьИсключение "Не было выдано исключение!";

КонецПроцедуры

Функция JsonВОбъект(Json)
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Json);
	
	Объект = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Возврат Объект;

КонецФункции

///////////////////////////////////////////////////////////////////
/// ИНИЦИАЛИЗАЦИЯ
///////////////////////////////////////////////////////////////////

мАдресРесурса = "httpbin.org";
