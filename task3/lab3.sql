--Очистка от прошлых данных

TRUNCATE TABLE [company];

TRUNCATE TABLE [computer];

TRUNCATE TABLE [director_company];

TRUNCATE TABLE [installed_program];

TRUNCATE TABLE [program];

TRUNCATE TABLE [user];



-------------------------------------------------------------------------
				/* Оператор вставки INSERT */
-------------------------------------------------------------------------

--1. Без указания списка полей
--	INSERT INTO table_name VALUES (value1, value2, value3, ...);

INSERT INTO [user] VALUES('Ivanov', 'Georg', 'Ivanovich', '01.01.2001', 'mail@mail.ru', '+7 999-111-22-33');
INSERT INTO [director_company] VALUES('Smirnov', 'Dmitry', 'Ivanovich', '23.02.1976', '+7 800-555-35-35', 'nazvanie_mail@yandex.ru');
INSERT INTO [company] VALUES('Nazvanie', '1', '01.01.2010', '+7 888 345 32 12', 'login@mail.ru');
INSERT INTO [computer] VALUES('desktop-12313', 'Windows', '1', 'desktop');
INSERT INTO [program] VALUES('swap', '1', 'windows', '1');
INSERT INTO [installed_program] VALUES('1', '1', '01.01.2020', 'TRUE', '0');

--2. С указанием списка полей
--	INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);

INSERT INTO [user] 
	(surname, name, patronymic, date_of_birth, email, contact_number) 
VALUES 
	('Petrov', 'Ivan', 'Nicolaevich', '21.02.1980', 'yandex@gmail.com', '+7 999-432-12-34');

INSERT INTO [director_company]
	(surname, name, patronymic, date_of_birth, contact_number, email)
VALUES
	('Fadeev', 'Ilya', 'Romanovich', '01.01.2001', '+7 919-234-56-78', 'qwerty.mail.ru');

INSERT INTO [company]
	(name, id_director_company, date_of_establishment,	contact_number, email)
VALUES
	('EA', '2', '30.09.2010', '+7 333-222-11-00', 'yandex@mail.ru');

--3. С чтением значения из другой таблицы
--	INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;

INSERT INTO [user]
	(surname, name, patronymic, date_of_birth, contact_number, email) 
SELECT 
	surname, name, patronymic, date_of_birth, contact_number, email
FROM 
	[director_company];

-----------------------------------------------------------------------------
						--2. DELETE
-----------------------------------------------------------------------------

--1. Всех записей

DELETE [installed_program]
SELECT * FROM [installed_program]

--2. По условию
--	DELETE FROM table_name WHERE condition;

DELETE FROM [user] WHERE surname = 'Ivanov';

--3. Очистить таблицу
--	TRUNCATE

TRUNCATE TABLE [computer];
SELECT * FROM [computer];

TRUNCATE TABLE[user];
SELECT*FROM[user];

-------------------------------------------------------
-- Добавил значения в таблицы 
-------------------------------------------------------

INSERT INTO [user] VALUES('Ivanov', 'Georg', 'Ivanovich', '01.01.2001', 'mail@mail.ru', '+7 999-111-22-33');
INSERT INTO [user] VALUES('Petrov', 'Ivan', 'Nicolaevich', '21.02.1980', 'yandex@gmail.com', '+7 999-432-12-34');
INSERT INTO [computer] VALUES('desktop-12313', 'Windows', '1', 'desktop');
INSERT INTO [computer] VALUES('desktop-123222', 'Linux', '1', 'desktop');
INSERT INTO [installed_program] VALUES('1', '1', '01.01.2020', 'TRUE', '0');
INSERT INTO [director_company] VALUES('Smirnov', 'Dmitry', 'Ivanovich', '23.02.1976', '+7 800-555-35-35', 'nazvanie_mail@yandex.ru');
INSERT INTO [director_company]VALUES('Fadeev', 'Ilya', 'Romanovich', '01.01.2001', '+7 919-234-56-78', 'qwerty.mail.ru');
INSERT INTO [company] VALUES('Nazvanie', '1', '01.01.2010', '+7 888 345 32 12', 'login@mail.ru');
INSERT INTO [company]VALUES('EA', '2', '30.09.2010', '+7 333-222-11-00', 'yandex@mail.ru');
INSERT INTO [program] VALUES('swap', '1', 'windows', '1');

