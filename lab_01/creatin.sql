use master
go
if exists(select name from sys.databases where name = N'Lab1')
drop database Lab1
go
create database Lab1
go

use Lab1
go


create table driving_schools(
	id int primary key NOT NULL,
	name varchar(50) NOT NULL,
	rating tinyint NOT NULL,
	number varchar(500)
);
go
create table cars
(
	id int primary key NOT NULL,
	car_make varchar(50) NOT NULL,
	transmission varchar(20),
	year_of_manufacture int NOT NULL
);
go
create table instructors
(
	id int primary key NOT NULL,
	surname varchar(30) NOT NULL,
	name varchar(30) NOT NULL,
	driving_experience tinyint NOT NULL,
	teaching_experience tinyint NOT NULL
);
go
create table students
(
	id int primary key NOT NULL,
	surname varchar(30) NOT NULL,
	name varchar(30) NOT NULL,
	type_of_group varchar(30) NOT NULL,
	practiced_hours tinyint NOT NULL,
	car_id int references cars(id) NOT NULL,
	instructor_id int references instructors(id) NOT NULL,
	school_id int references driving_schools(id) NOT NULL,

);
go
