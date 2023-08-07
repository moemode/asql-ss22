--- 2
DROP TABLE IF EXISTS r;
CREATE TABLE r (
    a INT,
    b INT
);

INSERT INTO r (a, b)
VALUES
    (1, 2),
    (1, 3);

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


--- 3
DROP TABLE IF EXISTS production;
CREATE TABLE production (
item char(20) NOT NULL,
step int NOT NULL,
completion timestamp, -- NULL means incomplete
PRIMARY KEY (item, step));

INSERT INTO production (item, step, completion)
VALUES
    ('TIE', 1, '1977-03-02 04:12'),
    ('TIE', 2, '1977-12-29 05:55'),
    ('AT-AT', 1, '1978-01-03 14:12'),
    ('AT-AT', 2, NULL),
    ('DSII', 1, NULL),
    ('DSII', 2, '1979-05-26 20:05'),
    ('DSII', 3, '1979-04-04 17:12');

SELECT item AS complete
FROM production as p
GROUP BY item
HAVING EVERY (completion IS NOT NULL);


--- 4
DROP TABLE IF EXISTS A;
CREATE TABLE A (
row int,
col int,
val int,
PRIMARY KEY(row, col));

DROP TABLE IF EXISTS B;
CREATE TABLE B ( LIKE A );

INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,2),
(2,1,3), (2,2,4);

INSERT INTO B (row,col,val)
VALUES (1,1,1), (1,2,2), (1,3,1),
(2,1,2), (2,2,1), (2,3,2);

-- (a) Formulate a SQL query, which performs matrix multiplication
SELECT A.row, B.col, SUM(A.val*B.val)
FROM A, B
WHERE A.col = B.row
GROUP BY A.row, B.col
ORDER BY A.row, B.col;

-- (b) sparse matrices
DELETE FROM A;
DELETE FROM B;

INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,3),
(2,3,7);

INSERT INTO B (row,col,val)
VALUES (1,1,4), (1,3,8 ),
(2,1,1), (2,2,1), (2,3,10),
(3,1,3), (3,2,6);

-- also produces the correct result on sparse matrix
SELECT A.row, B.col, SUM(A.val*B.val)
FROM A, B
WHERE A.col = B.row
GROUP BY A.row, B.col
ORDER BY A.row, B.col;

-- also "works" if dimensions don't match by ignoring values
DELETE FROM B;

INSERT INTO B (row,col,val)
VALUES (1,1,4), (1,3,8 ),
(2,1,1), (2,2,1), (2,3,10),
(3,1,3), (3,2,6),
(4,1,10);

SELECT A.row, B.col, SUM(A.val*B.val)
FROM A, B
WHERE A.col = B.row
GROUP BY A.row, B.col
ORDER BY A.row, B.col;

