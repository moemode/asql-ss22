DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS p;
CREATE TABLE t (
  x int NOT NULL,
  y int NOT NULL
);

CREATE TABLE p (
  val int NOT NULL
);

-- Insert into table t
INSERT INTO t VALUES
  (2, 1),
  (5, 3),
  (6, 4),
  (7, 6),
  (9, 9);

-- Insert into table p
INSERT INTO p VALUES
  (4),
  (5),
  (7),
  (8),
  (9);

-- 1 Reformulate with CTE
SELECT t.x AS x
FROM t AS t
WHERE t.x IN (
  SELECT p.val
  FROM p
  WHERE p.val > 5
);
-- 1 CTE
WITH p_larger_five(val) AS (
SELECT p.val
FROM p
WHERE p.val > 5
)
SELECT t.x AS x
FROM t, p_larger_five
WHERE t.x=p_larger_five.val;

-- 2 Reformulate with CTE
SELECT t.x AS x
FROM t AS t
WHERE t.x IN (
  SELECT p.val
  FROM p
  WHERE p.val > t.y
);

WITH candidate_vals(x, c) AS (
    SELECT t.x, p.val FROM t,p
    WHERE t.y < p.val
)
SELECT DISTINCT x from candidate_vals
WHERE candidate_vals.x=candidate_vals.c;