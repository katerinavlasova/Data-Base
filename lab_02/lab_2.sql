-- 1.Школы с рейтингом == 5
SELECT name, rating, number
FROM driving_schools
WHERE rating >= 4

-- 2.Студенты, почти закончившие обучение вождению
SELECT surname, name, practiced_hours
FROM students
WHERE practiced_hours between 50 AND 56

-- 3.машины на механике
SELECT car_make
FROM cars
WHERE transmission like '%Mechanic%'

-- 4. Студенты, обучающиеся на механике
SELECT surname, name
FROM students
WHERE car_id IN
	(SELECT car_id
		FROM cars
		WHERE transmission like '%Mechanic%'
	)

-- 5. ученики лучших школ
SELECT surname
FROM students
WHERE EXISTS
(SELECT driving_schools.name
FROM driving_schools join students
ON driving_schools.id = students.school_id
where driving_schools.rating > 4
)
GROUP BY surname

-- 6. Самые долгопреподающие инструкторы
SELECT surname, name, teaching_experience
FROM instructors
WHERE teaching_experience >= ALL
(SELECT teaching_experience
FROM instructors)

-- 7. Инструктора и кол-во их учеников (агрегатные функции)
SELECT instructors.id, instructors.surname, count(*) as number_of_students
FROM instructors join students
ON instructors.id = students.instructor_id
GROUP BY instructors.id, instructors.surname

-- 8. школа и средний опыт препод. у инструкторов(скалярные подзапросы)
select name,
(select max(teaching_experience)
from instructors
join students on students.instructor_id = instructors.id
join driving_schools on driving_schools.id = students.school_id) as avg_exp
from driving_schools as p
where name = 'Luxury'
group by name

--9. школы по рейтингу
SELECT id, name, number,
	case rating
		when 5 then 'super school'
		when 4 then 'good school'
		when 3 then 'regular school'
		else 'bad school'
	end as status
FROM driving_schools

-- 10. Инструкторы по опыту преподавания
SELECT id, surname, name, teaching_experience,
	case
		when teaching_experience < 3 then 'new teacher'
		when teaching_experience < 10 then 'good teacher'
		else 'specialist'
	end as status
FROM instructors

-- 11. Создание новой временной локальной таблицы из результирующего набора
--     данных инструкции SELECT.
-- таблица с учениками, которые ещё не приступили к занятиям
select *
into #bad_students
from students
where practiced_hours < 1;

-- 12. Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM.
-- студенты, которые учатся на новых машинах
select surname, name
from students join
(select cars.id, cars.car_make
from cars
where year_of_manufacture = 2019) as c
on students.car_id = c.id

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
-- вложенности 3.
-- новые машины в крутых школах, на которых почти откатались
select car_make, transmission
from cars
where id in
	(select id
	from cars
	where year_of_manufacture > 2017 and id in
		(select car_id
		from students
		where practiced_hours > 50 and id in
		(select students.id
		from students join driving_schools on students.school_id = driving_schools.id
		where rating > 4)))

-- 14
select name,
(select max(teaching_experience)
from instructors
join students on students.instructor_id = instructors.id
join driving_schools on driving_schools.id = students.school_id) as avg_exp
from driving_schools as p
where name = 'Luxury'
group by name

-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING.
-- ученики, которые учатся на новых машинах
select surname, name, car_make, year_of_manufacture
from students join cars
on students.car_id = cars.id
group by year_of_manufacture, surname, name, car_make
having cars.year_of_manufacture >= 2017

-- 16. 
INSERT INTO driving_schools (id, name, rating, number)
VALUES (1001, 'KOSHKA', 5, 89144495390)

-- 17. многострочная insert. временная таблица с плохими школами
create table #test_schools(id int primary key, name varchar(50), rating tinyint, number varchar(50))
insert into #test_schools(id, name, rating, number)
select *
from driving_schools
where rating < 3

-- 18. update простой
UPDATE students
SET practiced_hours = practiced_hours + 2
WHERE practiced_hours = 0

-- 19. update непростой 
UPDATE students
SET practiced_hours =
(
	SELECT AVG(practiced_hours)
	from students
	where instructor_id = 20
)
WHERE id = 20

-- 20. простая инструкий delete
DELETE driving_schools
WHERE id = 1001
-- WHERE school_id IS NULL

-- 21.Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
-- удаляем учеников, котоые уже отъездили 56 часов
delete from students
where practiced_hours IN
( select practiced_hours
from students
where practiced_hours >=56)

-- 22. Инструкция SELECT, использующая простое обобщенное табличное выражение-- студенты лучших школWITH best_schools as (select id, namefrom driving_schoolswhere rating > 4)select * from best_schools -- работаетselect students.name, students.surnamefrom students join best_schools on students.school_id = best_schools.id -- не работает т.к. отв "жив" только рядом со своим определением-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение-- все новые машины, но рекурсивно:)WITH a_cars (aid, acar_make, ayear_of_manufacture) as(
select id, car_make, year_of_manufacture
from cars
where year_of_manufacture > 2018
union all
select cars.id, cars.car_make, cars.year_of_manufacture
from cars join a_cars on cars.id = a_cars.aid + 1
where year_of_manufacture > 2018
)select * from a_cars --работаетselect * from a_cars --уже не работает-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()-- школы и мин., макс., сред. опыт преподавания инструкторовselect distinct driving_schools.name,min(teaching_experience) OVER(PARTITION by driving_schools.id) as MIIN, --разбиваем на секции по id школы и миним.для каждой школыmax(teaching_experience) OVER(PARTITION by driving_schools.id) as MAAX,avg(teaching_experience) OVER(PARTITION by driving_schools.id) as AVGGfrom instructors join students on students.instructor_id = instructors.idjoin driving_schools on students.school_id = driving_schools.idselect * from driving_schools-- 25. создать оконные дубли и избавиться от нихselect *
into #just_students
from students

select * from
#just_students

delete from #just_students
where id in 
(select c.id
from #just_students as c
join (select id, row_number() over(partition by surname, name order by (surname)) as rn
from #just_students) as t on t.id = c.id
where rn > 1);

select *
from #just_students


