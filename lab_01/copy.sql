BULK INSERT driving_schools
FROM 'C:\db\schools.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT cars
FROM 'C:\db\cars.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )

BULK INSERT instructors
FROM 'C:\db\instructors.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT students
FROM 'C:\db\students.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )