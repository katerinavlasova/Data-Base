
ALTER TABLE driving_schools
DROP CONSTRAINT school_name_A
GO
truncate table driving_schools
go



ALTER table driving_schools
add constraint school_name_AA check(name = 'Luxury')
go

BULK INSERT driving_schools
FROM 'C:\db\lab_01\schools.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n', CHECK_CONSTRAINTS )

select *
from driving_schools