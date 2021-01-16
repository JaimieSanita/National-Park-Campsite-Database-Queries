-- Write queries to return the following:
-- Make the following changes in the "world" database.

-- 1. Add Superman's hometown, Smallville, Kansas to the city table. The 
-- countrycode is 'USA', and population of 45001. (Yes, I looked it up on 
-- Wikipedia.)

SELECT * FROM city WHERE countrycode = 'USA' ORDER BY population;
START TRANSACTION;

INSERT INTO city (name, countrycode, district, population)
VALUES ('Smallville', 'USA', 'Kansas', 45001);
SELECT * FROM city WHERE countrycode = 'USA' ORDER BY population;

COMMIT;
SELECT * FROM city WHERE countrycode = 'USA' ORDER BY population;

-- 2. Add Kryptonese to the countrylanguage table. Kryptonese is spoken by 0.0001
-- percentage of the 'USA' population.

SELECT * FROM countrylanguage WHERE countrycode = 'USA';
START TRANSACTION;

INSERT INTO countrylanguage (countrycode, language, isofficial, percentage)
VALUES ('USA', 'Kryptonese', false, '0.001');
SELECT * FROM countrylanguage WHERE countrycode = 'USA';

COMMIT;
SELECT * FROM countrylanguage WHERE countrycode = 'USA';

-- 3. After heated debate, "Kryptonese" was renamed to "Krypto-babble", change 
-- the appropriate record accordingly.

SELECT * FROM countrylanguage WHERE countrycode = 'USA';
START TRANSACTION;

UPDATE countrylanguage SET language = 'Krypto-babble' WHERE language = 'Kryptonese';
SELECT * FROM countrylanguage WHERE countrycode = 'USA';

COMMIT;
SELECT * FROM countrylanguage WHERE countrycode = 'USA';

-- 4. Set the US captial to Smallville, Kansas in the country table.

SELECT * FROM country WHERE code = 'USA';
SELECT * FROM city WHERE name = 'Smallville';

SELECT * FROM country WHERE code = 'USA';
START TRANSACTION;

UPDATE country SET capital = 4087 WHERE code = 'USA';
SELECT * FROM country WHERE code = 'USA';


COMMIT;
SELECT * FROM country WHERE code = 'USA';

-- 5. Delete Smallville, Kansas from the city table. (Did it succeed? Why?)
--No this transaction did not succeed because of a Foreign Key Constraint. The US Capital set to Smallville in the country table will need to be changed before
--this transaction can be successful.
SELECT * FROM city WHERE name = 'Smallville';
START TRANSACTION;

DELETE FROM city WHERE name = 'Smallville';
SELECT * FROM city WHERE name = 'Smallville';

ROLLBACK;
SELECT * FROM city WHERE name = 'Smallville';

-- 6. Return the US captial to Washington.

SELECT * FROM city WHERE name ILIKE '%WASH%';
SELECT * FROM country WHERE code = 'USA';
START TRANSACTION;

UPDATE country SET capital = 3813 WHERE code = 'USA';
SELECT * FROM country WHERE code = 'USA';

COMMIT;
SELECT * FROM country WHERE code = 'USA';
-- 7. Delete Smallville, Kansas from the city table. (Did it succeed? Why?)
--This transaction succeeded because there is no longer a Foreign Key Constraint exisiting the country table. 
--All references to Smallville, Kansas have been deleted from the database.
SELECT * FROM city WHERE name = 'Smallville';
START TRANSACTION;

DELETE FROM city WHERE name = 'Smallville';
SELECT * FROM city WHERE name = 'Smallville';

COMMIT;
SELECT * FROM city WHERE name = 'Smallville';
-- 8. Reverse the "is the official language" setting for all languages where the
-- country's year of independence is within the range of 1800 and 1972 
-- (exclusive). 
-- (590 rows affected)
SELECT * FROM country;

SELECT * FROM countrylanguage WHERE countrycode IN
(SELECT code FROM country WHERE indepyear >= 1800 AND indepyear <= 1972);

START TRANSACTION;

UPDATE countrylanguage SET isofficial = NOT isofficial
FROM country
WHERE indepyear >= 1800 AND indepyear <= 1972;
 
SELECT * FROM countrylanguage WHERE countrycode IN
(SELECT code FROM country WHERE indepyear >= 1800 AND indepyear <= 1972);      

COMMIT;
SELECT * FROM countrylanguage WHERE countrycode IN
(SELECT code FROM country WHERE indepyear >= 1800 AND indepyear <= 1972);

-- 9. Convert population so it is expressed in 1,000s for all cities. (Round to
-- the nearest integer value greater than 0.)
-- (4079 rows affected)

SELECT * FROM city ORDER BY id;

START TRANSACTION;

UPDATE city SET population = population/1000;
SELECT * FROM city ORDER BY id;

COMMIT;
SELECT * FROM city ORDER BY id;
-- 10. Assuming a country's surfacearea is expressed in square miles, convert it to 
-- square meters for all countries where French is spoken by more than 20% of the 
-- population.
-- (7 rows affected)
SELECT * FROM country WHERE code IN ('BEL', 'CAN', 'CHE', 'LUX');
SELECT * FROM countrylanguage WHERE language = 'French' AND percentage > '20';

SELECT * FROM country WHERE code IN ('BEL', 'CAN', 'CHE', 'LUX');
START TRANSACTION;

UPDATE country SET surfacearea = (surfacearea/0.00000038610)
FROM countrylanguage 
WHERE language = 'French' AND percentage > '20';
SELECT * FROM country WHERE code IN ('BEL', 'CAN', 'CHE', 'LUX');

ROLLBACK;
SELECT * FROM country WHERE code IN ('BEL', 'CAN', 'CHE', 'LUX');