------------------------------------------------------------------
--                       3. UPDATE
------------------------------------------------------------------

--1. Всех записей
-- Если не задана консрукция WHERE, то изменяется весь столбец на указанное значение

UPDATE [user]
SET surname = 'Romanov' 
SELECT * FROM [user];

--2. По условию обновляя один атрибут
--		UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE [user] 
SET surname = 'Petrov'
WHERE
	name = 'Georg';
SELECT * FROM [user];

--3. По условию обновляя несколько атрибутов
--	UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE [user] 
SET surname = 'Ivanov',
	date_of_birth = '03.05.2002'
WHERE
	name = 'Ivan';

SELECT * FROM [user];

-------------------------------------------------------------------
--                          4. SELECT
-------------------------------------------------------------------

--1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)

SELECT surname, name FROM [user];

--2. Со всеми атрибутами (SELECT * FROM...)

SELECT * FROM [director_company]

--3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")

SELECT * FROM [user] WHERE name = 'Ivan';

-------------------------------------------------------
-- Добавил значения в таблицы user, computer, installed_program
-------------------------------------------------------

INSERT INTO [user] VALUES('Ivanov', 'Roman', 'Ivanovich', '01.01.2001', 'mail1@mail.ru', '+7 999-111-22-33');
INSERT INTO [user] VALUES('Romanov', 'Aleksander', 'Petrovich', '01.01.2004', 'mail2@mail.ru', '+7 999-111-22-34');
INSERT INTO [user] VALUES('Shumilov', 'Egor', 'Aleksandrovich', '01.01.2007', 'mail3@mail.ru', '+7 999-111-22-35');
-- Loginov, Kotenkov, Shumilov, 


-------------------------------------------------------------------
--                 5. SELECT ORDER BY + TOP (LIMIT)
-------------------------------------------------------------------

--  1. С сортировкой по возрастанию ASC + ограничение вывода количества записей

SELECT TOP(4) * FROM [user]
ORDER BY surname, name ASC 

--	2. С сортировкой по убыванию DESC

SELECT * FROM [user]
ORDER BY surname DESC 

 -- 3. С сортировкой по двум атрибутам + ограничение вывода количества записей

 SELECT TOP(1) * FROM [director_company]
ORDER BY surname, name ASC 

SELECT TOP(2) * FROM [user]
ORDER BY  name, surname ASC 

-- 4. С сортировкой по первому атрибуту, из списка извлекаемых
  
SELECT * FROM [user]
ORDER BY 1 

-------------------------------------------------------------------------------
--6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
--    Например, таблица авторов может содержать дату рождения автора.
--------------------------------------------------------------------------------

--1. WHERE по дате

SELECT * FROM [user] WHERE date_of_birth = '03.05.2002';

--2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
--       Для этого используется функция YEAR 

SELECT YEAR(date_of_birth), name  FROM [user] ;

---------------------------------------------------------------------------------
--				7. SELECT GROUP BY с функциями агрегации
------------------------------------------------------------------------------

INSERT INTO [user] VALUES('Loginov', 'Ivan', 'Nicolaevich', '21.02.1980', 'yandex@gmail.com', '+7 999-432-12-34');
INSERT INTO [user] VALUES('Vasilev', 'Dmitry', 'Nicolaevich', '21.02.1990', 'string@gmail.com', '+7 300-432-12-34');
INSERT INTO [user] VALUES('Vasilev', 'Oleg', 'Evgeneevich', '04.05.1995', 'string@gmail.com', '+7 300-432-12-34');
INSERT INTO [user] VALUES('Vasilev', 'Evgeniy', 'Vladimirov', '23.07.1998', 'string@gmail.com', '+7 300-432-12-34');
INSERT INTO [user] VALUES('Vasilev', 'Boris', 'Nicolaevich', '10.06.2000', 'string@gmail.com', '+7 300-432-12-34');


