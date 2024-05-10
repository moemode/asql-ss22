-- Task 2: Create an instance for table r with schema r(a int, b int) such that the two queries Q1 and Q2 compute different results.

-- Solution
DROP TABLE IF EXISTS r;
CREATE TABLE r (a INT, b INT);

INSERT INTO r (a, b) 
VALUES (1, 0), (1, 3);

-- Q1
SELECT r.a, COUNT(*) AS c
FROM r AS r
WHERE r.b <> 3
GROUP BY r.a;

-- Q2
SELECT r.a, COUNT(*) AS c
FROM r AS r
GROUP BY r.a
HAVING EVERY(r.b <> 3);

-- Task 3: Listing items for which all production steps are complete

-- Example of table creation and data insertion for production table
DROP TABLE IF EXISTS production;

CREATE TABLE production (
    item CHAR(20) NOT NULL,
    step INT NOT NULL,
    completion TIMESTAMP, -- NULL means incomplete
    PRIMARY KEY (item, step)
);

INSERT INTO production (item, step, completion) VALUES
    ('TIE', 1, '1977/03/02 04:12'),
    ('TIE', 2, '1977/12/29 05:55'),
    ('AT-AT', 1, '1978/01/03 14:12'),
    ('AT-AT', 2, NULL),
    ('DSII', 1, NULL),
    ('DSII', 2, '1979/05/26 20:05'),
    ('DSII', 3, '1979/04/04 17:12');

SELECT p.item AS complete
FROM production AS p
GROUP BY p.item
HAVING bool_and(p.completion IS NOT NULL);

-- Task 4: Matrix Multiplication

-- (a)

DROP TABLE IF EXISTS A;
DROP TABLE IF EXISTS B;
-- Create table for Matrix A
CREATE TABLE A (
    row INT,
    col INT,
    val INT,
    PRIMARY KEY (row, col)
);

-- Create table for Matrix B (similar structure to Matrix A)
CREATE TABLE B ( LIKE A );

-- Example data insertion for Matrix A
INSERT INTO A (row, col, val)
VALUES
    (1, 1, 1),
    (1, 2, 2),
    (2, 1, 3),
    (2, 2, 4);

-- Example data insertion for Matrix B
INSERT INTO B (row, col, val)
VALUES
    (1, 1, 1),
    (1, 2, 2),
    (1, 3, 1),
    (2, 1, 2),
    (2, 2, 1),
    (2, 3, 2);


-- SQL query to perform matrix multiplication A ⋅ B with aliases
-- Resulting matrix will have dimensions (m x p)
SELECT A.row AS row,
       B.col AS col,
       SUM(A.val * B.val) AS val
FROM A
JOIN B ON A.col = B.row  -- Match columns of A with rows of B
GROUP BY A.row, B.col
ORDER BY row, col;

-- (b)
DELETE FROM A;
DELETE FROM B;


-- Insert sample data for Matrix A (sparse matrix)
INSERT INTO A (row, col, val)
VALUES
    (1, 1, 1),
    (1, 2, 3),
    (2, 3, 7);

-- Insert sample data for Matrix B (sparse matrix)
INSERT INTO B (row, col, val)
VALUES
    (1, 1, 4),
    (1, 3, 8),
    (2, 1, 1),
    (2, 2, 1),
    (2, 3, 10),
    (3, 1, 3),
    (3, 2, 6);


-- for sparse matrices the values for returned entries are correct
-- but the dimensions might be unclear

SELECT A.row AS row,
       B.col AS col,
       SUM(A.val * B.val) AS val
FROM A
JOIN B ON A.col = B.row  -- Match columns of A with rows of B
GROUP BY A.row, B.col
ORDER BY row, col;