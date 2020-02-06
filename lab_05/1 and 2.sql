-- извлечь данные с помощью конструкции FOR XML
select surname, name, practiced_hours, car_make, transmission
from students join cars on students.car_id = cars.id
where year_of_manufacture = 2019
FOR XML AUTO;

-- С помощью функции OPENXML и OPENROWSET выполнить загрузку и
-- сохранение XML-документа в таблице базы данных, созданной в ЛР № 1.

DECLARE @idoc int, @doc xml;
SELECT @doc = C FROM OPENROWSET(BULK 'C:/db/lab_05/schools.xml', SINGLE_BLOB) AS TEMP(C)
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc;
INSERT INTO driving_schools
SELECT *
FROM OPENXML(@idoc, '/ROOT/C', 1)
WITH driving_schools;

SELECT * FROM driving_schools