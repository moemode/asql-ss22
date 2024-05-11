-- Sample use case for SQL's common table expressions (WITH):
--
-- Infer bipedality (or quadropedality) for dinosaurs based
-- on their body length and shape.

DROP TABLE IF EXISTS dinosaurs;
CREATE TABLE dinosaurs (species text, height float, length float, legs int);

INSERT INTO dinosaurs(species, height, length, legs) VALUES
  ('Ceratosaurus',      4.0,   6.1,  2),
  ('Deinonychus',       1.5,   2.7,  2),
  ('Microvenator',      0.8,   1.2,  2),
  ('Plateosaurus',      2.1,   7.9,  2),
  ('Spinosaurus',       2.4,  12.2,  2),
  ('Tyrannosaurus',     7.0,  15.2,  2),
  ('Velociraptor',      0.6,   1.8,  2),
  ('Apatosaurus',       2.2,  22.9,  4),
  ('Brachiosaurus',     7.6,  30.5,  4),
  ('Diplodocus',        3.6,  27.1,  4),
  ('Supersaurus',      10.0,  30.5,  4),
  ('Albertosaurus',     4.6,   9.1,  NULL),  -- Bi-/quadropedality is
  ('Argentinosaurus',  10.7,  36.6,  NULL),  -- unknown for these species.
  ('Compsognathus',     0.6,   0.9,  NULL),  --
  ('Gallimimus',        2.4,   5.5,  NULL),  -- Try to infer pedality from
  ('Mamenchisaurus',    5.3,  21.0,  NULL),  -- their ratio of body height
  ('Oviraptor',         0.9,   1.5,  NULL),  -- to length.
  ('Ultrasaurus',       8.1,  30.5,  NULL);  --

TABLE dinosaurs;

CREATE TEMP TABLE L1 AS 
WITH bodies(legs, shape) AS (
  SELECT d.legs, AVG(d.height / d.length) AS shape
  FROM dinosaurs AS d
  WHERE d.legs IS NOT NULL
  GROUP BY d.legs
),

legs AS (
  SELECT d.species, d.height, d.length,
  COALESCE(d.legs,
    (SELECT b.legs
    FROM bodies AS b 
    ORDER BY ABS(b.shape - (d.height/d.length))
    LIMIT 1)
    ) AS calculated_legs
FROM dinosaurs as d
)
TABLE legs;



-- ➊ Determine characteristic height/length (= body shape) ratio
-- separately for bipedal and quadropedal dinosaurs:
CREATE TEMP TABLE L2 AS 
WITH bodies(legs, shape) AS (
  SELECT d.legs, AVG(d.height / d.length) AS shape
  FROM   dinosaurs AS d
  WHERE  d.legs IS NOT NULL
  GROUP BY d.legs
)
-- ➋ Realize query plan (assumes table bodies exists)
SELECT d.species, d.height, d.length,
       (SELECT b.legs                               -- Find the shape entry in bodies
        FROM   bodies AS b                          -- that matches d's ratio of
        ORDER BY abs(b.shape - d.height / d.length) -- height to length the closest
        LIMIT 1) AS legs                            -- (pick row with minimal shape difference)
FROM  dinosaurs AS d
WHERE d.legs IS NULL
                      -- ↑ Locomotion of dinosaur d is unknown
  UNION ALL           ----------------------------------------
                      -- ↓ Locomotion of dinosaur d is known
SELECT d.*
FROM   dinosaurs AS d
WHERE  d.legs IS NOT NULL;

SELECT COUNT(*) = (
    SELECT COUNT(*) 
    FROM (
        SELECT * FROM L1
        UNION 
        SELECT * FROM L2
    ) AS combined
) AS L1EqL2
FROM L1;


-----------------------------------------------------------------------
-- Equivalent formulation using DISTINCT ON (w/o LIMIT)

CREATE TEMP TABLE L3 AS
WITH bodies(legs, shape) AS (
  SELECT d.legs, AVG(d.height / d.length) AS shape
  FROM   dinosaurs AS d
  WHERE  d.legs IS NOT NULL
  GROUP BY d.legs
)
SELECT d.species, d.height, d.length,
       (SELECT DISTINCT ON (d.species) b.legs                               -- Find the shape entry in bodies
        FROM   bodies AS b                          -- that matches d's ratio of
        ORDER BY d.species, abs(b.shape - d.height / d.length) -- height to length the closest
        ) AS legs                            -- (pick row with minimal shape difference)
FROM  dinosaurs AS d
WHERE d.legs IS NULL
                      -- ↑ Locomotion of dinosaur d is unknown
  UNION ALL           ----------------------------------------
                      -- ↓ Locomotion of dinosaur d is known
SELECT d.*
FROM   dinosaurs AS d
WHERE  d.legs IS NOT NULL;


SELECT COUNT(*) = (
    SELECT COUNT(*) 
    FROM (
        SELECT * FROM L2
        UNION 
        SELECT * FROM L3
    ) AS combined
) AS L2EqL3
FROM L2;

--
--  ──████████████──
--  ─██░░░░░░░░░░██─
--  ─██░░██████░░██─
--  ──█████──██░░██─
--  ──────████░░██──
--  ──────██░░███───
--  ──────█████─────
--  ────────────────
--  ───────████─────
--  ──────██░░██────
--  ───────████─────
--
-- Please post your alternative formulation of the dinosaur
-- shape SQL query in the Advanced SQL forum.
-- ⚠ Do not use LIMIT but rely on DISTINCT ON.
-- Looking forward to your solutions!
