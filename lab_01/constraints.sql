ALTER table driving_schools
add constraint school_name_not_empty check(name != '')
go
ALTER table driving_schools
add constraint school_rating_right check (rating > 0 and rating < 6)
go
ALTER table driving_schools
add constraint school_number_right check (len(number) = 11)
go


ALTER TABLE cars
add constraint car_make_not_empty check(car_make != '')
go
ALTER TABLE cars
add constraint car_year_right check(year_of_manufacture >= 2000 and year_of_manufacture < 2020)
go
ALTER TABLE cars
add constraint car_transmission_not_empty check(transmission != '')
go


ALTER TABLE instructors
add constraint instructor_surname_not_empty check(surname != '')
go
ALTER TABLE instructors
add constraint instructor_name_not_empty check(name != '')
go
ALTER TABLE instructors
add constraint instructor_driving_experience_right check(driving_experience >= 3 and driving_experience <= 50)
go
ALTER TABLE instructors
add constraint instructor_teaching_experience_right check(teaching_experience >= 0 and teaching_experience <= driving_experience)
go

ALTER TABLE students
add constraint student_surname_not_empty check(surname != '')
go
ALTER TABLE students
add constraint student_name_not_empty check(name != '')
go
ALTER TABLE students
add constraint student_group_not_empty check(type_of_group != '')
go
ALTER TABLE students
add constraint student_practiced_hours_right check(practiced_hours >= 0 and practiced_hours < 57)
go

alter table students
add foreign key (car_id) references cars(id)
go
alter table students
add foreign key (instructor_id) references instructors(id)
go
alter table students
add foreign key (school_id) references driving_schools(id)
go
