DROP TABLE IF EXISTS board CASCADE;
DROP TABLE IF EXISTS piece_movements CASCADE;
DROP TABLE IF EXISTS movement CASCADE;

-- The values x_mov and y_mov represent the movement relative to the chess piece position.
-- E.g.: x_mov = -2 and y_mov = -1 means: The piece moves two left and one down.
CREATE TABLE movement (
  id    int PRIMARY KEY,
  x_mov int NOT NULL,
  y_mov int NOT NULL
);

-- Add various types of movement
INSERT INTO movement(id,x_mov,y_mov) VALUES
  ( 1,-2,-1), ( 2,-2, 1), ( 3, 2,-1), ( 4, 2, 1), ( 5,-1,-2), ( 6,-1, 2), ( 7, 1,-2), ( 8, 1, 2),
  ( 9, 1, 0), (10, 0, 1), (11, 1, 1), (12,-1, 0), (13, 0,-1), (14,-1,-1), (15, 1,-1), (16,-1, 1);

-- This table assigns each chess piece to its movement pattern
CREATE TABLE piece_movements (
  piece   char(1) NOT NULL,
  move_id int     NOT NULL REFERENCES movement(id),
  PRIMARY KEY(piece, move_id)
);

INSERT INTO piece_movements(piece,move_id) VALUES
  ( '♚', 9), ( '♚',10), ( '♚',11), ( '♚',12), ( '♚',13), ( '♚',14), ( '♚',15), ( '♚',16),
  ( '♔', 9), ( '♔',10), ( '♔',11), ( '♔',12), ( '♔',13), ( '♔',14), ( '♔',15), ( '♔',16),
  ( '♞', 1), ( '♞', 2), ( '♞', 3), ( '♞', 4), ( '♞', 5), ( '♞', 6), ( '♞', 7), ( '♞', 8),
  ( '♘', 1), ( '♘', 2), ( '♘', 3), ( '♘', 4), ( '♘', 5), ( '♘', 6), ( '♘', 7), ( '♘', 8);

-- The chess board represents its positions as (x,y) coordinates.
CREATE TABLE board (
  x     int     NOT NULL, 
  y     int     NOT NULL,
  piece char(1) NOT NULL
);

-- !!! You are *not* expected to change anything above this line. !!!

\set board_width  8
\set board_height 8

-- One of many possible piece arrangements 
INSERT INTO board(x,y,piece) 
VALUES (4,4,'♞'),
       (5,6,'♔');


-- This table holds a row (x,y,piece), if piece is located on the 
-- board at position (x,y). If no piece is located at (x,y), the table holds 
-- row (x,y,' '). The resulting table has a cardinality of :board_width * :board_height.
WITH board_and_pieces(x,y,piece) AS ( 
  SELECT xcord, ycord, COALESCE(board.piece, ' ')
  FROM generate_series(1, 8) AS xcord
  CROSS JOIN generate_series(1, 8) AS ycord
  LEFT OUTER JOIN board
  ON(board.x=xcord AND board.y=ycord)
)
--SELECT * FROM board_and_pieces WHERE piece=' ';
,
-- This table holds a row (x,y,'0'), exactly if one move of any piece on the 
-- board can reach position (x,y).
possible_movements(x,y,piece) AS (
  SELECT x+movement.x_mov, y+movement.y_mov, '0' FROM board, piece_movements, movement
  WHERE board.piece=piece_movements.piece
  AND piece_movements.move_id=movement.id
),
--SELECT * FROM possible_movements;
-- !!! You are *not* expected to change anything below this line. Pretty printing only! !!!
-- Combine possible_movements and the board_and_pieces to create the final result.
-- Result:
-- x        : The x coordinate on the board
-- y        : The y coordinate on the board
-- piece    : The visual representation of a piece, '0' or ' '. 
--            See board_and_pieces and possible_movements. Type: CHAR(1)
board_result (x,y,piece) AS (
  SELECT pb.x AS x, pb.y AS y,
         chr(CASE WHEN MAX(ascii(pb.piece)) = 0 THEN 32
                  ELSE MAX(ascii(pb.piece))
             END) AS piece -- Use MAX(...) because: ascii(' ') < ascii('0') < ascii(any chesspiece)
  FROM   (TABLE board_and_pieces UNION ALL TABLE possible_movements) AS pb
  GROUP BY pb.y, pb.x
  ORDER BY pb.y DESC, pb.x
)
-- Format result in a chess board style
SELECT br.y AS " ", ARRAY_TO_STRING(ARRAY_AGG(br.piece ORDER BY br.x), '|') AS "A B C D E F G H "
FROM   board_result AS br
GROUP BY br.y
ORDER BY br.y DESC;

--
-- Expected result: 
--
--    │ A B C D E F G H  
-- ───┼──────────────────
--  8 │  | | | | | | | 
--  7 │  | | |0|0|0| | 
--  6 │  | |0|0|♔|0| | 
--  5 │  |0| |0|0|0| | 
--  4 │  | | |♞| | | | 
--  3 │  |0| | | |0| | 
--  2 │  | |0| |0| | | 
--  1 │  | | | | | | | 
--