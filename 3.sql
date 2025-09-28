
DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL
);

INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

SELECT * FROM StudentEnrollments;

START TRANSACTION;
UPDATE StudentEnrollments 
SET enrollment_date = '2024-07-01' 
WHERE student_id = 1;
SELECT 'Session 1: Locked student_id = 1' AS status;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-07-02' 
WHERE student_id = 2;
SELECT 'Session 1: Trying to lock student_id = 2' AS status;
COMMIT;

START TRANSACTION;
UPDATE StudentEnrollments 
SET enrollment_date = '2024-08-01' 
WHERE student_id = 2;
SELECT 'Session 2: Locked student_id = 2' AS status;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-08-02' 
WHERE student_id = 1;
SELECT 'Session 2: Trying to lock student_id = 1' AS status;
COMMIT;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-06-01' 
WHERE student_id = 1;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT student_id, student_name, course_id, enrollment_date, 
       'Initial read by User A' AS action
FROM StudentEnrollments 
WHERE student_id = 1;

SELECT student_id, student_name, course_id, enrollment_date, 
       'Second read by User A (after User B update)' AS action
FROM StudentEnrollments 
WHERE student_id = 1;

COMMIT;

SELECT student_id, student_name, course_id, enrollment_date, 
       'Read by User A after commit' AS action
FROM StudentEnrollments 
WHERE student_id = 1;

START TRANSACTION;
UPDATE StudentEnrollments 
SET enrollment_date = '2024-07-10' 
WHERE student_id = 1;

SELECT student_id, student_name, course_id, enrollment_date, 
       'Updated by User B' AS action
FROM StudentEnrollments 
WHERE student_id = 1;
COMMIT;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-06-01' 
WHERE student_id = 1;

START TRANSACTION;
SELECT student_id, student_name, course_id, enrollment_date, 
       'User A: Locked read' AS action
FROM StudentEnrollments 
WHERE student_id = 1
FOR UPDATE;


SELECT 'User A: Holding lock...' AS status;
COMMIT;

START TRANSACTION;
SELECT 'User B: Attempting update (may be blocked)' AS status;
UPDATE StudentEnrollments 
SET enrollment_date = '2024-07-15' 
WHERE student_id = 1;
COMMIT;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-06-01' 
WHERE student_id = 1;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT student_id, student_name, course_id, enrollment_date, 
       'User A: Non-locking read (MVCC)' AS action
FROM StudentEnrollments 
WHERE student_id = 1;

SELECT 'User A: Still sees old snapshot' AS status;

SELECT student_id, student_name, course_id, enrollment_date, 
       'User A: Second read (consistent snapshot)' AS action
FROM StudentEnrollments 
WHERE student_id = 1;
COMMIT;

START TRANSACTION;
UPDATE StudentEnrollments 
SET enrollment_date = '2024-08-20' 
WHERE student_id = 1;

SELECT student_id, student_name, course_id, enrollment_date, 
       'User B: Update completed' AS action
FROM StudentEnrollments 
WHERE student_id = 1;
COMMIT;


SELECT * FROM StudentEnrollments ORDER BY student_id;

SELECT @@transaction_isolation;

SHOW VARIABLES LIKE 'transaction_isolation';
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';
