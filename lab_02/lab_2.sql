-- 1.schools with rating == 5
SELECT name, rating, number
FROM driving_schools
WHERE rating >= 4

-- 2.students who almost finished
SELECT surname, name, practiced_hours
FROM students
WHERE practiced_hours between 50 AND 56

-- 3.mechanic cars
SELECT car_make
FROM cars
WHERE transmission like '%Mechanic%'

-- 4.students with mechanic cars
SELECT surname, name
FROM students
WHERE car_id IN
	(SELECT car_id
		FROM cars
		WHERE transmission like '%Mechanic%'
	)

-- 5. students in best schools
SELECT surname
FROM students
WHERE EXISTS
(SELECT driving_schools.name
FROM driving_schools join students
ON driving_schools.id = students.school_id
where driving_schools.rating > 4
)
GROUP BY surname

-- 6. experienced teachers
SELECT surname, name, teaching_experience
FROM instructors
WHERE teaching_experience >= ALL
(SELECT teaching_experience
FROM instructors)

-- 7. koroche mne nadoelo commentit
SELECT instructors.id, instructors.surname, count(*) as number_of_students
FROM instructors join students
ON instructors.id = students.instructor_id
GROUP BY instructors.id, instructors.surname

-- 8. 
select name,
(select max(teaching_experience)
from instructors
join students on students.instructor_id = instructors.id
join driving_schools on driving_schools.id = students.school_id) as avg_exp
from driving_schools as p
where name = 'Luxury'
group by name

--9. 
SELECT id, name, number,
	case rating
		when 5 then 'super school'
		when 4 then 'good school'
		when 3 then 'regular school'
		else 'bad school'
	end as status
FROM driving_schools

-- 10. 
SELECT id, surname, name, teaching_experience,
	case
		when teaching_experience < 3 then 'new teacher'
		when teaching_experience < 10 then 'good teacher'
		else 'specialist'
	end as status
FROM instructors

-- 11. temp table
select *
into #bad_students
from students
where practiced_hours < 1;

-- 12. 
select surname, name
from students join
(select cars.id, cars.car_make
from cars
where year_of_manufacture = 2019) as c
on students.car_id = c.id

-- 13. 
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

-- 15. 
select surname, name, car_make, year_of_manufacture
from students join cars
on students.car_id = cars.id
group by year_of_manufacture, surname, name, car_make
having cars.year_of_manufacture >= 2017

-- 16. 
INSERT INTO driving_schools (id, name, rating, number)
VALUES (1001, 'KOSHKA', 5, 89144495390)

-- 17. 
create table #test_schools(id int primary key, name varchar(50), rating tinyint, number varchar(50))
insert into #test_schools(id, name, rating, number)
select *
from driving_schools
where rating < 3

-- 18. update 
UPDATE students
SET practiced_hours = practiced_hours + 2
WHERE practiced_hours = 0

-- 19. update 
UPDATE students
SET practiced_hours =
(
	SELECT AVG(practiced_hours)
	from students
	where instructor_id = 20
)
WHERE id = 20

-- 20. 
DELETE driving_schools
WHERE id = 1001
-- WHERE school_id IS NULL

-- 21.students who finished studying
delete from students
where practiced_hours IN
( select practiced_hours
from students
where practiced_hours >=56)

-- 22. 
WITH best_schools as (select id, name
from driving_schools
where rating > 4)
select * from best_schools -- works
select students.name, students.surname
from students join best_schools on students.school_id = best_schools.id -- doesnt work bsc WITH lives near its init


-- 23. cars but recursion
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

select * from a_cars --works
select * from a_cars --doesnot work

-- 24. 
select distinct driving_schools.name,
min(teaching_experience) OVER(PARTITION by driving_schools.id) as MIIN, --
max(teaching_experience) OVER(PARTITION by driving_schools.id) as MAAX,
avg(teaching_experience) OVER(PARTITION by driving_schools.id) as AVGG
from instructors join students on students.instructor_id = instructors.id
join driving_schools on students.school_id = driving_schools.id
select * from driving_schools

-- 25. 
select *
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


