DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    UNIQUE KEY unique_enrollment (student_name, course_id)
);


INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date) VALUES
('Ashish', 'CSE101', '2024-07-01'),
('Smaran', 'CSE102', '2024-07-01'),
('Vaibhav', 'CSE101', '2024-07-01');

SELECT * FROM StudentEnrollments;

INSERT IGNORE INTO StudentEnrollments (student_name, course_id, enrollment_date) 
VALUES ('Ashish', 'CSE101', '2024-07-02');

  
INSERT IGNORE INTO StudentEnrollments (student_name, course_id, enrollment_date) 
VALUES ('Ashish', 'CSE101', '2024-07-03');

SELECT * FROM StudentEnrollments;


START TRANSACTION;

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Ashish' AND course_id = 'CSE101'
FOR UPDATE;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-07-15'
WHERE student_name = 'Ashish' AND course_id = 'CSE101';

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Ashish' AND course_id = 'CSE101';

COMMIT;

SELECT * FROM StudentEnrollments;


ALTER TABLE StudentEnrollments ADD COLUMN version INT DEFAULT 1;


START TRANSACTION;

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101'
FOR UPDATE;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-08-01', version = version + 1
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101';

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101';

COMMIT;

 
START TRANSACTION;

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101'
FOR UPDATE;

UPDATE StudentEnrollments 
SET enrollment_date = '2024-08-15', version = version + 1
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101';

SELECT * FROM StudentEnrollments 
WHERE student_name = 'Vaibhav' AND course_id = 'CSE101';

COMMIT;


SELECT * FROM StudentEnrollments ORDER BY enrollment_id;