DROP TABLE IF EXISTS tree;

CREATE TABLE tree (
    level_a char(2),
    level_b char(2),
    level_c char(2),
    level_d char(2),
    leaf_value int
);

INSERT INTO tree (level_a, level_b, level_c, level_d, leaf_value)
VALUES 
  ('A1', 'B1', 'C1', 'D1', 1),
  ('A1', 'B1', 'C1', 'D2', 2),
  ('A1', 'B1', 'C2', 'D3', 4),
  ('A1', 'B1', 'C2', 'D4', 8),
  ('A1', 'B2', 'C3', 'D5', 16),
  ('A1', 'B2', 'C3', 'D6', 32),
  ('A1', 'B2', 'C4', NULL, 64);

-- (a)
SELECT level_a, level_b, level_c, level_d, SUM(leaf_value) FROM tree
GROUP BY ROLLUP(level_a, level_b, level_c, level_d)
HAVING level_a IS NOT NULL
ORDER BY (level_a IS NULL) :: int + (level_b IS NULL) :: int + (level_c IS NULL) :: int + (level_d IS NULL) :: int;

-- (b)
WITH groupcounts AS (
SELECT level_a, level_b, level_c, level_d, COUNT(*)
FROM tree
GROUP BY ROLLUP(level_a, level_b, level_c, level_d)
),
leafs AS (
    SELECT level_a, level_b, level_c, level_d, 0
    FROM tree
),
combined AS (
    SELECT * FROM groupcounts
    UNION
    SELECT * FROM leafs
)
SELECT DISTINCT ON(level_a, level_b, level_c, level_d) * 
FROM combined
WHERE level_a is NOT NULL
ORDER BY level_a, level_b, level_c, level_d, count;


-- (c)
SELECT level_a, level_b, level_c, level_d, MAX(leaf_value) FROM tree
GROUP BY ROLLUP(level_a, level_b, level_c, level_d)
HAVING level_a IS NOT NULL
ORDER BY (level_a IS NULL) :: int + (level_b IS NULL) :: int + (level_c IS NULL) :: int + (level_d IS NULL) :: int;


