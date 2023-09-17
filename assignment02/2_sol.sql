DROP TABLE IF EXISTS tree;
CREATE TABLE tree (
    level_a CHAR(2),
    level_b CHAR(2),
    level_c CHAR(2),
    level_d CHAR(2),
    leaf_value INT
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

-- (a) Write a SQL query using GROUP BY ROLLUP (no WITH RECURSIVE or user-defined functions) which pro-
-- duces a tree in which each node holds the sum of all labels in its subtree. Leaves keep their original
-- values.
SELECT level_a, level_b, level_c, level_d, SUM(leaf_value) FROM tree
GROUP BY ROLLUP(level_a, level_b, level_c, level_d)
HAVING level_a IS NOT NULL
ORDER BY (level_a IS NULL) :: int + (level_b IS NULL) :: int + (level_c IS NULL) :: int + (level_d IS NULL) :: int, level_a, level_b, level_c, level_d
;

-- (b) Similar to (a), write a SQL query to count the leaves below each node (the count of leaves below a
-- leaf is 0).
CREATE TEMP TABLE path_counts AS
SELECT level_a, level_b, level_c, level_d, COUNT(leaf_value) AS leaf_value
FROM tree
GROUP BY ROLLUP(level_a, level_b, level_c, level_d)
HAVING level_a IS NOT NULL
ORDER BY (level_a IS NULL) :: int + (level_b IS NULL) :: int + (level_c IS NULL) :: int + (level_d IS NULL) :: int, level_a, level_b, level_c, level_d
;

UPDATE path_counts
SET
    level_a = COALESCE(level_a, 'NA'),
    level_b = COALESCE(level_b, 'NA'),
    level_c = COALESCE(level_c, 'NA'),
    level_d = COALESCE(level_d, 'NA');


CREATE TEMP TABLE leaves AS
SELECT level_a, level_b, level_c, level_d, true AS is_leaf
FROM tree;

UPDATE leaves
SET
    level_a = COALESCE(level_a, 'NA'),
    level_b = COALESCE(level_b, 'NA'),
    level_c = COALESCE(level_c, 'NA'),
    level_d = COALESCE(level_d, 'NA');


SELECT DISTINCT ON((path_counts.level_a IS NULL) :: int + (path_counts.level_b IS NULL) :: int + (path_counts.level_c IS NULL) :: int + (path_counts.level_d IS NULL) :: int, path_counts.level_a, path_counts.level_b, path_counts.level_c, path_counts.level_d)
path_counts.level_a, path_counts.level_b, path_counts.level_c, path_counts.level_d, -- leaf_value, is_leaf, 
CASE
    WHEN is_leaf THEN 0
    ELSE leaf_value
END
FROM path_counts
LEFT JOIN leaves
ON 
path_counts.level_a=leaves.level_a AND
path_counts.level_b=leaves.level_b AND
path_counts.level_c=leaves.level_c AND
path_counts.level_d=leaves.level_d
ORDER BY (path_counts.level_a IS NULL) :: int + (path_counts.level_b IS NULL) :: int + (path_counts.level_c IS NULL) :: int + (path_counts.level_d IS NULL) :: int, path_counts.level_a, path_counts.level_b, path_counts.level_c, path_counts.level_d;
