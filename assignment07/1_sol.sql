DROP TABLE IF EXISTS puzzle_input;

-- (a)
CREATE TABLE puzzle_input (
    line int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    val int
);

\copy puzzle_input(val) FROM 'assignment07/1_input';

-- (b)
WITH inc AS (
    SELECT (LAG(p.val, 1) OVER (ORDER BY line) < p.val) AS "inc?"
    FROM puzzle_input as p
)
SELECT COUNT(*) AS n_depth_increases
FROM inc
WHERE inc."inc?";


-- (c)
\set wsize 3

WITH window_sums(line, sum) AS (
    SELECT s.line,
    SUM(s.val) OVER win
    FROM puzzle_input AS s
    WINDOW win AS (ORDER BY s.line ROWS BETWEEN CURRENT ROW AND (:wsize - 1) FOLLOWING)
    ORDER BY s.line
    LIMIT  (SELECT COUNT(*) FROM puzzle_input) - (:wsize - 1)
),
inc AS (
    SELECT (LAG(w.sum, 1) OVER (ORDER BY w.line) < w.sum) AS "inc?"
    FROM window_sums as w
)
SELECT COUNT(*) AS n_depth_increases
FROM inc
WHERE inc."inc?";


