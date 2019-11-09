BULK INSERT driving_schools
FROM 'C:\db\lab_01\schools.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT cars
FROM 'C:\db\lab_01\cars.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n')

BULK INSERT instructors
FROM 'C:\db\lab_01\instructors.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT students
FROM 'C:\db\lab_01\students.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )