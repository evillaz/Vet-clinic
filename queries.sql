/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals where neutered = true;

SELECT * FROM animals WHERE name <> 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

SET SQL_SAFE_UPDATES = 0;
-- TRANSITION TO UPDATE "species" COLUMN TO "unspecified"

START TRANSACTION;

UPDATE animals SET species = 'unspecified' WHERE id > 0;

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;

COMMIT;

-- NEW TRANSACTION TO UPDATE "species" COLUMN

START TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

SELECT * FROM animals;

COMMIT;

SELECT * FROM animals;

-- NEW TRANSACTION TO DELETE ALL ROWS

START TRANSACTION;

DELETE FROM animals;

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;

-- NEW TRANSACTION TO UPDATE WEIGHT VALUE TO FIX NEGATIVE VALUES

START TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SELECT * FROM animals;

SAVEPOINT mysavepoint;

UPDATE animals SET weight_kg = (weight_kg * -1);

ROLLBACK TO SAVEPOINT mysavepoint;

UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0;

SELECT * FROM animals;

COMMIT;

-- AGGREGATES FUNCTIONS AND GROUP BY

SELECT COUNT(*) AS "Total animals" FROM animals;

SELECT COUNT(*) AS "Total animals no escape"
FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS "Average Weight"
FROM animals;

SELECT neutered, MAX(escape_attempts) AS "Max escape attempts"
FROM animals
GROUP BY neutered;

SELECT species, MIN(weight_kg) AS "Min weight", MAX(weight_kg) AS "Max weight"
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS "Average scape attempts"
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- **What animals belong to Melody Pond?**
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- **List of all animals that are pokemon (their type is Pokemon).**
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'pokemon';

-- **List all owners and their animals, including those who don't own any animal.**  
SELECT o.full_name, COALESCE(a.name, 'No Animal') AS animal_name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- **How many animals are there per species?**
SELECT s.name, COUNT(a.id)
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- **List all Digimon owned by Jennifer Orwell.**
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'digimon' AND o.full_name = 'Jennifer Orwell';

-- **List all animals owned by Dean Winchester that haven't tried to escape.**
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- **Who owns the most animals?**
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- **Join tables queries**

-- **Who was the last animal seen by William Tatcher?**

SELECT a.name AS "Last seen animal"
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- **How many different animals did Stephanie Mendez see?**

SELECT COUNT(DISTINCT a.id)
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';

-- **List all vets and their specialties, including vets with no specialties.**

SELECT vt.name AS vet_name, COALESCE(s.name, 'No Specialty') AS specialty
FROM vets vt
LEFT JOIN specializations sp ON vt.id = sp.vet_id
LEFT JOIN species s ON s.id = sp.species_id;

-- **List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.**

SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez'
	AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

