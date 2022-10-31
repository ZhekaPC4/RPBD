/* Автор сия чуда света - Евгений Гроза студяга группы 3255
Задание plpgsql
работа велась на pgadmin */


--Таблица c изначальными данными

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name varchar(255) NOT NULL,
    surname varchar(255),
    birth_date DATE,
    growth real,
    weight real,
    eyes varchar(255),
    hair varchar(255)
);

INSERT INTO people (name, surname, birth_date, growth, weight, eyes, hair)
VALUES ('ivan', 'ivanov', '11.03.1989', 180.3, 81.6, 'brown', 'brown'),
('ivan', 'petrov', '08.14.1991', 190.3, 81.6, 'blue', 'brown'),
('alexei', 'orlov', '03.26.1995', 187.3, 89.2, 'blue', 'blond'),
('maria', 'orlova', '08.28.1995', 164.3, 47.2, 'brown', 'blond'),
('alexandra', 'orlova', '11.11.1995', 167.3, 48.2, 'brown', 'blond'),
('alexandr', 'petrov', '11.11.2003', 182.3, 78.2, 'brown', 'brown');


--Задания

--1. Выведите на экран любое сообщение
DO
$$
BEGIN
    RAISE INFO 'Randomnoe sooobshenie';
END
$$

--2. Выведите на экран текущую дату
DO
$$
BEGIN
    RAISE INFO 'Текущая дата %', CURRENT_DATE;
END
$$

--3. Создайте две числовые переменные и присвойте им значение. Выполните математические действия с этими числами и выведите результат на экран.
DO
$$
DECLARE
    a integer := 3;
    b integer := 7;
BEGIN
    RAISE INFO 'a = %', a; 
	RAISE INFO 'b = %', b; 
	RAISE INFO 'a + b = %', a + b; 
END
$$

--4. Написать программу двумя способами 1 - использование IF, 2 - использование CASE. Объявите числовую переменную и присвоейте ей значение. Если число равно 5 - выведите на экран "Отлично". 4 - "Хорошо". 3 - Удовлетворительно". 2 - "Неуд". В остальных случаях выведите на экран сообщение, что введённая оценка не верна.

DO
$$
DECLARE
    mark integer := 2;
    tempr varchar := 'Введённая оценка не верна';
BEGIN
    IF mark = 5 THEN
        tempr := 'Отлично';
    ELSIF mark = 4 THEN
        tempr := 'Хорошо';
    ELSIF mark = 3 THEN
        tempr := 'Удовлетворительно';
    ELSIF mark = 2 THEN
        tempr := 'Неуд';
    END IF;
    RAISE INFO '%', tempr;
END
$$


DO
$$
DECLARE
    mark integer := 6;
    tempr varchar(255);
BEGIN
    CASE mark
    WHEN 5 THEN
        tempr := 'Отлично';
	WHEN 4 THEN
        tempr := 'Хорошо';
	WHEN 3 THEN
        tempr := 'Удовлетворительно';
	WHEN 2 THEN
        tempr := 'Неуд';
	ELSE 
		 tempr := 'Введённая оценка не верна';
    END CASE;
    RAISE INFO '%', tempr;
END
$$

--5. Выведите все квадраты чисел от 20 до 30 3-мя разными способами (LOOP, WHILE, FOR).
DO
$$
DECLARE
    i integer := 20;
BEGIN
    LOOP
        EXIT WHEN i > 30;
        RAISE INFO 'Квадрат равен %', i * i;
	    i = i + 1;
    END LOOP;
END
$$

DO
$$
DECLARE
    i integer := 20;
BEGIN
    WHILE i <= 30 LOOP
        RAISE INFO 'Квадрат равен %', i * i;
	    i = i + 1;
    END LOOP;
END
$$

DO
$$
BEGIN
    FOR i IN 20..30 LOOP
        RAISE INFO 'Квадрат равен %', i * i;
	    i = i + 1;
    END LOOP;
END
$$

--6. Последовательность Коллатца. Берётся любое натуральное число. Если чётное - делим его на 2, если нечётное, то умножаем его на 3 и прибавляем 1. Такие действия выполняются до тех пор, пока не будет получена единица. Гипотеза заключается в том, что какое бы начальное число n не было выбрано, всегда получится 1 на каком-то шаге. Задания: написать функцию, входной параметр - начальное число, на выходе - количество чисел, пока не получим 1; написать процедуру, которая выводит все числа последовательности. Входной параметр - начальное число.

CREATE OR REPLACE FUNCTION Kollatz(n IN int) returns integer
LANGUAGE plpgsql
AS $$
Declare 
i integer := 0;
BEGIN
    WHILE n > 1 LOOP
	if n % 2 = 0 then
    	n = n / 2;
    else
        n = n * 3 + 1;
    END if;
        i = i + 1;
    END LOOP;
	Return i;
END
$$;

SELECT Kollatz(7);

