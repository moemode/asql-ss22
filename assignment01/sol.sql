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