INSERT INTO [company] VALUES('GO!', '2', '01.01.2001', '+7 888 345 32 13', 'login1@mail.ru');
INSERT INTO [company] VALUES('Wargaming', '3', '01.01.2010', '+7 888 654 32 12', 'login2@mail.ru');
INSERT INTO [company] VALUES('Valve', '4', '01.01.2010', '+7 888 685 52 33', 'login3@mail.ru');

INSERT INTO [program] VALUES('swap', '2', 'windows', '1');
INSERT INTO [program] VALUES('swap', '3', 'windows', '1');
INSERT INTO [program] VALUES('swap', '4', 'windows', '1');
INSERT INTO [program] VALUES('tanki', '3', 'windows', '1');
INSERT INTO [program] VALUES('tanki', '4', 'windows', '1');
INSERT INTO [program] VALUES('replace', '2', 'windows', '1');

--1. MIN
SELECT surname, MIN(date_of_birth) AS [user]
FROM [user]
GROUP BY surname;

-- 2. MAX
SELECT surname, MAX(date_of_birth) AS [user]
FROM [user]
GROUP BY surname;

--3. AVG
SELECT name, AVG(id_company) AS [program]
FROM [program]
GROUP BY name;
 
--4 SUM
SELECT name, SUM(id_company) AS [program]
FROM [program]
GROUP BY name;

--5. COUNT
SELECT name, COUNT(id_company) AS [program]
FROM [program]
GROUP BY name;

------------------------------------------------------------------
--                8. SELECT GROUP BY + HAVING
------------------------------------------------------------------

SELECT name, COUNT(id_company) AS [program]
FROM [program]
GROUP BY name
HAVING COUNT(*) = 5;

SELECT name, COUNT(id_company) AS [program]
FROM [program]
GROUP BY name
HAVING COUNT(*) = 2;

INSERT INTO [user] VALUES('Karasev', 'Igor', 'Andreevich', '21.02.1980', 'string@gmail.com', '+7 300-432-12-34');

SELECT surname, MIN(date_of_birth) AS [user]
FROM [user]
GROUP BY surname
HAVING MIN(date_of_birth) = '21.02.1980';

SELECT name, SUM(id_company) AS [program]
FROM [program]
GROUP BY name
HAVING SUM(id_company) > 6;


------------------------------------------------------------------
--						9. SELECT JOIN
------------------------------------------------------------------

--1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов

SELECT [user].name, [director_company].name
FROM [user]
LEFT JOIN [director_company] ON [user].name = [director_company].name

-- 2. RIGHT JOIN. Получить такую же выборку, как и в 5.1

SELECT TOP(4) *
FROM [user]
RIGHT JOIN [director_company] ON [user].name = [director_company].name
ORDER BY [user].surname, [user].name ASC;

--3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
--выведет список установленных прграмм на комьютерах

SELECT [program].name, [program].software_requirement, [computer].name, [computer].operating_system
FROM [installed_program]
LEFT JOIN [program] ON [program].id_program = [installed_program].id_program
LEFT JOIN [computer] ON [computer].id_computer = [installed_program].id_computer
WHERE [program].id_program IS NOT NULL;


--4. FULL OUTER JOIN двух таблиц

SELECT *
FROM [user]
FULL OUTER JOIN [director_company] ON [user].name = [director_company].name;

------------------------------------------------------
--					10. Подзапросы
------------------------------------------------------

--1. Написать запрос с WHERE IN (подзапрос)
SELECT id_user, name, date_of_birth
FROM [user]
WHERE date_of_birth IN (
	SELECT date_of_birth FROM[director_company]
)

--2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...  

INSERT INTO [director_company] VALUES('Selivanov', 'Maksim', 'Vladimirovich', '23.02.1976', '+7 800-345-35-35', 'nazvanie_mail@yandex.ru');
INSERT INTO [director_company] VALUES('Naumov', 'Konstantin', 'Ivanovich', '23.02.1976', '+7 800-355-35-35', 'nazvanie_mail@yandex.ru');

SELECT name, id_director_company,
(
	SELECT MIN(date_of_establishment) AS [company]
	FROM [company]
)
FROM [company];