--7. Числа Люка. Объявляем и присваиваем значение переменной - количество числе Люка. Вывести на экран последовательность чисел. Где L0 = 2, L1 = 1 ; Ln=Ln-1 + Ln-2 (сумма двух предыдущих чисел). Задания: написать фунцию, входной параметр - количество чисел, на выходе - последнее число (Например: входной 5, 2 1 3 4 7 - на выходе число 7); написать процедуру, которая выводит все числа последовательности. Входной параметр - количество чисел.

CREATE OR REPLACE FUNCTION lucas1(count integer) RETURNS integer ARRAY
LANGUAGE plpgsql
AS $$
DECLARE
    arr integer[];
BEGIN
    arr[0] = 2;
    arr[1] = 1;
	FOR i IN 2..count-1 LOOP
	    arr[i] = arr[i - 1] + arr[i - 2];
	END LOOP;
    RETURN arr;
END
$$;

SELECT lucas1(5);


CREATE OR REPLACE FUNCTION lucas2(count integer) RETURNS integer 
LANGUAGE plpgsql
AS $$
DECLARE
    arr integer[];
BEGIN
    arr[0] = 2;
    arr[1] = 1;
	FOR i IN 2..count - 1 LOOP
	    arr[i] = arr[i - 1] + arr[i - 2];
	END LOOP;
    RETURN arr[count - 1];
END
$$;

SELECT lucas2(5);

--8. Напишите функцию, которая возвращает количество человек родившихся в заданном году.
CREATE OR REPLACE FUNCTION how_many_born(god integer) RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    i integer;
BEGIN
    SELECT COUNT(*) INTO i FROM people WHERE extract(year from people.birth_date) = god;
    RETURN i;
END
$$;

SELECT how_many_born(1991);

--9. Напишите функцию, которая возвращает количество человек с заданным цветом глаз.

CREATE OR REPLACE FUNCTION eye_guys(color varchar) RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    counter integer := 0;
BEGIN
    SELECT COUNT(*) INTO counter FROM people WHERE people.eyes = color;
    RETURN counter;
END
$$; 

--10. Напишите функцию, которая возвращает ID самого молодого человека в таблице.

CREATE OR REPLACE FUNCTION most_young() RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    counter integer;
BEGIN
    SELECT id INTO counter FROM people WHERE birth_date = (SELECT MAX(birth_date) FROM people);
    RETURN counter;
END
$$;

SELECT most_young();

--11. Напишите процедуру, которая возвращает людей с индексом массы тела больше заданного. ИМТ = масса в кг / (рост в м)^2.
/* На пгадмине нет возможности использовать OUT (ну не использовать же INOUT), потому ответ вывожу с помощью Raise.   */
CREATE OR REPLACE PROCEDURE hz(imt int)
LANGUAGE plpgsql
AS $$
DECLARE
    p people%ROWTYPE;
BEGIN
    FOR p IN 
		SELECT * FROM people Where ((people.weight / (people.growth / 100)^2) > imt)
	LOOP
        Raise info '%', p;
    END LOOP;
END;
$$;

Call hz(24);

--12. Измените схему БД так, чтобы в БД можно было хранить родственные связи между людьми. Код должен быть представлен в виде транзакции (Например (добавление атрибута): BEGIN; ALTER TABLE people ADD COLUMN leg_size REAL; COMMIT;). Дополните БД данными.
BEGIN; 
ALTER TABLE people ADD COLUMN kinship integer; 
COMMIT;


BEGIN; 
UPDATE people 
SET kinship = 1
where people.surname = 'ivanov';
COMMIT;

BEGIN; 
UPDATE people 
SET kinship = 2
where people.surname = 'orlov' or people.surname = 'orlova';
COMMIT;

BEGIN; 
UPDATE people 
SET kinship = 3
where people.surname = 'petrov' or people.surname = 'petrova';
COMMIT;

--13. Напишите процедуру, которая позволяет создать в БД нового человека с указанным родством.

CREATE OR REPLACE PROCEDURE new_guy(
    name IN varchar(255),
    surname IN varchar(255),
    birth_date IN DATE,
    growth IN real,
    weight IN real,
    eyes IN varchar(255),
    hair IN varchar(255),
    kinship IN integer
)

LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO people(name, surname, birth_date, growth, weight, eyes, hair, kinship)
    	VALUES (name, surname, birth_date, growth, weight, eyes, hair, kinship);
END
$$;

CALL new_guy('Vasya', 'Pupkin', '2003-03-06', 190, 70, 'blue', 'brown', 4);

--14. Измените схему БД так, чтобы в БД можно было хранить время актуальности данных человека (выполнить также, как п.12).

BEGIN; 
	ALTER TABLE people ADD COLUMN edited DATE; 
COMMIT;

BEGIN; 
UPDATE people 
SET edited = CURRENT_DATE
where edited is null;
COMMIT;

--15. Напишите процедуру, которая позволяет актуализировать рост и вес человека.

CREATE OR REPLACE PROCEDURE lol_kek(IN people_id integer, IN new_growth real, IN new_weight real)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE people 
	SET growth = new_growth, weight = new_weight, edited = CURRENT_DATE 
	WHERE id = people_id;
END;
$$;

CALL lol_kek(2, 190, 70);
