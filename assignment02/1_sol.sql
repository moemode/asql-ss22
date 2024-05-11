-- (a)
DROP TABLE IF EXISTS measurements;

CREATE TABLE measurements(t numeric, m numeric);

ALTER TABLE measurements
ADD COLUMN id SERIAL;

ALTER TABLE measurements
ADD PRIMARY KEY (id);

-- Inserting data for t = 1.0
INSERT INTO measurements (t, m) VALUES (1.0, 1.0);
INSERT INTO measurements (t, m) VALUES (1.0, 3.0);
INSERT INTO measurements (t, m) VALUES (1.0, 5.0);
INSERT INTO measurements (t, m) VALUES (1.0, 5.0);

-- Inserting data for t = 2.5
INSERT INTO measurements (t, m) VALUES (2.5, 0.8);
INSERT INTO measurements (t, m) VALUES (2.5, 2.0);

-- Inserting data for t = 4.0
INSERT INTO measurements (t, m) VALUES (4.0, 0.5);

-- Inserting data for t = 5.5
INSERT INTO measurements (t, m) VALUES (5.5, 3.0);

-- Inserting data for t = 8.0
INSERT INTO measurements (t, m) VALUES (8.0, 2.0);
INSERT INTO measurements (t, m) VALUES (8.0, 6.0);
INSERT INTO measurements (t, m) VALUES (8.0, 8.0);

-- Inserting data for t = 10.5
INSERT INTO measurements (t, m) VALUES (10.5, 1.0);
INSERT INTO measurements (t, m) VALUES (10.5, 3.0);
INSERT INTO measurements (t, m) VALUES (10.5, 8.0);

-- (b)
SELECT MAX(m.m)
FROM measurements AS m;

-- (c)
SELECT m.t, AVG(m.m)
FROM measurements AS m
GROUP BY m.t
ORDER BY m.t;

-- (d)
SELECT DIV(m.t, 5) AS tf, DIV(m.t, 5)*5.0 AS start, 
(DIV(m.t, 5) + 1)*5.0 AS end, AVG(m.m) AS avg_m
FROM measurements AS m
GROUP BY tf
ORDER BY tf;

-- (e)
SELECT m.t
FROM measurements AS m
WHERE m.m = (SELECT MAX(m.m) FROM measurements AS m);