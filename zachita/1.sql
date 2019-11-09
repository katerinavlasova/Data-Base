

truncate table students
go
truncate table driving_schools
go


ALTER table driving_schools
add constraint school_name_A check(name = 'Luxury')
go


BULK INSERT driving_schools
FROM 'C:\db\lab_01\schools.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


select *
from driving_schools

