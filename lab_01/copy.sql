BULK INSERT driving_schools
FROM 'C:\Users\Екатерина\AppData\Local\Programs\Python\Python35-32\schools.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT cars
FROM 'C:\Users\Екатерина\AppData\Local\Programs\Python\Python35-32\cars.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )

BULK INSERT instructors
FROM 'C:\Users\Екатерина\AppData\Local\Programs\Python\Python35-32\instructors.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )


BULK INSERT students
FROM 'C:\Users\Екатерина\AppData\Local\Programs\Python\Python35-32\students.txt'
WITH (
FIELDTERMINATOR =' | '
         , ROWTERMINATOR = '\n' )