DROP TABLE IF EXISTS Agencies;

CREATE TABLE Agencies (
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

INSERT INTO Agencies (name, location, phone) VALUES
    ('BayTours', 'San Francisco', '415-1200'),
    ('HarborCruz', 'Santa Cruz', '831-3000');

DROP TABLE IF EXISTS ExternalTours;

CREATE TABLE ExternalTours (
    name VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

INSERT INTO ExternalTours (name, destination, type, price) VALUES
    ('BayTours', 'San Francisco', 'cablecar', 50.00),
    ('BayTours', 'Santa Cruz', 'bus', 100.00),
    ('BayTours', 'Santa Cruz', 'boat', 250.00),
    ('BayTours', 'Monterey', 'boat', 400.00),
    ('HarborCruz', 'Monterey', 'boat', 200.00),
    ('HarborCruz', 'Carmel', 'train', 90.00);

SELECT DISTINCT a.name, a.phone
FROM Agencies a, ExternalTours e
WHERE a.name = e.name AND e.type = 'boat';

-- Equivalent query with different where provenance
SELECT DISTINCT e.name, a.phone
FROM Agencies a, ExternalTours e
WHERE a.name = e.name AND e.type = 'boat';

-- Equivalent query with different why provenance
WITH tours(name, type) AS (
    SELECT DISTINCT e.name, e.type
    FROM ExternalTours AS e
)
SELECT a.name, a.phone
FROM Agencies a, Tours t
WHERE a.name = t.name and t.type = 'boat';

-- Q2
SELECT DISTINCT e.destination, a.phone
FROM Agencies a,
(SELECT name, location AS destination
FROM Agencies a
UNION
SELECT name, destination
FROM ExternalTours) e
WHERE a.name = e.name;

-- Equivalent query, different how provenance
SELECT DISTINCT e.destination, a.phone
FROM Agencies a, ExternalTours e
WHERE a.name = e.name
UNION
SELECT a.location, a.phone FROM Agencies a;