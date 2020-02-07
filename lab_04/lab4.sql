drop table if exists students;
drop table if exists cars;
drop table if exists driving_schools;
drop table if exists instructors;

create table driving_schools(
id int primary key NOT NULL,
name varchar(50) NOT NULL,
rating int NOT NULL,
number varchar(500)
);

create table cars
(
id int primary key NOT NULL,
car_make varchar(60) NOT NULL,
transmission varchar(60),
year_of_manufacture int NOT NULL
);

create table instructors
(
id int primary key NOT NULL,
surname varchar(30) NOT NULL,
name varchar(30) NOT NULL,
driving_experience int NOT NULL,
teaching_experience int NOT NULL
);

create table students
(
id int primary key NOT NULL,
surname varchar(30) NOT NULL,
name varchar(30) NOT NULL,
type_of_group varchar(30) NOT NULL,
practiced_hours int NOT NULL,
car_id int references cars(id) NOT NULL,
instructor_id int references instructors(id) NOT NULL,
school_id int references driving_schools(id) NOT NULL
);

COPY cars
FROM 'C:\db\lab_01\cars.txt' DELIMITER '|';

COPY driving_schools
FROM 'C:\db\lab_01\schools.txt' DELIMITER '|';

COPY instructors
FROM 'C:\db\lab_01\instructors.txt' DELIMITER '|';

COPY students
FROM 'C:\db\lab_01\students.txt' DELIMITER '|';




--скалярная функция, производитель машины по её айди
create or replace function get_car_make_by_id(id_ int) returns varchar
as $$
crs = plpy.execute("select * from cars")
for cars in crs:
	if cars['id'] == id_:
		return cars['car_make']
return 'None'
$$ language plpython3u;

select * from get_name_by_id(2);

--агрегатная функция, среднее кол-во отъезженных часов
create or replace function average_hours() returns float
as $$
hrs = plpy.execute("select practiced_hours from students")
summ = 0
for i in hrs:
	summ += i['practiced_hours']
return summ/1000
$$ language plpython3u;

select * from average_hours()


--табличная функция, фамилии студентов с заданным кол-вом отъезженных часов
create or replace function surname_hours(hours int)
returns table(id int, surname varchar, practiced_hours int)
as $$
ppl = plpy.execute("select id, surname, practiced_hours from students")
res = []
for i in ppl:
	if (i['practiced_hours'] == hours):
		res.append(i)
return res
$$ language plpython3u;

select * from surname_hours(55)



--хранимая процедура, добавляет новую машину в базу
create or replace procedure add_new_car(pid int, pcarmake varchar, ptransmission varchar, pyear int)
as $$
ppl = plpy.prepare("insert into cars(id, car_make, transmission, year_of_manufacture) values($1, $2, $3, $4);",["int", "varchar", "varchar", "int"])
plpy.execute(ppl, [pid, pcarmake, ptransmission, pyear])
$$ language plpython3u;

call add_new_car(1001 ,'BMW','Mechanic',2020)



--триггер, выводит в отдельную таблицу все удаляемые машины
CREATE TABLE fortriggertest
(
    trig_id int, 
    trig_name VARCHAR(85) NOT NULL
);

create or replace function show_deleted()
returns trigger
as $$
crs = plpy.prepare("insert into fortriggertest(trig_id, trig_name) values($1, $2);",["int", "varchar"])
dict = TD["old"]
plpy.execute(crs, [dict["id"], dict["car_make"]])
return TD["new"]
$$ language plpython3u;

create trigger to_show_deleted
before delete on cars
for each row
execute procedure show_deleted();

delete from cars
where car_make = 'BMW';

drop trigger to_show_deleted on cars; 

select * from fortriggertest;



--определяемый пользователем тип данных, 
create type carsinfo as (
	year_of_manufacture int,
	car_make varchar
);

drop function cars_info()

create or replace function cars_info(id_ int) 
returns carsinfo
as $$
plan = plpy.prepare("select year_of_manufacture, car_make from cars where id = $1", ["int"])
cr = plpy.execute(plan, [id_])
return (cr[0]['year_of_manufacture'], cr[0]['car_make'])
$$ language plpython3u;

select * from cars_info(1001);