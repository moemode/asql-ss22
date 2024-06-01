DROP TABLE IF EXISTS puzzle_input;

CREATE TABLE puzzle_input (
    line int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    val int
);

\copy puzzle_input(val) FROM 'assignment07/1_input';

WITH inc AS (
    SELECT (LAG(p.val, 1) OVER (ORDER BY line) < p.val) AS "inc?"
    FROM puzzle_input as p
)
SELECT COUNT(*) AS n_depth_increases
FROM inc
WHERE inc."inc?";