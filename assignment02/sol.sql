/* (a) Create a table measurements(t numeric, m numeric) based on the note given to you by the physicist.
Next, define an artificial PRIMARY KEY by adding a new column id and populate the table with the
measurements of the note. */
CREATE TABLE measurements(t numeric, m numeric);
ALTER TABLE measurements ADD COLUMN id serial PRIMARY KEY;

INSERT INTO measurements(t, m) VALUES
(1.0, 1.0),
(1.0, 3.0),
(1.0, 5.0),
(1.0, 5.0),
(2.5, 0.8),
(2.5, 2.0),
(4.0, 0.5),
(5.5, 3.0),
(8.0, 2.0),
(8.0, 6.0),
(8.0, 8.0),
(10.5, 1.0),
(10.5, 3.0),
(10.5, 8.0);

-- (b) Compute a one-column table with the global maximum of the measurements 𝑚(𝑡)
SELECT max(m) from measurements;
-- (c) Compute a two-column table that lists each time 𝑡 and the average of its measurements 𝑚(𝑡).
SELECT t, AVG(m) from measurements
GROUP BY t
ORDER BY t;
-- (d) Compute a two-column table that lists the average of all measurements 𝑚(𝑡) in each timeframe
-- [0.0 − 5.0), [5.0 − 10.0), [10.0 − 15.0), …
select (t::INTEGER)/5 AS timeframe, AVG(m) AS avg from measurements
GROUP BY (t::INTEGER)/5
ORDER BY timeframe;

-- (e) Find all times 𝑡 (there may be more than one) at which the global maximum was recorded. The
-- result is a two-column table that lists time 𝑡 and the global maximum.
WITH maximum(val) AS(
    SELECT max(m) from measurements
)
SELECT measurements.t, maximum.val from measurements, maximum
WHERE 
measurements.m=maximum.val;
