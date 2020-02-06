---------------------- функции
drop function if exists dbo.almost_gradueted;
-- скалярная функция, студенты, к-е почти закончили практику
CREATE FUNCTION dbo.almost_gradueted(@num1 INT, @num2 INT)
RETURNS INT AS
BEGIN
	DECLARE @studentota INT;
	SET @studentota = (select count(*)
						from students
						where practiced_hours >= 50);
	RETURN @studentota;
END;
GO

select dbo.almost_gradueted(5,10)

drop function if exists dbo.shools_with_rating
-- подставляемая табличная ф-я, школы с наилучшим рейтингом
CREATE FUNCTION dbo.schools_with_rating(@rating INT)
RETURNS table AS
RETURN
(
		SELECT *
		FROM driving_schools
		where rating = @rating
);
go

select * from dbo.schools_with_rating(5)

-- многооперативн. табл. ф-я, инструктор по кол-ву часов вождения/преподавания
drop function if exists dbo.find_instructor;

CREATE FUNCTION dbo.find_instructor(@teaching int, @driving int)
RETURNS @found_instructors TABLE
(
	[id] [INT] primary key NOT NULL,
	[surname] [VARCHAR](100) NOT NULL,
	[name] [VARCHAR](100) NOT NULL,
	[driving_exp] [INT] NOT NULL,
	[teaching_exp] [INT] NOT NULL
)
AS
BEGIN
WITH OTV(id, surname, name, driving_exp, teaching_exp)
AS
(
	SELECT *
	from instructors
	WHERE teaching_experience = @teaching
	UNION
	SELECT * 
	from instructors
	WHERE driving_experience = @driving
)
INSERT @found_instructors
SELECT id, surname, name, driving_exp, teaching_exp
FROM OTV
RETURN
END;
GO

select * from dbo.find_instructor(10, 10)

-- Рекурсивная ф-я или ф-я с рекурсивным ОТВ
-- студенты с заданным кол-вом часов
drop function if exists dbo.rec_fun

create function dbo.rec_fun(@n INT)
returns @table TABLE(id int primary key, sur varchar(100), nam varchar(100), hours int) AS
BEGIN
	WITH a_students (aid, asurname, aname, apracticed_hours) as
	(
	select id, surname, name, practiced_hours
	from students
	where practiced_hours = @n
	UNION ALL
	select students.id, students.surname, students.name, students.practiced_hours
	from students join a_students on students.id = a_students.aid + 1
	where students.practiced_hours = @n
	)
	insert into @table
	select * from a_students
	return
END;
select * from dbo.rec_fun(55)
------------------------------- хранимые процедуры ---------

-- хранимая процедура без параметров или с параметрами
-- кол-во студентов, у к-х заданное кол-во часов занятий
drop procedure if exists dbo.find_students 

CREATE PROCEDURE dbo.find_students 
@num int, @countstudents int OUTPUT
AS
	SELECT @countstudents = count(*)
	FROM
	(SELECT * from students
	where practiced_hours = @num) AS M
GO

declare @i int
EXEC dbo.find_students 0, @i OUTPUT
print @i

-- рекурсивная хранимая процедура или хранимая процедура с рекурсинвым отв
-- машины
drop procedure if exists dbo.tree_cars

CREATE PROCEDURE dbo.tree_cars
AS
begin
	WITH a_cars (aid, acar_make, ayear_of_manufacture) as
	(
		select id, car_make, year_of_manufacture
		from cars
		where year_of_manufacture > 2018
		union all
		select cars.id, cars.car_make, cars.year_of_manufacture
		from cars join a_cars on cars.id = a_cars.aid + 1
		where year_of_manufacture > 2018
	)
select * from a_cars
end;

exec dbo.tree_cars

-- курсор
-- названия машин заданного года производства
drop procedure if exists currcorr

CREATE PROCEDURE dbo.currcorr(@manufacture_year INT)
AS
	DECLARE curs CURSOR FOR
			SELECT car_make FROM cars
			where year_of_manufacture = @manufacture_year
	DECLARE @machina VARCHAR(100)

	open curs
	FETCH NEXT FROM curs
	INTO @machina
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT @machina
		FETCH NEXT FROM curs
		INTO @machina
	END;
	close curs
	DEALLOCATE curs
GO

dbo.currcorr 2018


-- хранимая процедура доступа к метаданным
-- ограничения заданной таблицы
drop procedure if exists access_to_metadata;
CREATE PROCEDURE access_to_metadata(@tablename VARCHAR(100))
WITH EXECUTE AS OWNER
AS
	BEGIN
	SELECT *
	from INFORMATION_SCHEMA.CHECK_CONSTRAINTS tablename
	END;
GO

access_to_metadata cars

-- какие таблицы существуют
drop procedure if exists checktables
create procedure checktables
with execute as owner
as
BEGIN
	select name, create_date from sys.tables
END;
go

exec checktables


--------------- триггеры ----------------------------------

-- триггер after
drop trigger if exists after_insert_cars

CREATE TRIGGER after_insert_cars on cars
AFTER INSERT 
as 
BEGIN
	SELECT * FROM inserted
	select 'new car' as 'yra'
END;
GO

INSERT cars VALUES (1001, 'Hyunday Creta', 'Automatic', 2018)

DELETE FROM cars
where id = 1001


-- триггер instead of
drop trigger if exists no_delete

CREATE TRIGGER no_delete on cars
INSTEAD OF DELETE
AS
BEGIN
	SELECT * FROM DELETED
	SELECT 'NO DELETE!!!' AS 'nooo'
END;

SELECT * FROM CARS
