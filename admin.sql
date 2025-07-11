create database p
use p
-- Departments Table
CREATE TABLE Departments (
    id INT PRIMARY KEY ,
    department_name VARCHAR(255) NOT NULL
);


-- Programs Table
CREATE TABLE Programs (
    id INT PRIMARY KEY ,
    program_name VARCHAR(255) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(id)
);

-- Students Table
CREATE TABLE Students (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    program_id INT NOT NULL,
    department_id INT NOT NULL,
    enrollment_date DATE,
    FOREIGN KEY (program_id) REFERENCES Programs(id),
    FOREIGN KEY (department_id) REFERENCES Departments(id)
);

-- Faculty Table
CREATE TABLE Faculty (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    courses_taught TEXT,
    FOREIGN KEY (department_id) REFERENCES Departments(id)
);

-- Courses Table
CREATE TABLE Courses (
    id INT PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    faculty_id INT NOT NULL,
    program_id INT NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(id),
    FOREIGN KEY (program_id) REFERENCES Programs(id)
);

--adding contrsaints 
ALTER TABLE Courses
ADD CONSTRAINT chk_credits CHECK (credits > 0 AND credits <= 4);


-- Enrollments Table
CREATE TABLE Enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Attendance Table
CREATE TABLE Attendance (
    id INT PRIMARY KEY ,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
	faculty_id INT NOT NULL,
    date DATE NOT NULL,
    status varchar(100) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id),
	FOREIGN KEY (faculty_id) REFERENCES Faculty(id)
);



-- Marks Table
CREATE TABLE Marks (
    id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
	faculty_id INT NOT NULL,
    assessment_type  VARCHAR(255) NOT NULL,
    assessment_name VARCHAR(255),
    marks_obtained DECIMAL(5,2),
    max_marks DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id),
	FOREIGN KEY (faculty_id) REFERENCES Faculty(id)
);
--constraint 
ALTER TABLE Marks
ADD CONSTRAINT chk_marks CHECK (marks_obtained <= max_marks AND marks_obtained >= 0 AND max_marks > 0);

-- SemesterResults Table
CREATE TABLE SemesterResults (
    id INT PRIMARY KEY ,
    student_id INT NOT NULL,
    semester VARCHAR(10),
    GPA DECIMAL(3,2),
    overall_grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(id)
);

-- CourseResults Table
CREATE TABLE CourseResults (
    id INT PRIMARY Key ,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(10),
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);


----ALTER SEMSTER TABLE

ALTER TABLE SemesterResults
ADD semester_name NVARCHAR(50),
    total_credits INT,
    total_weighted_score DECIMAL(5, 2);

CREATE TABLE Schedule (
    id INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for the schedule
    course_id INT NOT NULL,           -- References the Course ID
    day_of_week NVARCHAR(15) NOT NULL, -- Day of the week (e.g., Monday, Tuesday)
    start_time TIME NOT NULL,         -- Start time of the class
    end_time TIME NOT NULL,           -- End time of the class
    room_number NVARCHAR(20),         -- Room number where the class will be held
    CONSTRAINT FK_Schedule_Course FOREIGN KEY (course_id) REFERENCES Courses(id) -- Foreign key to Courses table
);



CREATE TABLE Feedback (
    id INT IDENTITY(1,1) PRIMARY KEY,       
    course_id INT NOT NULL,               
    student_id INT NOT NULL,               
    feedback_text NVARCHAR(MAX),            -- Textual feedback from the student
    rating INT CHECK (rating BETWEEN 1 AND 5), -- Rating given by the student (1 to 5 scale)
    feedback_date DATE NOT NULL DEFAULT GETDATE(), -- Date when feedback was provided
    CONSTRAINT FK_Feedback_Course FOREIGN KEY (course_id) REFERENCES Courses(id), 
    CONSTRAINT FK_Feedback_Student FOREIGN KEY (student_id) REFERENCES Students(id) 
);


CREATE TABLE CourseProgress (
    id INT IDENTITY(1,1) PRIMARY KEY,       -- Unique identifier for course progress
    course_id INT NOT NULL,                 -- References the Course ID
    total_topics INT NOT NULL CHECK (total_topics >= 0), -- Total topics in the course
    completed_topics INT NOT NULL CHECK (completed_topics >= 0), -- Topics completed so far
    remaining_lectures INT NOT NULL CHECK (remaining_lectures >= 0), -- Remaining lectures for the course
    CONSTRAINT FK_CourseProgress_Course FOREIGN KEY (course_id) REFERENCES Courses(id) -- Foreign key to Courses table
);

INSERT INTO CourseProgress (course_id, total_topics, completed_topics, remaining_lectures)
VALUES 
(1, 20, 15, 3),  -- Course 1: 20 topics, 15 completed, 3 lectures remaining
(2, 25, 20, 5),  -- Course 2: 25 topics, 20 completed, 5 lectures remaining
(3, 30, 18, 6);  -- Course 3: 30 topics, 18 completed, 6 lectures remaining



-------------------ASSIGMENT--------------
CREATE TABLE Assignments (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Adding IDENTITY property here
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    due_date DATETIME NOT NULL,
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(id)
);

--  Insert data into the Assignments table
INSERT INTO Assignments (title, description, due_date, course_id, faculty_id)
VALUES 
    ('Database Project', 'Submit a complete database design project.', '2024-12-15', 1, 5),
    ('Web Development Assignment', 'Create a responsive website using HTML, CSS, and JavaScript.', '2024-12-20', 2, 6),
    ('Machine Learning Homework', 'Implement a machine learning model in Python for classification.', '2024-12-22', 3, 7),
    ('Software Engineering Case Study', 'Write a detailed case study on software development methodologies.', '2024-12-25', 4, 8),
    ('Data Structures Exam', 'Prepare for the upcoming data structures and algorithms exam.', '2024-12-30', 1, 5);

--  Recreate the StudentAssignments table with the correct identity property
CREATE TABLE StudentAssignments (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Adding IDENTITY property here
    student_id INT NOT NULL,
    assignment_id INT NOT NULL,
    uploaded_file_path NVARCHAR(MAX),
    upload_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(id)
);
--- Insert data into the StudentAssignments table
INSERT INTO StudentAssignments (student_id, assignment_id, uploaded_file_path)
VALUES (1, 1, 'C:\\Submissions\\DatabaseProject_123.pdf');


------DISPLAY------------------------------ 
select * from Attendance
select *from CourseResults
select *from Courses
select *from Departments
select *from Students
select *from Enrollments
select * from Faculty
select*from Marks
select *from Programs
select *from SemesterResults
drop table AssessmentDetails
--------------------------------------------
--------------------------------------------
--------------------------------------------
--Query to View All Students in a BS CS Program
SELECT Students.id, Students.name, Students.email, Programs.program_name 
FROM Students 
JOIN Programs ON Students.program_id = Programs.id 
WHERE Programs.program_name = 'BSc COMPUTER SCIENCE';

--List Courses Taught by a Dr. Alice Johnson
SELECT Courses.name, Courses.credits 
FROM Courses 
JOIN Faculty ON Courses.faculty_id = Faculty.id 
WHERE Faculty.name = 'Dr. Alice Johnson';

--Update a Student�s Email
UPDATE Students 
SET email = 'newemail@example.com' 
WHERE id = 1;

--Get All Courses a Student is Enrolled In by name 
SELECT c.name, c.credits 
FROM Enrollments  e
JOIN Courses c
ON e.course_id = c.id 
JOIN Students s
ON s.id = c.id 
WHERE s.name = 'John Doe';

--Add Attendance Record if it is already not present , in this case it is present 
INSERT INTO Attendance (id, student_id, course_id, faculty_id, date, status) 
VALUES (1, 1, 1, 1, '2024-12-01', 'Present');

--Get Total Marks Obtained by a Student in a Course
--add marks first 
-- Insert Marks for Quizzes
INSERT INTO Marks (id, student_id, course_id, faculty_id, assessment_type, assessment_name, marks_obtained, max_marks) 
VALUES 
(1, 1, 1, 1, 'Quiz', 'Quiz 1', 8.0, 10.0),
(2, 1, 1, 1, 'Quiz', 'Quiz 2', 7.5, 10.0),
(3, 1, 1, 1, 'Quiz', 'Quiz 3', 9.0, 10.0),
(4, 1, 1, 1, 'Quiz', 'Quiz 4', 8.5, 10.0);
--get sum
-- Calculate Total Marks for All Quizzes
SELECT 
    SUM(marks_obtained) AS TotalMarksObtained, 
    SUM(max_marks) AS TotalMaxMarks 
FROM Marks 
WHERE student_id = 1 AND course_id = 1 AND assessment_type = 'Quiz';

--do it by percentage 

-- Calculate 10% Weightage
SELECT 
    (SUM(marks_obtained) / SUM(max_marks)) * 10 AS QuizWeightage 
FROM Marks 
WHERE student_id = 1 AND course_id = 1 AND assessment_type = 'Quiz';


--Delete a Student Record
DELETE FROM Students 
WHERE id = 2;


--Calculate GPA for a Semester
--add
-- Insert Marks for Assignments
INSERT INTO Marks (id, student_id, course_id, faculty_id, assessment_type, assessment_name, marks_obtained, max_marks) 
VALUES 
(5, 1, 1, 1, 'Assignment', 'Assignment 1', 18.0, 20.0),
(6, 1, 1, 1, 'Assignment', 'Assignment 2', 19.0, 20.0),
(9, 1, 1, 1, 'Assignment', 'Assignment 3', 18.0, 20.0),
(10, 1, 1, 1, 'Assignment', 'Assignment 4', 19.0, 20.0);

-- Insert Marks for Midterm
INSERT INTO Marks (id, student_id, course_id, faculty_id, assessment_type, assessment_name, marks_obtained, max_marks) 
VALUES 
(7, 1, 1, 1, 'Midterm', 'Midterm Exam', 22.5, 30.0);

-- Insert Marks for Final
INSERT INTO Marks (id, student_id, course_id, faculty_id, assessment_type, assessment_name, marks_obtained, max_marks) 
VALUES 
(8, 1, 1, 1, 'Final', 'Final Exam', 40.0, 50.0);


--calculate this by percentage wise
SELECT 
    student_id,
    course_id,
    (
        (
            (SUM(CASE WHEN assessment_type = 'Quiz' THEN marks_obtained END) / SUM(CASE WHEN assessment_type = 'Quiz' THEN max_marks END) * 10) +
            (SUM(CASE WHEN assessment_type = 'Assignment' THEN marks_obtained END) / SUM(CASE WHEN assessment_type = 'Assignment' THEN max_marks END) * 15) +
            (SUM(CASE WHEN assessment_type = 'Midterm' THEN marks_obtained END) / SUM(CASE WHEN assessment_type = 'Midterm' THEN max_marks END) * 25) +
            (SUM(CASE WHEN assessment_type = 'Final' THEN marks_obtained END) / SUM(CASE WHEN assessment_type = 'Final' THEN max_marks END) * 50)
        ) / 100 * 4
    ) AS GPA
FROM Marks
WHERE student_id = 1 AND course_id = 1
GROUP BY student_id, course_id;


--View All Students in a Department
SELECT Students.name, Students.email 
FROM Students 
JOIN Departments ON Students.department_id = Departments.id 
WHERE Departments.department_name = 'Computer Science';


--Assign a Grade to a Course
UPDATE CourseResults 
SET grade = 'A' 
WHERE student_id = 1 AND course_id = 1;


--Drop a Student from a Course
DELETE FROM Enrollments 
WHERE student_id = 1 AND course_id = 1;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-----------------------------STUDENT------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--STUDENT VIEW----------
------------------------------------------
--StudentProfileView
------------------------------------------
CREATE VIEW StudentProfileView AS
SELECT 
    s.id AS StudentID,
    s.name AS StudentName,
    s.email AS StudentEmail,
    p.program_name AS ProgramName,
    d.department_name AS DepartmentName,
    s.enrollment_date AS EnrollmentDate
FROM 
    Students s
JOIN Programs p ON s.program_id = p.id
JOIN Departments d ON s.department_id = d.id;
------------------------------------------
-- CourseEnrollmentsView
------------------------------------------
CREATE VIEW CourseEnrollmentsView AS
SELECT 
    e.student_id AS StudentID,
    e.course_id AS CourseID,
    c.name AS CourseName,
    c.credits AS CourseCredits,
    f.name AS FacultyName,
    f.email AS FacultyEmail
FROM 
    Enrollments e
JOIN Courses c ON e.course_id = c.id
JOIN Faculty f ON c.faculty_id = f.id;

------------------------------------------
-- AssessmentSummaryView
------------------------------------------
CREATE VIEW AssessmentSummaryView AS
SELECT 
    m.student_id AS StudentID,
    m.course_id AS CourseID,
    c.name AS CourseName,
    SUM(m.marks_obtained) AS TotalMarksObtained,
    SUM(m.max_marks) AS TotalMaxMarks,
    CAST(SUM(m.marks_obtained) * 100.0 / SUM(m.max_marks) AS DECIMAL(5, 2)) AS Percentage
FROM 
    Marks m
JOIN Courses c ON m.course_id = c.id
GROUP BY 
    m.student_id, m.course_id, c.name;

	------------------------------------------
	--SemesterPerformanceView
	------------------------------------------
	CREATE VIEW SemesterPerformanceView AS
SELECT 
    sr.student_id AS StudentID,
    sr.semester_name AS Semester,
    sr.GPA AS GPA,
    sr.overall_grade AS Grade,
    sr.total_credits AS TotalCredits,
    sr.total_weighted_score AS TotalWeightedScore
FROM 
    SemesterResults sr;
------------------------------------------
--DetailedStudentPerformanceView
------------------------------------------
	CREATE VIEW DetailedStudentPerformanceView AS
SELECT 
    sp.StudentID,
    sp.StudentName,
    sp.ProgramName,
    sp.DepartmentName,
    ce.CourseID,
    ce.CourseName,
    ce.CourseCredits,
    ce.FacultyName,
    asv.TotalMarksObtained,
    asv.TotalMaxMarks,
    asv.Percentage,
    spv.Semester,
    spv.GPA,
    spv.Grade
FROM 
    StudentProfileView sp
LEFT JOIN CourseEnrollmentsView ce ON sp.StudentID = ce.StudentID
LEFT JOIN AssessmentSummaryView asv ON sp.StudentID = asv.StudentID AND ce.CourseID = asv.CourseID
LEFT JOIN SemesterPerformanceView spv ON sp.StudentID = spv.StudentID;
------------------------------------------
-- AttendanceSummaryView
------------------------------------------
CREATE VIEW AttendanceSummaryView AS
SELECT 
    a.student_id AS StudentID,
    s.name AS StudentName,
    a.course_id AS CourseID,
    c.name AS CourseName,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS DaysPresent,
    COUNT(a.id) AS TotalDays,
    CAST(COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(a.id) AS DECIMAL(5, 2)) AS AttendancePercentage
FROM 
    Attendance a
JOIN Students s ON a.student_id = s.id
JOIN Courses c ON a.course_id = c.id
GROUP BY 
    a.student_id, s.name, a.course_id, c.name;


	--------------------------------------------------------
	-------------------ASSSIGMNET UPLOAD VIEW----------------
	----------------------------------------------------------
	CREATE VIEW StudentAssignmentUploadView AS
SELECT 
    sa.student_id AS StudentID,
    s.name AS StudentName,
    sa.assignment_id AS AssignmentID,
    a.title AS AssignmentTitle,
    a.description AS AssignmentDescription,
    a.due_date AS DueDate,
    a.course_id AS CourseID,
    c.name AS CourseName,
    f.name AS FacultyName,
    f.email AS FacultyEmail,
    sa.uploaded_file_path AS UploadedFilePath,
    sa.upload_date AS UploadDate,
    CASE 
        WHEN GETDATE() <= a.due_date THEN 'On Time'
        ELSE 'Late'
    END AS SubmissionStatus
FROM 
    StudentAssignments sa
JOIN Students s ON sa.student_id = s.id
JOIN Assignments a ON sa.assignment_id = a.id
JOIN Courses c ON a.course_id = c.id
JOIN Faculty f ON a.faculty_id = f.id;


SELECT * FROM StudentAssignmentUploadView


-----------------------------------------------
-----PreviousSemesterGPA-----------------------
-- --------------------------------------------
CREATE VIEW PreviousSemesterGPA AS
SELECT 
    sr.student_id AS StudentID,
    -- Include semester name and number (e.g., 'Spring 2024 (Semester 1)')
    CONCAT(sr.semester_name, ' (Semester ', 
        CASE 
            WHEN sr.semester_name = 'Spring 2024' THEN '1'
            WHEN sr.semester_name = 'Fall 2024' THEN '2'
            ELSE '0' -- Default case for unknown semesters
        END,
        ')') AS PreviousSemester,  -- Semester Name and Number
    
    c.name AS CourseName,
    cr.grade AS Grade,
    c.credits AS Credits,
    
    -- Weighted grade points for each course
    CASE 
        WHEN cr.grade = 'A' THEN c.credits * 4.0
        WHEN cr.grade = 'B' THEN c.credits * 3.0
        WHEN cr.grade = 'C' THEN c.credits * 2.0
        WHEN cr.grade = 'D' THEN c.credits * 1.0
        WHEN cr.grade = 'F' THEN c.credits * 0.0
        ELSE 0.0
    END AS WeightedGradePoints,

    -- Calculate the GPA based on the weighted points
    ROUND(
        SUM(CASE 
                WHEN cr.grade = 'A' THEN c.credits * 4.0
                WHEN cr.grade = 'B' THEN c.credits * 3.0
                WHEN cr.grade = 'C' THEN c.credits * 2.0
                WHEN cr.grade = 'D' THEN c.credits * 1.0
                WHEN cr.grade = 'F' THEN c.credits * 0.0
                ELSE 0.0
            END) / SUM(c.credits), 2
    ) AS PreviousSemesterGPA,

    -- Calculate Total CGPA across all semesters
    (SELECT 
        ROUND(
            SUM(CASE 
                    WHEN cr2.grade = 'A' THEN c2.credits * 4.0
                    WHEN cr2.grade = 'B' THEN c2.credits * 3.0
                    WHEN cr2.grade = 'C' THEN c2.credits * 2.0
                    WHEN cr2.grade = 'D' THEN c2.credits * 1.0
                    WHEN cr2.grade = 'F' THEN c2.credits * 0.0
                    ELSE 0.0
                END) / SUM(c2.credits), 2
        )
    FROM 
        SemesterResults sr2
    JOIN CourseResults cr2 ON sr2.student_id = cr2.student_id
    JOIN Courses c2 ON cr2.course_id = c2.id
    WHERE sr2.student_id = sr.student_id) AS TotalCGPA

FROM 
    SemesterResults sr
JOIN CourseResults cr ON sr.student_id = cr.student_id AND sr.semester = cr.semester
JOIN Courses c ON cr.course_id = c.id
WHERE sr.semester_name < (
    SELECT MAX(semester_name) 
    FROM SemesterResults 
    WHERE student_id = sr.student_id
)
GROUP BY sr.student_id, sr.semester_name, c.name, cr.grade, c.credits;


------------------------------------------
----------MarksView_CurrentSemester--------
------------------------------------------
CREATE VIEW MarksView_CurrentSemester AS
SELECT 
    m.student_id AS StudentID,
    m.course_id AS CourseID,
    c.name AS CourseName,
    
    -- Calculate weighted marks for each assessment type
    SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) AS QuizMarks,  -- Quiz weight = 10%
    SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) AS AssignmentMarks,  -- Assignment weight = 15%
    SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) AS MidtermMarks,  -- Midterm weight = 25%
    SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END) AS FinalMarks,  -- Final weight = 50%

    -- Total weighted score (sum of all weighted marks)
    SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) +
    SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) +
    SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) +
    SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END) AS TotalMarks,
    
    -- Calculate Percentage
    ROUND(
        (
            (SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) +
            SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) +
            SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) +
            SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END)) / 
            (SUM(CASE WHEN m.assessment_type IN ('Quiz', 'Assignment', 'Midterm', 'Final') THEN 100 ELSE 0 END))
        ) * 100, 2
    ) AS Percentage,
    
    sr.semester_name AS Semester,
    sr.GPA AS SemesterGPA
FROM 
    Marks m
LEFT JOIN Courses c ON m.course_id = c.id
LEFT JOIN SemesterResults sr ON m.student_id = sr.student_id
WHERE sr.semester_name = (SELECT MAX(semester_name) FROM SemesterResults WHERE student_id = m.student_id)
GROUP BY m.student_id, m.course_id, c.name, sr.semester_name, sr.GPA;



------------------------------------------
-------------DISPLAY OF STUDENT-----------
------------------------------------------
-- Test StudentProfileView
SELECT * FROM StudentProfileView;

-- Test CourseEnrollmentsView
SELECT * FROM CourseEnrollmentsView;

-- Test AssessmentSummaryView
SELECT * FROM AssessmentSummaryView;

-- Test AttendanceSummaryView
SELECT * FROM AttendanceSummaryView;

-- Test SemesterPerformanceView
SELECT * FROM SemesterPerformanceView;

-- Test DetailedStudentPerformanceView
SELECT * FROM DetailedStudentPerformanceView;

-- Test PreviousSemesterGPA
SELECT * FROM PreviousSemesterGPA;

-- Test MarksView_CurrentSemester
SELECT * FROM MarksView_CurrentSemester;
---ASIGMNET UPLOAD 
SELECT * FROM StudentAssignmentUploadView

---------------------------------------
--------------------------------------
--------------PROCEDURE----------------
--------------------------------------
CREATE PROCEDURE GetMarksCurrentSemester (@studentID INT)
AS
BEGIN
    SELECT 
        m.student_id AS StudentID,
        m.course_id AS CourseID,
        c.name AS CourseName,

        -- Calculate weighted marks for each assessment type
        SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) AS QuizMarks,  -- Quiz weight = 10%
        SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) AS AssignmentMarks,  -- Assignment weight = 15%
        SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) AS MidtermMarks,  -- Midterm weight = 25%
        SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END) AS FinalMarks,  -- Final weight = 50%

        -- Total weighted score (sum of all weighted marks)
        SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) +
        SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) +
        SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) +
        SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END) AS TotalMarks,

        -- Calculate Percentage
        ROUND(
            (
                (SUM(CASE WHEN m.assessment_type = 'Quiz' THEN m.marks_obtained * 0.10 ELSE 0 END) +
                SUM(CASE WHEN m.assessment_type = 'Assignment' THEN m.marks_obtained * 0.15 ELSE 0 END) +
                SUM(CASE WHEN m.assessment_type = 'Midterm' THEN m.marks_obtained * 0.25 ELSE 0 END) +
                SUM(CASE WHEN m.assessment_type = 'Final' THEN m.marks_obtained * 0.50 ELSE 0 END)) / 
                (SUM(CASE WHEN m.assessment_type IN ('Quiz', 'Assignment', 'Midterm', 'Final') THEN 100 ELSE 0 END))
            ) * 100, 2
        ) AS Percentage,

        sr.semester_name AS Semester,
        sr.GPA AS SemesterGPA
    FROM 
        Marks m
    LEFT JOIN Courses c ON m.course_id = c.id
    LEFT JOIN SemesterResults sr ON m.student_id = sr.student_id
    WHERE sr.student_id = @studentID
    AND sr.semester_name = (SELECT MAX(semester_name) FROM SemesterResults WHERE student_id = m.student_id)
    GROUP BY m.student_id, m.course_id, c.name, sr.semester_name, sr.GPA;
END;



------------------------------------------
------------------------------------------
CREATE PROCEDURE GetStudentProfile
    @StudentID INT
AS
BEGIN
    SELECT 
        s.id AS StudentID,
        s.name AS StudentName,
        s.email AS StudentEmail,
        p.program_name AS ProgramName,
        d.department_name AS DepartmentName,
        s.enrollment_date AS EnrollmentDate
    FROM 
        Students s
    JOIN Programs p ON s.program_id = p.id
    JOIN Departments d ON s.department_id = d.id
    WHERE s.id = @StudentID;
END;
--------------------------------------------------------
------------------------CourseEnrollmentsView----------
--------------------------------------------------------
CREATE PROCEDURE GetCourseEnrollments
    @StudentID INT
AS
BEGIN
    SELECT 
        e.student_id AS StudentID,
        e.course_id AS CourseID,
        c.name AS CourseName,
        c.credits AS CourseCredits,
        f.name AS FacultyName,
        f.email AS FacultyEmail
    FROM 
        Enrollments e
    JOIN Courses c ON e.course_id = c.id
    JOIN Faculty f ON c.faculty_id = f.id
    WHERE e.student_id = @StudentID;
END;
---------------------------------------------------
---------------------AssessmentSummaryView----------
---------------------------------------------------
CREATE PROCEDURE GetAssessmentSummary
    @StudentID INT
AS
BEGIN
    SELECT 
        m.student_id AS StudentID,
        m.course_id AS CourseID,
        c.name AS CourseName,
        SUM(m.marks_obtained) AS TotalMarksObtained,
        SUM(m.max_marks) AS TotalMaxMarks,
        CAST(SUM(m.marks_obtained) * 100.0 / SUM(m.max_marks) AS DECIMAL(5, 2)) AS Percentage
    FROM 
        Marks m
    JOIN Courses c ON m.course_id = c.id
    WHERE m.student_id = @StudentID
    GROUP BY 
        m.student_id, m.course_id, c.name;
END;
---------------------------------------------------
-------------------SemesterPerformanceView---------
---------------------------------------------------
CREATE PROCEDURE GetSemesterPerformance
    @StudentID INT
AS
BEGIN
    SELECT 
        sr.student_id AS StudentID,
        sr.semester_name AS Semester,
        sr.GPA AS GPA,
        sr.overall_grade AS Grade,
        sr.total_credits AS TotalCredits,
        sr.total_weighted_score AS TotalWeightedScore
    FROM 
        SemesterResults sr
    WHERE sr.student_id = @StudentID;
END;
-----------------------------------------------------------------
----------------------DetailedStudentPerformanceView------------
-----------------------------------------------------------------
CREATE PROCEDURE GetDetailedStudentPerformance
    @StudentID INT
AS
BEGIN
    SELECT 
        sp.StudentID,
        sp.StudentName,
        sp.ProgramName,
        sp.DepartmentName,
        ce.CourseID,
        ce.CourseName,
        ce.CourseCredits,
        ce.FacultyName,
        asv.TotalMarksObtained,
        asv.TotalMaxMarks,
        asv.Percentage,
        spv.Semester,
        spv.GPA,
        spv.Grade
    FROM 
        StudentProfileView sp
    LEFT JOIN CourseEnrollmentsView ce ON sp.StudentID = ce.StudentID
    LEFT JOIN AssessmentSummaryView asv ON sp.StudentID = asv.StudentID AND ce.CourseID = asv.CourseID
    LEFT JOIN SemesterPerformanceView spv ON sp.StudentID = spv.StudentID
    WHERE sp.StudentID = @StudentID;
END;
------------------------------------------------------
-----------------AttendanceSummaryView----------------
------------------------------------------------------

CREATE PROCEDURE GetAttendanceSummary
    @StudentID INT
AS
BEGIN
    SELECT 
        a.student_id AS StudentID,
        s.name AS StudentName,
        a.course_id AS CourseID,
        c.name AS CourseName,
        COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS DaysPresent,
        COUNT(a.id) AS TotalDays,
        CAST(COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(a.id) AS DECIMAL(5, 2)) AS AttendancePercentage
    FROM 
        Attendance a
    JOIN Students s ON a.student_id = s.id
    JOIN Courses c ON a.course_id = c.id
    WHERE a.student_id = @StudentID
    GROUP BY 
        a.student_id, s.name, a.course_id, c.name;
END;
------------------------------------------------------
----------------StudentAssignmentUploadView-----------
------------------------------------------------------

CREATE PROCEDURE GetStudentAssignmentUploads
    @StudentID INT
AS
BEGIN
    BEGIN TRANSACTION  -- Start the transaction

    BEGIN TRY
        -- Perform the select operation
        SELECT 
            sa.student_id AS StudentID,
            s.name AS StudentName,
            sa.assignment_id AS AssignmentID,
            a.title AS AssignmentTitle,
            a.description AS AssignmentDescription,
            a.due_date AS DueDate,
            a.course_id AS CourseID,
            c.name AS CourseName,
            f.name AS FacultyName,
            f.email AS FacultyEmail,
            sa.uploaded_file_path AS UploadedFilePath,
            sa.upload_date AS UploadDate,
            CASE 
                WHEN GETDATE() <= a.due_date THEN 'On Time'
                ELSE 'Late'
            END AS SubmissionStatus
        FROM 
            StudentAssignments sa
        JOIN Students s ON sa.student_id = s.id
        JOIN Assignments a ON sa.assignment_id = a.id
        JOIN Courses c ON a.course_id = c.id
        JOIN Faculty f ON a.faculty_id = f.id
        WHERE sa.student_id = @StudentID;

        COMMIT TRANSACTION;  -- Commit the transaction if successful
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if any error occurs
        ROLLBACK TRANSACTION;
        
        -- Capture and throw the error message
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

DROP PROCEDURE IF EXISTS GetStudentAssignmentUploads;


---------------PreviousSemesterGPA---------------
CREATE PROCEDURE GetPreviousSemesterGPA
    @StudentID INT
AS
BEGIN
    DECLARE @PreviousGPA FLOAT;
    DECLARE @TotalCGPA FLOAT;

    -- Calculate the previous semester GPA
    SELECT 
        @PreviousGPA = ROUND(
            SUM(CASE 
                    WHEN cr.grade = 'A' THEN c.credits * 4.0
                    WHEN cr.grade = 'B' THEN c.credits * 3.0
                    WHEN cr.grade = 'C' THEN c.credits * 2.0
                    WHEN cr.grade = 'D' THEN c.credits * 1.0
                    WHEN cr.grade = 'F' THEN c.credits * 0.0
                    ELSE 0.0
                END) / SUM(c.credits), 2
        )
    FROM 
        SemesterResults sr
    JOIN CourseResults cr ON sr.student_id = cr.student_id AND sr.semester = cr.semester
    JOIN Courses c ON cr.course_id = c.id
    WHERE sr.student_id = @StudentID;
    
    -- Calculate the total CGPA across all semesters
    SELECT 
        @TotalCGPA = ROUND(
            SUM(CASE 
                    WHEN cr.grade = 'A' THEN c.credits * 4.0
                    WHEN cr.grade = 'B' THEN c.credits * 3.0
                    WHEN cr.grade = 'C' THEN c.credits * 2.0
                    WHEN cr.grade = 'D' THEN c.credits * 1.0
                    WHEN cr.grade = 'F' THEN c.credits * 0.0
                    ELSE 0.0
                END) / SUM(c.credits), 2
        )
    FROM 
        SemesterResults sr
    JOIN CourseResults cr ON sr.student_id = cr.student_id
    JOIN Courses c ON cr.course_id = c.id
    WHERE sr.student_id = @StudentID;

    -- If CGPA is less than 1, alert the student that they need to repeat the semester from the start
    IF @TotalCGPA < 1
    BEGIN
        RAISERROR('Your CGPA is below 1. You are required to repeat the semester from the start.', 16, 1);
    END
    ELSE
    BEGIN
        -- If GPA is 1 or above, display the semester results
        SELECT 
            sr.student_id AS StudentID,
            CONCAT(sr.semester_name, ' (Semester ', 
                CASE 
                    WHEN sr.semester_name = 'Spring 2024' THEN '1'
                    WHEN sr.semester_name = 'Fall 2024' THEN '2'
                    ELSE '0' -- default case for unknown semesters
                END,
                ')') AS PreviousSemester,  -- Semester Number and Name
            c.name AS CourseName,
            cr.grade AS Grade,
            c.credits AS Credits,
            CASE 
                WHEN cr.grade = 'A' THEN c.credits * 4.0
                WHEN cr.grade = 'B' THEN c.credits * 3.0
                WHEN cr.grade = 'C' THEN c.credits * 2.0
                WHEN cr.grade = 'D' THEN c.credits * 1.0
                WHEN cr.grade = 'F' THEN c.credits * 0.0
                ELSE 0.0
            END AS WeightedGradePoints,
            @PreviousGPA AS PreviousSemesterGPA,
            @TotalCGPA AS TotalCGPA
        FROM 
            SemesterResults sr
        JOIN CourseResults cr ON sr.student_id = cr.student_id AND sr.semester = cr.semester
        JOIN Courses c ON cr.course_id = c.id
        WHERE sr.student_id = @StudentID
        GROUP BY sr.student_id, sr.semester_name, c.name, cr.grade, c.credits;
    END
END;
use p
-------------------------------------------------------
-------------------------------------------------------
EXEC GetStudentProfile @StudentID = 1;
EXEC GetCourseEnrollments @StudentID = 1;
EXEC GetAssessmentSummary @StudentID = 1;
EXEC GetSemesterPerformance @StudentID = 1;
EXEC GetDetailedStudentPerformance @StudentID = 1;
EXEC GetAttendanceSummary @StudentID = 1;
EXEC GetStudentAssignmentUploads @StudentID = 1;
EXEC GetPreviousSemesterGPA @StudentID = 1;
EXEC GetMarksCurrentSemester   @StudentID = 1;
-------------------------------------------------------
-------------------------------------------------------
-----------PROCEDURE OF ALL VIEWS----------------------
-------------------------------------------------------
-------------------------------------------------------
CREATE PROCEDURE GetStudentFullDetails
    @StudentID INT
AS
BEGIN
    BEGIN TRY
        -- Check if the student exists
        IF NOT EXISTS (SELECT 1 FROM Students WHERE id = @StudentID)
        BEGIN
            RAISERROR('Student with the provided ID does not exist.', 16, 1);
            RETURN;
        END

        -- Retrieve and display Student Profile Information
        PRINT 'Student Profile Information:';
        SELECT 
            sp.StudentID,
            sp.StudentName,
            sp.StudentEmail,
            sp.ProgramName,
            sp.DepartmentName,
            sp.EnrollmentDate
        FROM StudentProfileView sp
        WHERE sp.StudentID = @StudentID;

        -- Retrieve and display Enrolled Courses Information
        PRINT 'Enrolled Courses Information:';
        SELECT 
            ce.CourseID,
            ce.CourseName,
            ce.CourseCredits,
            ce.FacultyName,
            ce.FacultyEmail
        FROM CourseEnrollmentsView ce
        WHERE ce.StudentID = @StudentID;

        -- Retrieve and display Assessment Summary
        PRINT 'Assessment Summary:';
        SELECT 
            asv.CourseID,
            asv.CourseName,
            asv.TotalMarksObtained,
            asv.TotalMaxMarks,
            asv.Percentage AS MarksPercentage
        FROM AssessmentSummaryView asv
        WHERE asv.StudentID = @StudentID;

        -- Retrieve and display Attendance Summary
        PRINT 'Attendance Summary:';
        SELECT 
            att.CourseID,
            att.CourseName,
            att.DaysPresent,
            att.TotalDays,
            att.AttendancePercentage
        FROM AttendanceSummaryView att
        WHERE att.StudentID = @StudentID;

        -- Retrieve and display Semester Performance
        PRINT 'Semester Performance:';
        SELECT 
            spv.Semester,
            spv.GPA,
            spv.Grade,
            spv.TotalCredits,
            spv.TotalWeightedScore
        FROM SemesterPerformanceView spv
        WHERE spv.StudentID = @StudentID;

        -- Retrieve and display Previous Semester GPA
        PRINT 'Previous Semester GPA:';
        SELECT 
            psg.StudentID,
            psg.PreviousSemester,
            psg.CourseName,
            psg.Grade,
            psg.Credits,
            psg.WeightedGradePoints,
            psg.PreviousSemesterGPA
        FROM PreviousSemesterGPA psg
        WHERE psg.StudentID = @StudentID;

        -- Retrieve and display Current Semester Marks
        PRINT 'Current Semester Marks:';
        SELECT 
            mcs.StudentID,
            mcs.CourseID,
            mcs.CourseName,
            mcs.QuizMarks,
            mcs.AssignmentMarks,
            mcs.MidtermMarks,
            mcs.FinalMarks,
            mcs.TotalMarks,
            mcs.Percentage,
            mcs.Semester,
            mcs.SemesterGPA
        FROM MarksView_CurrentSemester mcs
        WHERE mcs.StudentID = @StudentID;

        -- Retrieve and display Detailed Student Performance
        PRINT 'Detailed Student Performance:';
        SELECT 
            dsp.StudentID,
            dsp.StudentName,
            dsp.ProgramName,
            dsp.DepartmentName,
            dsp.CourseID,
            dsp.CourseName,
            dsp.CourseCredits,
            dsp.FacultyName,
            dsp.TotalMarksObtained,
            dsp.TotalMaxMarks,
            dsp.Percentage,
            dsp.Semester,
            dsp.GPA,
            dsp.Grade
        FROM DetailedStudentPerformanceView dsp
        WHERE dsp.StudentID = @StudentID;

        -- Retrieve and display Assignment Upload Information
        PRINT 'Assignment Upload Information:';
        SELECT 
            sa.student_id AS StudentID,
            s.name AS StudentName,
            sa.assignment_id AS AssignmentID,
            a.title AS AssignmentTitle,
            a.description AS AssignmentDescription,
            a.due_date AS DueDate,
            a.course_id AS CourseID,
            c.name AS CourseName,
            f.name AS FacultyName,
            f.email AS FacultyEmail,
            sa.uploaded_file_path AS UploadedFilePath,
            sa.upload_date AS UploadDate,
            CASE 
                WHEN GETDATE() <= a.due_date THEN 'On Time'
                ELSE 'Late'
            END AS SubmissionStatus
        FROM 
            StudentAssignments sa
        JOIN Students s ON sa.student_id = s.id
        JOIN Assignments a ON sa.assignment_id = a.id
        JOIN Courses c ON a.course_id = c.id
        JOIN Faculty f ON a.faculty_id = f.id
        WHERE sa.student_id = @StudentID;

    END TRY
    BEGIN CATCH
        -- Handle errors gracefully
        SELECT 
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS Severity,
            ERROR_STATE() AS State;
    END CATCH
END;


EXEC GetStudentFullDetails @StudentID = 1;
--------------------------------------------------------------------------
----------------------------------------------------------------------------
-----------------------------------------------------------------------------
CREATE PROCEDURE InsertFeedback
    @StudentID INT,
    @CourseID INT,
    @FeedbackText NVARCHAR(MAX),
    @Rating INT  -- Assuming rating is an integer (e.g., from 1 to 5)
AS
BEGIN
    BEGIN TRY
        -- Insert the feedback record into the Feedback table
        INSERT INTO Feedback (student_id, course_id, feedback_text, rating, feedback_date)
        VALUES (@StudentID, @CourseID, @FeedbackText, @Rating, GETDATE());

        PRINT 'Feedback successfully submitted.';
    END TRY
    BEGIN CATCH
        -- Handle errors
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

-------------------------------------------------------------------
-------------------------------------------------------------------
-------------ALL EXECUTION QUERY-----------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-- Test StudentProfileView
SELECT * FROM StudentProfileView;

-- Test CourseEnrollmentsView
SELECT * FROM CourseEnrollmentsView;

-- Test AssessmentSummaryView
SELECT * FROM AssessmentSummaryView;

-- Test AttendanceSummaryView
SELECT * FROM AttendanceSummaryView;

-- Test SemesterPerformanceView
SELECT * FROM SemesterPerformanceView;

-- Test DetailedStudentPerformanceView
SELECT * FROM DetailedStudentPerformanceView;

-- Test PreviousSemesterGPA
SELECT * FROM PreviousSemesterGPA;

-- Test MarksView_CurrentSemester
SELECT * FROM MarksView_CurrentSemester;
---ASIGMNET UPLOAD 
SELECT * FROM StudentAssignmentUploadView

------------------------------------------------------

EXEC GetStudentProfile @StudentID = 1;
EXEC GetCourseEnrollments @StudentID = 1;
EXEC GetAssessmentSummary @StudentID = 1;
EXEC GetSemesterPerformance @StudentID = 1;
EXEC GetDetailedStudentPerformance @StudentID = 1;
EXEC GetAttendanceSummary @StudentID = 1;
EXEC GetStudentAssignmentUploads @StudentID = 1;
EXEC GetPreviousSemesterGPA @StudentID = 1;
-----------------------------------------------
EXEC GetStudentFullDetails @StudentID = 1;

--------------------------------------------------------------------
EXEC InsertFeedback 
   @StudentID = 1,        -- Student ID
   @CourseID = 1,         -- Course ID
   @FeedbackText = 'Great course, very informative!',   -- Feedback text
   @Rating = 5;           -- Rating

----GRANT PERMISSION TO STUDENT-----------------------------
-- Create a user in the database ' with the login you created above)
CREATE USER  student FOR LOGIN student;

-- Grant SELECT permission on views to the student user
GRANT SELECT ON StudentProfileView TO student;
GRANT SELECT ON CourseEnrollmentsView TO student;
GRANT SELECT ON AssessmentSummaryView TO student;
GRANT SELECT ON AttendanceSummaryView TO student;
GRANT SELECT ON SemesterPerformanceView TO student;
GRANT SELECT ON DetailedStudentPerformanceView TO student;
GRANT SELECT ON PreviousSemesterGPA TO student;
GRANT SELECT ON MarksView_CurrentSemester TO student;
GRANT SELECT ON StudentAssignmentUploadView TO student;

GRANT SELECT ON Students TO student;

-- Grant EXECUTE permission on all procedures to the student user
GRANT EXECUTE ON GetStudentProfile TO student;
GRANT EXECUTE ON GetCourseEnrollments TO student;
GRANT EXECUTE ON GetAssessmentSummary TO student;
GRANT EXECUTE ON GetSemesterPerformance TO student;
GRANT EXECUTE ON GetDetailedStudentPerformance TO student;
GRANT EXECUTE ON GetAttendanceSummary TO student;
GRANT EXECUTE ON GetStudentAssignmentUploads TO student;
GRANT EXECUTE ON GetPreviousSemesterGPA TO student;
GRANT EXECUTE ON GetStudentFullDetails TO student;
GRANT EXECUTE ON InsertFeedback TO student;
 GRANT EXECUTE ON GetMarksCurrentSemester TO student;
 
-- Grant INSERT permission on tables related to assignment uploads
GRANT INSERT ON StudentAssignmentUploadView TO student;

	---------------------------------------------------------------
	----------------------------------------------------------------
	-----------------------------------------------------------------
	-----------------------------------TRIGGER-------------------------
	-------------------------------------------------------------
	--------------------------------------------------------------
	CREATE TRIGGER trg_PreventDuplicateAssignmentUpload
ON StudentAssignments
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @StudentID INT, @AssignmentID INT;

    -- Fetch the inserted values
    SELECT @StudentID = student_id, @AssignmentID = assignment_id
    FROM inserted;

    -- Check if the student has already uploaded the same assignment (same student_id and assignment_id)
    IF EXISTS (SELECT 1 FROM StudentAssignments WHERE student_id = @StudentID AND assignment_id = @AssignmentID)
    BEGIN
        -- Raise a user-friendly error message if the same assignment is being uploaded again
        RAISERROR('You have already uploaded this assignment. Please upload a different assignment if needed.', 16, 1);
    END
    ELSE
    BEGIN
        -- Proceed with the insert if no duplicate is found for the same assignment
        INSERT INTO StudentAssignments (student_id, assignment_id, uploaded_file_path, upload_date)
        SELECT student_id, assignment_id, uploaded_file_path, upload_date
        FROM inserted;
    END
END;


ENABLE TRIGGER trg_PreventDuplicateAssignmentUpload ON StudentAssignments;

DISABLE TRIGGER trg_PreventDuplicateAssignmentUpload ON StudentAssignments;


select * from StudentAssignments
 select * from AssignmentUploadAudit
------------------------------------------------------------------------------------------------
--                        Faculty Table                            --
------------------------------------------------------------------------------------------------
-----------FacultyProfileView----------------------
CREATE VIEW FacultyProfileView AS
SELECT 
    f.id AS FacultyID,
    f.name AS FacultyName,
    f.email AS FacultyEmail,
    d.department_name AS DepartmentName
FROM 
    Faculty f
JOIN Departments d ON f.department_id = d.id;
select * from FacultyProfileView


--------View for Faculty to View Students' Marks---------
CREATE VIEW FacultyStudentMarksView AS
SELECT 
    f.id AS FacultyID,
    s.id AS StudentID,
    s.name AS StudentName,
    c.id AS CourseID,
    c.name AS CourseName,
    m.assessment_type AS AssessmentType,
    m.marks_obtained AS MarksObtained,
    m.max_marks AS MaxMarks
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN Marks m ON c.id = m.course_id
JOIN Students s ON m.student_id = s.id;
 select * from FacultyStudentMarksView
 --------------------------------------------------------------------------------
 -----Stored Procedure for Faculty to Upload Marks
---------with transaction-------------
--------------------------------------------------------------------------------
 drop procedure UploadStudentMarks

CREATE PROCEDURE UploadStudentMarks
@id  int,
    @FacultyID INT,
    @CourseID INT,
    @StudentID INT,
    @AssessmentType VARCHAR(50),
    @MarksObtained DECIMAL(5,2),
    @MaxMarks DECIMAL(5,2)
AS
BEGIN
    -- Start the transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the faculty is authorized to upload marks for the given course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            -- Insert the marks into the Marks table (or update if necessary)
            INSERT INTO Marks (id,faculty_id, course_id, student_id, assessment_type, marks_obtained, max_marks)
            VALUES (@id,@FacultyID, @CourseID, @StudentID, @AssessmentType, @MarksObtained, @MaxMarks);
        END
        ELSE
        BEGIN
            RAISERROR('Faculty is not authorized to upload marks for this course.', 16, 1);
        END

        -- Commit the transaction if everything is successful
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if there's an error
        ROLLBACK TRANSACTION;

        -- Rethrow the error
        THROW;
    END CATCH
END;
select * from Marks
EXEC UploadStudentMarks
   @id=90,
   @FacultyID = 1, 
   @CourseID = 1,  
   @StudentID = 2,
   @AssessmentType = 'final',  -- Type of assessment (Midterm, Quiz, etc.)
   @MarksObtained = 85.00,  -- Marks obtained by the student
   @MaxMarks = 100.00;  -- Maximum marks for the assessment
--------------------------------------------------------------------------------
--------------------------Update marks----------------------------------
--------------- Create procedure to update student marks-------------
--------------------------------------------------------------------------------
CREATE PROCEDURE UpdateStudentMarks
    @FacultyID INT,            -- Faculty ID who is updating the marks
    @CourseID INT,             -- Course ID where the marks need to be updated
    @StudentID INT,            -- Student ID whose marks are being updated
    @AssessmentType VARCHAR(50),-- Assessment type (Midterm, Quiz, Assignment, etc.)
    @MarksObtained DECIMAL(5,2),-- New marks obtained by the student
    @MaxMarks DECIMAL(5,2)     -- Maximum marks for the assessment
AS
BEGIN
    BEGIN TRANSACTION

    BEGIN TRY
        -- Check if the faculty is authorized to update marks for the given course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            -- Update marks for the student
            IF EXISTS (SELECT 1 FROM Marks WHERE student_id = @StudentID AND course_id = @CourseID AND assessment_type = @AssessmentType)
            BEGIN
                UPDATE Marks
                SET marks_obtained = @MarksObtained, max_marks = @MaxMarks
                WHERE student_id = @StudentID AND course_id = @CourseID AND assessment_type = @AssessmentType;
            END
            ELSE
            BEGIN
                RAISERROR('Marks record not found for the student in this assessment type.', 16, 1);
            END
        END
        ELSE
        BEGIN
            RAISERROR('Faculty is not authorized to update marks for this course.', 16, 1);
        END

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        -- Capture and throw the error
        THROW
    END CATCH
END;
--------------------------------------------------------------------------------
---------------Stored Procedure for Faculty to Delete Marks---------------------
--------------------------------------------------------------------------------
drop procedure DeleteStudentMarks
CREATE PROCEDURE DeleteStudentMarks
    @FacultyID INT,
    @CourseID INT,
    @StudentID INT,
    @AssessmentType VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        -- Check if the faculty is authorized to delete marks for the given course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            -- Perform the delete operation, which will trigger the `trg_AuditDeleteMarks` trigger
            DELETE FROM Marks
            WHERE student_id = @StudentID AND course_id = @CourseID AND assessment_type = @AssessmentType;
        END
        ELSE
        BEGIN
            -- Raise an error if the faculty is not authorized
            RAISERROR('Faculty is not authorized to delete marks for this course.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        -- Re-throw the error
        THROW;
    END CATCH
END;


EXEC DeleteStudentMarks 
   @FacultyID = 1,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 2,  -- Student ID
   @AssessmentType = 'final'; 
---------------------------------------------------------------------------
-----------View for Faculty to View Student Attendance---------------------
--------------------------------------------------------------------------------
select * from FacultyStudentAttendanceView
CREATE VIEW FacultyStudentAttendanceView AS
SELECT 
    f.id AS FacultyID,
    s.id AS StudentID,
    s.name AS StudentName,
    c.id AS CourseID,
    c.name AS CourseName,
    a.status AS AttendanceStatus,
    a.date AS AttendanceDate
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN Attendance a ON c.id = a.course_id
JOIN Students s ON a.student_id = s.id;


-------------------------------------------------------------------------------
-------------------Stored Procedure for Faculty to  U[load Attendance
----------------with transaction-----------------------------------------------
CREATE PROCEDURE UploadStudentAttendance
    @FacultyID INT,
    @CourseID INT,
    @StudentID INT,
    @AttendanceDate DATE,
    @Status VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            IF EXISTS (SELECT 1 FROM Attendance WHERE student_id = @StudentID AND course_id = @CourseID AND date = @AttendanceDate)
            BEGIN
                UPDATE Attendance
                SET status = @Status
                WHERE student_id = @StudentID AND course_id = @CourseID AND date = @AttendanceDate;
            END
            ELSE
            BEGIN
                INSERT INTO Attendance (student_id, course_id, date, status)
                VALUES (@StudentID, @CourseID, @AttendanceDate, @Status);
            END
        END
        ELSE
        BEGIN
            RAISERROR('Faculty is not authorized to upload attendance for this course.', 16, 1);
        END

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        -- Capture and throw the error
        THROW
    END CATCH
END;

------------------------------------------------------------------------------
------------------Stored Procedure for Faculty to Delete Attendance---------
--------------------------------------------------------------------------------
DROP PROCEDURE DeleteStudentAttendance
CREATE PROCEDURE DeleteStudentAttendance
    @FacultyID INT,
    @CourseID INT,
    @StudentID INT,
    @AttendanceDate DATE
AS
BEGIN
    BEGIN TRY
        -- Check if the faculty is authorized to delete attendance for the given course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            DELETE FROM Attendance
            WHERE student_id = @StudentID AND course_id = @CourseID AND date = @AttendanceDate;

            PRINT 'Attendance record deleted successfully.';
        END
        ELSE
        BEGIN
            RAISERROR('Faculty is not authorized to delete attendance for this course.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        -- Capture and throw the error
        THROW;
    END CATCH
END;

drop procedure UpdateStudentAttendance
-------------------------------------------------------------------------------------
---------------------update attendance-----------------------------------------------
---------- Create procedure to update student attendance----------------------------
-------------------------------------------------------------------------------------
CREATE PROCEDURE UpdateStudentAttendance
    @FacultyID INT,            -- Faculty ID who is updating the attendance
    @CourseID INT,             -- Course ID for which attendance is being updated
    @StudentID INT,            -- Student ID whose attendance is being updated
    @AttendanceDate DATE,      -- The date of attendance
    @Status VARCHAR(10)        -- Attendance status (e.g., 'Present', 'Absent')
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION

    BEGIN TRY
        -- Check if the faculty is authorized to update attendance for the given course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            -- Update attendance for the student if record exists
            IF EXISTS (SELECT 1 FROM Attendance WHERE student_id = @StudentID AND course_id = @CourseID AND date = @AttendanceDate)
            BEGIN
                UPDATE Attendance
                SET status = @Status
                WHERE student_id = @StudentID AND course_id = @CourseID AND date = @AttendanceDate;
            END
            ELSE
            BEGIN
                -- If no record found, raise error
                RAISERROR('Attendance record not found for the student on this date.', 16, 1);
            END
        END
        ELSE
        BEGIN
            -- If faculty is not authorized for this course, raise error
            RAISERROR('Faculty is not authorized to update attendance for this course.', 16, 1);
        END

        -- Commit the transaction if everything is successful
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- In case of an error, rollback the transaction
        ROLLBACK TRANSACTION

        -- Capture and rethrow the error to notify the caller
        THROW
    END CATCH
END;
-------------------------------------------------------------------------
--------Faculty Upload Assignment Procedure:---------------------------
------------------------------------------------------------------------



EXEC UploadAssignment 
   @id=7,
    @Title = 'Database Project',
    @Description = 'Submit a complete database design project.',
    @DueDate = '2024-12-15',
    @CourseID = 1,
    @FacultyID = 5;
	EXEC GetStudentAssignmentUploads @StudentID = 1;


CREATE PROCEDURE UploadAssignment
    @id INT,  -- Now accepting id as an input parameter
    @Title NVARCHAR(255),
    @Description NVARCHAR(MAX),
    @DueDate DATETIME,
    @CourseID INT,
    @FacultyID INT
AS
BEGIN
    BEGIN TRY
        -- Temporarily allow inserting into the IDENTITY column
        SET IDENTITY_INSERT Assignments ON;

        -- Insert the assignment into the Assignments table, including the 'id'
        INSERT INTO Assignments (id, title, description, due_date, course_id, faculty_id)
        VALUES (@id, @Title, @Description, @DueDate, @CourseID, @FacultyID);

        -- Retrieve the newly inserted Assignment ID (if needed)
        DECLARE @AssignmentID INT = @id;

        -- Insert records for all students enrolled in the course into StudentAssignments
        INSERT INTO StudentAssignments (student_id, assignment_id)
        SELECT e.student_id, @AssignmentID
        FROM Enrollments e
        WHERE e.course_id = @CourseID;

        PRINT 'Assignment successfully uploaded and assigned to students.';

        -- Turn off IDENTITY_INSERT after insertion
        SET IDENTITY_INSERT Assignments OFF;
    END TRY
    BEGIN CATCH
        -- Handle errors
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--------------------------------------------------------------------------------------------
-------------------------Delete Assigment -------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE PROCEDURE DeleteAssignment
    @id INT  -- The ID of the assignment to be deleted
AS
BEGIN
    BEGIN TRY
        -- Start by deleting records from StudentAssignments where the assignment is referenced
        DELETE FROM StudentAssignments
        WHERE assignment_id = @id;

        -- Then delete the assignment from the Assignments table
        DELETE FROM Assignments
        WHERE id = @id;

        PRINT 'Assignment and associated student assignments successfully deleted.';
    END TRY
    BEGIN CATCH
        -- Handle errors
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

----------------------------------------------------------------------------------
-------------------------------Update Assigment-----------------------------------
------------------------------------TRANSACTION------------------------------------
-- Create procedure to update assignment
CREATE PROCEDURE UpdateAssignment
    @id INT,                    -- Assignment ID
    @Title NVARCHAR(255),       -- New assignment title
    @Description NVARCHAR(MAX), -- Updated assignment description
    @DueDate DATETIME,          -- New assignment due date
    @CourseID INT,              -- Course ID to which the assignment belongs
    @FacultyID INT              -- Faculty ID who is updating the assignment
AS
BEGIN
    BEGIN TRY
        -- Check if the faculty is authorized to update the assignment for this course
        IF EXISTS (SELECT 1 FROM Courses WHERE id = @CourseID AND faculty_id = @FacultyID)
        BEGIN
            -- Update the assignment details
            UPDATE Assignments
            SET title = @Title, description = @Description, due_date = @DueDate
            WHERE id = @id AND course_id = @CourseID;
        END
        ELSE
        BEGIN
            RAISERROR('Faculty is not authorized to update assignment for this course.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        -- Handle errors
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;


------------------------------------------------------------------------------------
-------------View for Faculty to See Overall Student Performance---------------------
------------------------------------------------------------------------------------
CREATE VIEW FacultyStudentPerformanceView AS
SELECT 
    f.id AS FacultyID,
    s.id AS StudentID,
    s.name AS StudentName,
    c.id AS CourseID,
    c.name AS CourseName,
    m.assessment_type AS AssessmentType,
    m.marks_obtained AS MarksObtained,
    m.max_marks AS MaxMarks,
    CAST(m.marks_obtained * 100.0 / m.max_marks AS DECIMAL(5, 2)) AS MarksPercentage,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS DaysPresent,
    COUNT(a.id) AS TotalDays,
    CAST(COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(a.id) AS DECIMAL(5, 2)) AS AttendancePercentage
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN Marks m ON c.id = m.course_id
JOIN Students s ON m.student_id = s.id
JOIN Attendance a ON s.id = a.student_id AND c.id = a.course_id
GROUP BY 
    f.id, s.id, s.name, c.id, c.name, m.assessment_type, m.marks_obtained, m.max_marks;
	select *from FacultyStudentPerformanceView

------------------------------------------------------------------------------------
------------------------FacultyCoursesView-------------------------------------------
--gives which coursse is that by which faculty member 
------------------------------------------------------------------------------------
CREATE VIEW FacultyCoursesView AS
SELECT 
    f.id AS FacultyID,
    c.id AS CourseID,
    c.name AS CourseName,
    c.credits AS CourseCredits,
    COUNT(e.student_id) AS EnrolledStudents
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
LEFT JOIN Enrollments e ON c.id = e.course_id
GROUP BY 
    f.id, c.id, c.name, c.credits;
select * from FacultyCoursesView




----------------------------------------------------------------------------------------------------------
---------------------FacultyTeachingScheduleView---------------------------------------------------------
--Provides a detailed teaching schedule for faculty members, including the day, time, and location of classes.
-----------------------------------------------------------------------------------------------------------
CREATE VIEW FacultyTeachingScheduleView AS
SELECT 
    f.id AS FacultyID,
    f.name AS FacultyName,
    c.name AS CourseName,
    s.day_of_week AS Day,
    s.start_time AS StartTime,
    s.end_time AS EndTime,
    s.room_number AS Room
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN Schedule s ON c.id = s.course_id;
select * from FacultyTeachingScheduleView


------------------------------------------------------------------------------------
----------------------- FacultyStudentFeedbackView----------------------------------
--Displays feedback received by faculty members for their courses.-----------------------
------------------------------------------------------------------------------------
CREATE VIEW FacultyStudentFeedbackView AS
SELECT 
    f.id AS FacultyID,
    f.name AS FacultyName,
    c.id AS CourseID,
    c.name AS CourseName,
    fb.student_id AS StudentID,
    fb.feedback_text AS Feedback,
    fb.rating AS Rating,
    fb.feedback_date AS FeedbackDate
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN Feedback fb ON c.id = fb.course_id;

select * from FacultyStudentFeedbackView 

--Shows progress data for courses taught by faculty members, including completed topics and remaining lectures.
CREATE VIEW FacultyCourseProgressView AS
SELECT 
    f.id AS FacultyID,
    f.name AS FacultyName,
    c.id AS CourseID,
    c.name AS CourseName,
    cp.total_topics AS TotalTopics,
    cp.completed_topics AS CompletedTopics,
    cp.remaining_lectures AS RemainingLectures
FROM 
    Faculty f
JOIN Courses c ON f.id = c.faculty_id
JOIN CourseProgress cp ON c.id = cp.course_id;

select * from  FacultyCourseProgressView


--------------------------------------------------------------------------------
------------------------------------------------------------------------------
---------- ALLPROCEDURE ON FACULTY -------------------------------------------
-------------------------------------------------------------------------------
CREATE PROCEDURE GetFacultyInformation
    @FacultyID INT  -- Input parameter: Faculty ID
AS
BEGIN
    -- 1. Retrieve faculty profile based on FacultyID
    SELECT * 
    FROM FacultyProfileView
    WHERE FacultyID = @FacultyID;  -- Filter by FacultyID

    -- 2. Retrieve courses and enrolled students for the given FacultyID
    SELECT * 
    FROM FacultyCoursesView
    WHERE FacultyID = @FacultyID;  -- Filter by FacultyID

    -- 3. Retrieve teaching schedule for the given FacultyID
    SELECT * 
    FROM FacultyTeachingScheduleView
    WHERE FacultyID = @FacultyID;  -- Filter by FacultyID

    -- 4. Retrieve course progress for the given FacultyID
    SELECT * 
    FROM FacultyCourseProgressView
    WHERE FacultyID = @FacultyID;  -- Filter by FacultyID
END;
-------------------------------------------------------------------------
---------------------SEPRATE PROCEDURE O BASE on ID----------------------
--------------------------------------------------------------------------
-- 1. Faculty Profile Procedure
CREATE PROCEDURE GetFacultyProfile
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyProfileView
    WHERE FacultyID = @FacultyID;
END;

-- 2. Faculty Student Marks Procedure
CREATE PROCEDURE GetFacultyStudentMarks
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyStudentMarksView
    WHERE FacultyID = @FacultyID;
END;

-- 3. Faculty Student Attendance Procedure
CREATE PROCEDURE GetFacultyStudentAttendance
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyStudentAttendanceView
    WHERE FacultyID = @FacultyID;
END;

-- 4. Faculty Student Performance Procedure
CREATE PROCEDURE GetFacultyStudentPerformance
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyStudentPerformanceView
    WHERE FacultyID = @FacultyID;
END;

-- 5. Faculty Courses Procedure
CREATE PROCEDURE GetFacultyCourses
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN 
    SELECT * 
    FROM FacultyCoursesView
    WHERE FacultyID = @FacultyID;
END;

-- 6. Faculty Teaching Schedule Procedure
CREATE PROCEDURE GetFacultyTeachingSchedule
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyTeachingScheduleView
    WHERE FacultyID = @FacultyID;
END;

-- 7. Faculty Student Feedback Procedure
CREATE PROCEDURE GetFacultyStudentFeedback
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyStudentFeedbackView
    WHERE FacultyID = @FacultyID;
END;

-- 8. Faculty Course Progress Procedure
CREATE PROCEDURE GetFacultyCourseProgress
    @FacultyID INT  -- Faculty ID as input parameter
AS
BEGIN
    SELECT * 
    FROM FacultyCourseProgressView
    WHERE FacultyID = @FacultyID;
END;
--------------------------------------------------------------------------------
-------------EXECUTION----------------------------------------------------------
--------------------------------------------------------------------------------
-- Upload an assignment for the faculty and course
EXEC UploadAssignment 
   @id = 7, 
   @Title = 'Database Project',  
   @Description = 'Submit a complete database design project.',  
   @DueDate = '2024-12-15', 
   @CourseID = 1,
   @FacultyID = 5; 
   -------------------delete assigment-
   EXEC DeleteAssignment @id = 7;


-- View for faculty profile details 
SELECT * FROM FacultyProfileView; 

--  View marks of all students for the courses taught by the faculty
SELECT * FROM FacultyStudentMarksView; 

--  View attendance for all students in faculty's courses
SELECT * FROM FacultyStudentAttendanceView; 

--  View overall performance of students (marks and attendance)
SELECT * FROM FacultyStudentPerformanceView; 


--  View the courses the faculty is teaching along with student enrollment
SELECT * FROM FacultyCoursesView;  

-- View teaching schedule for the faculty (day, time, room)
SELECT * FROM FacultyTeachingScheduleView;


--  View feedback from students for the faculty's courses
SELECT * FROM FacultyStudentFeedbackView;  

-- View the course progress for the faculty (completed vs remaining topics)
SELECT * FROM FacultyCourseProgressView;

--  Upload marks for a student in a specific course and assessment
EXEC UploadStudentMarks
@id=80,
   @FacultyID = 1, 
   @CourseID = 1,  
   @StudentID = 2,
   @AssessmentType = 'final',  -- Type of assessment (Midterm, Quiz, etc.)
   @MarksObtained = 85.00,  -- Marks obtained by the student
   @MaxMarks = 100.00;  -- Maximum marks for the assessment

--  Upload attendance for a student in a specific course
EXEC UploadStudentAttendance 
   @FacultyID = 1, 
   @CourseID = 1,  
   @StudentID = 1,  
   @AttendanceDate = '2024-12-10', 
   @Status = 'Present'; 

-- Delete an assignment by assignment ID
EXEC DeleteAssignment @id = 7;  

--  Delete marks for a student in a specific course and assessment
EXEC DeleteStudentMarks 
   @FacultyID = 1,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 2,  -- Student ID
   @AssessmentType = 'Midterm';  

--  Delete attendance for a student in a specific course on a specific date
EXEC DeleteStudentAttendance 
   @FacultyID = 5,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 1,  -- Student ID
   @AttendanceDate = '2024-12-10'; 
   ------------------update marks---
   EXEC UpdateStudentMarks 
    @FacultyID = 5,           
    @CourseID = 1,             
    @StudentID = 1,            
    @AssessmentType = 'Midterm',
    @MarksObtained = 90.00,    
    @MaxMarks = 100.00;         
	----------------update assigmnet--------------
	EXEC UpdateAssignment 
    @id = 7,                   
    @Title = 'Updated Database Project', 
    @Description = 'Submit the updated version of the database design project.', -- New description
    @DueDate = '2024-12-20',    
    @CourseID = 1,                
    @FacultyID = 1;              

	--------------------------update attendance----------
	EXEC UpdateStudentAttendance
    @FacultyID = 1,           
    @CourseID = 1,          
    @StudentID = 1,            
    @AttendanceDate = '2023-09-01',
    @Status = 'Absent';      
	-------------FACULTY ALL INFo IN ONE----------------
	EXEC GetFacultyInformation @FacultyID = 5;

	-----------------------EXECT OF OF ALL STUDENT FOR FRONTEND----------
	--------------------------------------------------------------------------
	-- 1. Get Faculty Profile
EXEC GetFacultyProfile @FacultyID = 1; 

-- 2. Get Faculty Student Marks
EXEC GetFacultyStudentMarks @FacultyID = 5; 

-- 3. Get Faculty Student Attendance
EXEC GetFacultyStudentAttendance @FacultyID = 5;  

-- 4. Get Faculty Student Performance
EXEC GetFacultyStudentPerformance @FacultyID = 5; 

-- 5. Get Faculty Courses
EXEC GetFacultyCourses @FacultyID = 5; 

-- 6. Get Faculty Teaching Schedule
EXEC GetFacultyTeachingSchedule @FacultyID = 5;  

-- 7. Get Faculty Student Feedback
EXEC GetFacultyStudentFeedback @FacultyID = 5; 

-- 8. Get Faculty Course Progress
EXEC GetFacultyCourseProgress @FacultyID = 5;
use p
CREATE USER faculty FOR LOGIN faculty;
-- Grant EXECUTE permissions for all stored procedures to the user 'faculty'
-- Grant EXECUTE permissions for all stored procedures to the user 'faculty'
GRANT EXECUTE ON dbo.UploadAssignment TO faculty;
GRANT EXECUTE ON dbo.GetStudentAssignmentUploads TO faculty;
GRANT EXECUTE ON dbo.UploadStudentMarks TO faculty;
GRANT EXECUTE ON dbo.UploadStudentAttendance TO faculty;
GRANT EXECUTE ON dbo.DeleteAssignment TO faculty;-------------
GRANT EXECUTE ON dbo.DeleteStudentMarks TO faculty;
GRANT EXECUTE ON dbo.DeleteStudentAttendance TO faculty;
GRANT EXECUTE ON dbo.UpdateStudentMarks TO faculty;
GRANT EXECUTE ON dbo.UpdateAssignment TO faculty;
GRANT EXECUTE ON dbo.UpdateStudentAttendance TO faculty;
GRANT EXECUTE ON dbo.GetFacultyInformation TO faculty;----------------------
GRANT EXECUTE ON dbo.GetFacultyProfile TO faculty;------------------
GRANT EXECUTE ON dbo.GetFacultyStudentMarks TO faculty;-------------
GRANT EXECUTE ON dbo.GetFacultyStudentAttendance TO faculty;-------------
GRANT EXECUTE ON dbo.GetFacultyStudentPerformance TO faculty;---------------
GRANT EXECUTE ON dbo.GetFacultyCourses TO faculty;--------------------
GRANT EXECUTE ON dbo.GetFacultyTeachingSchedule TO faculty;--------------
GRANT EXECUTE ON dbo.GetFacultyStudentFeedback TO faculty;------------------
GRANT EXECUTE ON dbo.GetFacultyCourseProgress TO faculty;--------------------
GO


GRANT SELECT ON FacultyProfileView TO faculty;
GRANT SELECT ON FacultyStudentMarksView TO faculty;
GRANT SELECT ON FacultyStudentAttendanceView TO faculty;
GRANT SELECT ON FacultyStudentPerformanceView TO faculty;
GRANT SELECT ON FacultyCoursesView TO faculty;
GRANT SELECT ON FacultyTeachingScheduleView TO faculty;
GRANT SELECT ON FacultyStudentFeedbackView TO faculty;
GRANT SELECT ON FacultyCourseProgressView TO faculty;

GRANT SELECT ON Faculty TO faculty;

GRANT INSERT ON dbo.Assignments TO faculty;
use p

-----------------------------------------------------------------------------
-------------------------------------Triggere---------------------------------
-----------------------------------------------------------------------------

--------------------------------------------------------------------------------------
------------------------------------MARKS insert  TRIGGER----------------------------------------
--------------------------------------------------------------------------------------------

-- Marks table (Assuming a simple schema)
CREATE TABLE Marks (
    student_id INT,
    course_id INT,
    faculty_id INT,
    assessment_type VARCHAR(50),
    marks_obtained DECIMAL(5,2),
    max_marks DECIMAL(5,2),
    PRIMARY KEY (student_id, course_id, assessment_type)
);

-- MarksAuditLog table to store changes
CREATE TABLE MarksAuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyID INT,
    StudentID INT,
    CourseID INT,
    AssessmentType VARCHAR(50),
    MarksObtained DECIMAL(5,2),
    MaxMarks DECIMAL(5,2),
    ChangeType VARCHAR(10),  -- 'Insert' or 'Update'
    ChangeDate DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_MarksAudit
ON Marks
AFTER INSERT
AS
BEGIN
    DECLARE @FacultyID INT, @StudentID INT, @CourseID INT, @AssessmentType VARCHAR(50), 
            @MarksObtained DECIMAL(5,2), @MaxMarks DECIMAL(5,2), @ChangeType VARCHAR(10);

    -- Check if it's an insert
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Capture the details from the inserted row(s)
        SELECT 
            @FacultyID = faculty_id,
            @StudentID = student_id,
            @CourseID = course_id,
            @AssessmentType = assessment_type,
            @MarksObtained = marks_obtained,
            @MaxMarks = max_marks
        FROM inserted;

        -- Set the change type to 'Insert'
        SET @ChangeType = 'Insert';

        -- Insert the record into the audit log table
        INSERT INTO MarksAuditLog (FacultyID, StudentID, CourseID, AssessmentType, MarksObtained, MaxMarks, ChangeType)
        VALUES (@FacultyID, @StudentID, @CourseID, @AssessmentType, @MarksObtained, @MaxMarks, @ChangeType);
    END
END;

INSERT INTO Marks (id,student_id, course_id, faculty_id, assessment_type,assessment_name, marks_obtained, max_marks)
VALUES (21,1, 1, 10, 'Midterm', 'Midterm', 85, 100);
GRANT SELECT ON MarksAuditLog TO faculty;

insert into Marks(id,student_id ,course_id,faculty_id , assessment_type, assessment_name, marks_obtained, max_marks)
        VALUES (100,4,1,1,'assigmnet','assigmnet2',45,50);


		select * from MarksAuditLog
select * from Marks
select *from  courses
use p
DISABLE TRIGGER trg_MarksAudit ON Marks;
ENABLE TRIGGER trg_MarksAudit ON Marks;
---------------------------------------------------------------------------
--------------------------------------------marks delete trigger----------------------
-------------------------------------------------------------------------------




drop trigger trg_AuditDeleteMarks
CREATE TABLE AuditLogs (
    AuditLogID INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for each log
    FacultyID INT NOT NULL, -- ID of the faculty associated with the deleted record
    CourseID INT NOT NULL, -- ID of the course associated with the deleted record
    StudentID INT NOT NULL, -- ID of the student whose record was deleted
    AssessmentType VARCHAR(50) NOT NULL, -- Type of assessment (Midterm, Quiz, etc.)
    Action VARCHAR(10) NOT NULL, -- Action performed (e.g., DELETE)
    PreviousMarksObtained DECIMAL(5,2), -- Marks obtained before deletion
    PreviousMaxMarks DECIMAL(5,2), -- Maximum marks before deletion
    DeletedAt DATETIME NOT NULL, -- Timestamp of the deletion
    DeletedBy NVARCHAR(128) NOT NULL -- User who performed the delete (login)
);

CREATE TRIGGER trg_AuditDeleteMarks
ON Marks
FOR DELETE
AS
BEGIN
    -- Insert details of the deleted row into the AuditLogs table
    INSERT INTO AuditLogs (
        FacultyID, 
        CourseID, 
        StudentID, 
        AssessmentType, 
        Action, 
        PreviousMarksObtained, 
        PreviousMaxMarks, 
        DeletedAt, 
        DeletedBy
    )
    SELECT 
        faculty_id, 
        course_id, 
        student_id, 
        assessment_type, 
        'DELETE', 
        marks_obtained, 
        max_marks, 
        GETDATE(), -- Current timestamp for the delete action
        SYSTEM_USER -- Captures the user who performed the delete
    FROM deleted; -- 'deleted' table contains rows affected by the DELETE operation
END;



EXEC DeleteStudentMarks 
   @FacultyID = 1,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 2,  -- Student ID
   @AssessmentType = 'final'; 


   SELECT * FROM AuditLogs;

EXEC UploadStudentMarks
@id=81,
   @FacultyID = 1, 
   @CourseID = 1,  
   @StudentID = 2,
   @AssessmentType = 'final',  -- Type of assessment (Midterm, Quiz, etc.)
   @MarksObtained = 85.00,  -- Marks obtained by the student
   @MaxMarks = 100.00;




----------------------------------------------------------------
---------------------------------------------------------------
--------------------TRIGGGER FOR THE DELTED ATTENDABCE---------------
--------------------------------------------------------------------------
------------------------------------------------------------------

CREATE TABLE AttendanceLog (
    id INT IDENTITY PRIMARY KEY,
    student_id INT,
    course_id INT,
    date DATE,
    action NVARCHAR(50),
    logged_at DATETIME
);

CREATE TRIGGER trg_AfterDeleteAttendance
ON Attendance
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalRows INT = 0;
    DECLARE @Offset INT = 0;
    DECLARE @Fetch INT = 1; -- Process one row at a time (can adjust if needed)

    -- Get the total number of rows in the DELETED table
    SELECT @TotalRows = COUNT(*) FROM DELETED;

    WHILE @Offset < @TotalRows
    BEGIN
        -- Variables to store current row values
        DECLARE @StudentID INT, @CourseID INT, @AttendanceDate DATE;

        -- Fetch the row using OFFSET and FETCH
        SELECT 
            @StudentID = student_id, 
            @CourseID = course_id, 
            @AttendanceDate = date
        FROM DELETED
        ORDER BY student_id -- Use appropriate ordering for consistent results
        OFFSET @Offset ROWS
        FETCH NEXT @Fetch ROWS ONLY;

        -- Log the deletion in the AttendanceLog table
        INSERT INTO AttendanceLog (student_id, course_id, date, action, logged_at)
        VALUES (@StudentID, @CourseID, @AttendanceDate, 'DELETE', GETDATE());

        -- Increment the offset for the next iteration
        SET @Offset = @Offset + @Fetch;
    END;

    PRINT 'Trigger executed successfully: All deleted attendance records processed.';
END;


 
 select * from FacultyStudentAttendanceView
--  Delete attendance for a student in a specific course on a specific date
EXEC DeleteStudentAttendance 
   @FacultyID = 1,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 1,  -- Student ID
   @AttendanceDate = '2023-09-01';



   SELECT * FROM AttendanceLog

























use p
INSERT INTO Students (id, name, email, program_id, department_id, enrollment_date)
VALUES
(11, 'Alex Carter', 'alex.carter1@university.edu', 1, 1, '2023-08-01'),
(12, 'Samantha Green', 'samantha.green1@university.edu', 1, 1, '2023-08-01'),
(13, 'Daniel Lewis', 'daniel.lewis1@university.edu', 2, 1, '2023-08-01'),
(14, 'Olivia Walker', 'olivia.walker1@university.edu', 2, 1, '2023-08-01'),
(15, 'Ethan Harris', 'ethan.harris1@university.edu', 3, 2, '2023-08-01'),
(16, 'Sophia Martinez', 'sophia.martinez1@university.edu', 3, 2, '2023-08-01'),
(17, 'Benjamin Young', 'benjamin.young1@university.edu', 4, 3, '2023-08-01'),
(18, 'Charlotte King', 'charlotte.king1@university.edu', 4, 3, '2023-08-01'),
(19, 'Lucas Scott', 'lucas.scott1@university.edu', 5, 4, '2023-08-01'),
(20, 'Amelia Adams', 'amelia.adams1@university.edu', 5, 4, '2023-08-01'),
(21, 'James Wright', 'james.wright1@university.edu', 1, 1, '2023-08-01'),
(22, 'Grace Turner', 'grace.turner1@university.edu', 1, 1, '2023-08-01'),
(23, 'Mason Lee', 'mason.lee1@university.edu', 2, 1, '2023-08-01'),
(24, 'Ella Harris', 'ella.harris1@university.edu', 2, 1, '2023-08-01'),
(25, 'Henry Clark', 'henry.clark1@university.edu', 3, 2, '2023-08-01'),
(26, 'Chloe Lewis', 'chloe.lewis1@university.edu', 3, 2, '2023-08-01'),
(27, 'Aiden Walker', 'aiden.walker1@university.edu', 4, 3, '2023-08-01'),
(28, 'Lily Scott', 'lily.scott1@university.edu', 4, 3, '2023-08-01'),
(29, 'Matthew Green', 'matthew.green1@university.edu', 5, 4, '2023-08-01'),
(30, 'Hannah Carter', 'hannah.carter1@university.edu', 5, 4, '2023-08-01'),
(31, 'Jack Allen', 'jack.allen1@university.edu', 1, 1, '2023-08-01'),
(32, 'Zoe Hill', 'zoe.hill1@university.edu', 1, 1, '2023-08-01'),
(33, 'Liam Nelson', 'liam.nelson1@university.edu', 2, 1, '2023-08-01'),
(34, 'Emily Roberts', 'emily.roberts1@university.edu', 2, 1, '2023-08-01'),
(35, 'Gabriel Parker', 'gabriel.parker1@university.edu', 3, 2, '2023-08-01'),
(36, 'Isabella Johnson', 'isabella.johnson1@university.edu', 3, 2, '2023-08-01'),
(37, 'Sebastian Taylor', 'sebastian.taylor1@university.edu', 4, 3, '2023-08-01'),
(38, 'Avery Perez', 'avery.perez1@university.edu', 4, 3, '2023-08-01'),
(39, 'Mila Wilson', 'mila.wilson1@university.edu', 5, 4, '2023-08-01'),
(40, 'Oliver Thompson', 'oliver.thompson1@university.edu', 5, 4, '2023-08-01'),
(41, 'Amos Reed', 'amos.reed1@university.edu', 1, 1, '2023-08-01'),
(42, 'Daisy Moore', 'daisy.moore1@university.edu', 1, 1, '2023-08-01'),
(43, 'Samuel Ward', 'samuel.ward1@university.edu', 2, 1, '2023-08-01'),
(44, 'Eva Morgan', 'eva.morgan1@university.edu', 2, 1, '2023-08-01'),
(45, 'Isaac Fisher', 'isaac.fisher1@university.edu', 3, 2, '2023-08-01'),
(46, 'Aria Coleman', 'aria.coleman1@university.edu', 3, 2, '2023-08-01'),
(47, 'Isaiah Harris', 'isaiah.harris1@university.edu', 4, 3, '2023-08-01'),
(48, 'Addison Bennett', 'addison.bennett1@university.edu', 4, 3, '2023-08-01'),
(49, 'Austin Mitchell', 'austin.mitchell1@university.edu', 5, 4, '2023-08-01'),
(50, 'Madeline Carter', 'madeline.carter1@university.edu', 5, 4, '2023-08-01'),
(51, 'Ryan Cooper', 'ryan.cooper1@university.edu', 1, 1, '2023-08-01'),
(52, 'Chloe Phillips', 'chloe.phillips1@university.edu', 1, 1, '2023-08-01'),
(53, 'Benjamin James', 'benjamin.james1@university.edu', 2, 1, '2023-08-01'),
(54, 'Isabelle Ward', 'isabelle.ward1@university.edu', 2, 1, '2023-08-01'),
(55, 'Gabriel King', 'gabriel.king1@university.edu', 3, 2, '2023-08-01'),
(56, 'Evelyn Clark', 'evelyn.clark1@university.edu', 3, 2, '2023-08-01'),
(57, 'Oliver Adams', 'oliver.adams1@university.edu', 4, 3, '2023-08-01'),
(58, 'Charlotte Thompson', 'charlotte.thompson1@university.edu', 4, 3, '2023-08-01'),
(59, 'Jameson Robinson', 'jameson.robinson1@university.edu', 5, 4, '2023-08-01'),
(60, 'Megan Taylor', 'megan.taylor1@university.edu', 5, 4, '2023-08-01'),
(61, 'Zachary Harris', 'zachary.harris1@university.edu', 1, 1, '2023-08-01'),
(62, 'Lily Reed', 'lily.reed1@university.edu', 1, 1, '2023-08-01'),
(63, 'Jack Wilson', 'jack.wilson1@university.edu', 2, 1, '2023-08-01'),
(64, 'Grace Martin', 'grace.martin1@university.edu', 2, 1, '2023-08-01'),
(65, 'Logan Harris', 'logan.harris1@university.edu', 3, 2, '2023-08-01'),
(66, 'Natalie Johnson', 'natalie.johnson1@university.edu', 3, 2, '2023-08-01'),
(67, 'Luke Taylor', 'luke.taylor1@university.edu', 4, 3, '2023-08-01'),
(68, 'Hannah Allen', 'hannah.allen1@university.edu', 4, 3, '2023-08-01'),
(69, 'Aaron Clark', 'aaron.clark1@university.edu', 5, 4, '2023-08-01'),
(70, 'Victoria Wright', 'victoria.wright1@university.edu', 5, 4, '2023-08-01'),
(71, 'Elijah Moore', 'elijah.moore1@university.edu', 1, 1, '2023-08-01'),
(72, 'Scarlett Lee', 'scarlett.lee1@university.edu', 1, 1, '2023-08-01'),
(73, 'Leo Young', 'leo.young1@university.edu', 2, 1, '2023-08-01'),
(74, 'Lucy Davis', 'lucy.davis1@university.edu', 2, 1, '2023-08-01'),
(75, 'Christopher Martinez', 'christopher.martinez1@university.edu', 3, 2, '2023-08-01'),
(76, 'Victoria Phillips', 'victoria.phillips1@university.edu', 3, 2, '2023-08-01'),
(77, 'Mason Harris', 'mason.harris1@university.edu', 4, 3, '2023-08-01'),
(78, 'Luna Roberts', 'luna.roberts1@university.edu', 4, 3, '2023-08-01'),
(79, 'Alexander Scott', 'alexander.scott1@university.edu', 5, 4, '2023-08-01'),
(80, 'Sophie Walker', 'sophie.walker1@university.edu', 5, 4, '2023-08-01'),
(81, 'Nathan Collins', 'nathan.collins1@university.edu', 1, 1, '2023-08-01'),
(82, 'Leah Walker', 'leah.walker1@university.edu', 1, 1, '2023-08-01'),
(83, 'Maya Evans', 'maya.evans1@university.edu', 2, 1, '2023-08-01'),
(84, 'Ella Carter', 'ella.carter1@university.edu', 2, 1, '2023-08-01'),
(85, 'Liam Young', 'liam.young1@university.edu', 3, 2, '2023-08-01'),
(86, 'Eva Thomas', 'eva.thomas1@university.edu', 3, 2, '2023-08-01'),
(87, 'Samuel Adams', 'samuel.adams1@university.edu', 4, 3, '2023-08-01'),
(88, 'Ava Johnson', 'ava.johnson1@university.edu', 4, 3, '2023-08-01'),
(89, 'Maya Green', 'maya.green1@university.edu', 5, 4, '2023-08-01'),
(90, 'Henry Wilson', 'henry.wilson1@university.edu', 5, 4, '2023-08-01'),
(91, 'Lena Scott', 'lena.scott1@university.edu', 1, 1, '2023-08-01'),
(92, 'James Ward', 'james.ward1@university.edu', 1, 1, '2023-08-01'),
(93, 'Owen Phillips', 'owen.phillips1@university.edu', 2, 1, '2023-08-01'),
(94, 'Charlotte Mitchell', 'charlotte.mitchell1@university.edu', 2, 1, '2023-08-01'),
(95, 'Daniel Morgan', 'daniel.morgan1@university.edu', 3, 2, '2023-08-01'),
(96, 'Abigail Lee', 'abigail.lee1@university.edu', 3, 2, '2023-08-01'),
(97, 'Lucas Clark', 'lucas.clark1@university.edu', 4, 3, '2023-08-01'),
(98, 'Maya Thomas', 'maya.thomas1@university.edu', 4, 3, '2023-08-01'),
(99, 'Elliot Robinson', 'elliot.robinson1@university.edu', 5, 4, '2023-08-01'),
(100, 'Zoe Mitchell', 'zoe.mitchell1@university.edu', 5, 4, '2023-08-01');

INSERT INTO Faculty (id, name, email, department_id, courses_taught)
VALUES
(21, 'Dr. Alexander White', 'alexander.white@university.edu', 1, 'Data Science, Deep Learning'),
(22, 'Dr. Bella Lewis', 'bella.lewis@university.edu', 2, 'Communication Systems, VLSI Design'),
(23, 'Dr. Charlie Thompson', 'charlie.thompson@university.edu', 3, 'Fluid Mechanics, Control Systems'),
(24, 'Dr. Diana Moore', 'diana.moore@university.edu', 4, 'Environmental Engineering, Structural Analysis'),
(25, 'Dr. Edward King', 'edward.king@university.edu', 5, 'Advertising, Brand Management'),
(26, 'Dr. Fiona Davis', 'fiona.davis@university.edu', 6, 'Abstract Algebra, Real Analysis'),
(27, 'Dr. George Taylor', 'george.taylor@university.edu', 7, 'Electrodynamics, Solid State Physics'),
(28, 'Dr. Hannah Brown', 'hannah.brown@university.edu', 8, 'Thermodynamics, Environmental Chemistry'),
(29, 'Dr. Ian Scott', 'ian.scott@university.edu', 9, 'Biotechnology, Biochemistry'),
(30, 'Dr. Julia Martin', 'julia.martin@university.edu', 10, 'Construction Management, Sustainability'),
(31, 'Dr. Kevin Lewis', 'kevin.lewis@university.edu', 1, 'Computer Vision, NLP'),
(32, 'Dr. Lily Williams', 'lily.williams@university.edu', 2, 'Signal Processing, Communication Networks'),
(33, 'Dr. Mark Carter', 'mark.carter@university.edu', 3, 'Aerodynamics, Control Theory'),
(34, 'Dr. Nora Johnson', 'nora.johnson@university.edu', 4, 'Water Resources, Geotechnical Engineering'),
(35, 'Dr. Olivia Martinez', 'olivia.martinez@university.edu', 5, 'Market Research, International Business'),
(36, 'Dr. Peter Green', 'peter.green@university.edu', 6, 'Differential Equations, Fourier Analysis'),
(37, 'Dr. Quinn Harris', 'quinn.harris@university.edu', 7, 'Quantum Field Theory, Theoretical Physics'),
(38, 'Dr. Rachel Adams', 'rachel.adams@university.edu', 8, 'Environmental Impact Assessment, Green Chemistry'),
(39, 'Dr. Samuel Lewis', 'samuel.lewis@university.edu', 9, 'Genomics, Cell Biology'),
(40, 'Dr. Tiffany Moore', 'tiffany.moore@university.edu', 10, 'Urban Planning, Urban Studies'),
(41, 'Dr. Ulysses Wright', 'ulysses.wright@university.edu', 1, 'Artificial Intelligence, Reinforcement Learning'),
(42, 'Dr. Veronica Scott', 'veronica.scott@university.edu', 2, 'Microelectronics, Analog Systems'),
(43, 'Dr. William Taylor', 'william.taylor@university.edu', 3, 'Mechanics of Materials, Robotics'),
(44, 'Dr. Xavier Phillips', 'xavier.phillips@university.edu', 4, 'Soil Mechanics, Structural Engineering'),
(45, 'Dr. Yasmine Turner', 'yasmine.turner@university.edu', 5, 'Consumer Behavior, Strategic Marketing'),
(46, 'Dr. Zachary Adams', 'zachary.adams@university.edu', 6, 'Functional Analysis, Computational Mathematics'),
(47, 'Dr. Ava Carter', 'ava.carter@university.edu', 7, 'Gravitational Waves, Cosmology'),
(48, 'Dr. Benjamin Johnson', 'benjamin.johnson@university.edu', 8, 'Catalysis, Polymer Science'),
(49, 'Dr. Clara Mitchell', 'clara.mitchell@university.edu', 9, 'Pharmacology, Pathology'),
(50, 'Dr. Daniel Walker', 'daniel.walker@university.edu', 10, 'Sustainable Architecture, Smart Cities');

INSERT INTO Marks (id, student_id, course_id, faculty_id, assessment_type, assessment_name, marks_obtained, max_marks)
VALUES
(11, 2, 1, 1, 'Quiz', 'Quiz 1', 8.00, 10.00),
(12, 2, 1, 1, 'Quiz', 'Quiz 2', 7.50, 10.00),
(13, 2, 1, 1, 'Quiz', 'Quiz 3', 9.00, 10.00),
(14, 2, 1, 1, 'Quiz', 'Quiz 4', 8.50, 10.00),
(15, 2, 1, 1, 'Assignment', 'Assignment 1', 18.00, 20.00),
(16, 2, 1, 1, 'Assignment', 'Assignment 2', 19.00, 20.00),
(17, 2, 1, 1, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(18, 2, 1, 1, 'Final', 'Final Exam', 40.00, 50.00),
(19, 2, 1, 1, 'Assignment', 'Assignment 3', 18.00, 20.00),
(20, 2, 1, 1, 'Assignment', 'Assignment 4', 19.00, 20.00),
(22, 3, 2, 2, 'Quiz', 'Quiz 2', 7.50, 10.00),
(23, 3, 2, 2, 'Quiz', 'Quiz 3', 9.00, 10.00),
(24, 3, 2, 2, 'Quiz', 'Quiz 4', 8.50, 10.00),
(25, 3, 2, 2, 'Assignment', 'Assignment 1', 18.00, 20.00),
(26, 3, 2, 2, 'Assignment', 'Assignment 2', 19.00, 20.00),
(27, 3, 2, 2, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(28, 3, 2, 2, 'Final', 'Final Exam', 40.00, 50.00),
(29, 3, 2, 2, 'Assignment', 'Assignment 3', 18.00, 20.00),
(30, 3, 2, 2, 'Assignment', 'Assignment 4', 19.00, 20.00),
(31, 4, 3, 3, 'Quiz', 'Quiz 1', 8.00, 10.00),
(32, 4, 3, 3, 'Quiz', 'Quiz 2', 7.50, 10.00),
(33, 4, 3, 3, 'Quiz', 'Quiz 3', 9.00, 10.00),
(34, 4, 3, 3, 'Quiz', 'Quiz 4', 8.50, 10.00),
(35, 4, 3, 3, 'Assignment', 'Assignment 1', 18.00, 20.00),
(36, 4, 3, 3, 'Assignment', 'Assignment 2', 19.00, 20.00),
(37, 4, 3, 3, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(38, 4, 3, 3, 'Final', 'Final Exam', 40.00, 50.00),
(39, 4, 3, 3, 'Assignment', 'Assignment 3', 18.00, 20.00),
(40, 4, 3, 3, 'Assignment', 'Assignment 4', 19.00, 20.00),
(41, 5, 4, 4, 'Quiz', 'Quiz 1', 8.00, 10.00),
(42, 5, 4, 4, 'Quiz', 'Quiz 2', 7.50, 10.00),
(43, 5, 4, 4, 'Quiz', 'Quiz 3', 9.00, 10.00),
(44, 5, 4, 4, 'Quiz', 'Quiz 4', 8.50, 10.00),
(45, 5, 4, 4, 'Assignment', 'Assignment 1', 18.00, 20.00),
(46, 5, 4, 4, 'Assignment', 'Assignment 2', 19.00, 20.00),
(47, 5, 4, 4, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(48, 5, 4, 4, 'Final', 'Final Exam', 40.00, 50.00),
(49, 5, 4, 4, 'Assignment', 'Assignment 3', 18.00, 20.00),
(50, 5, 4, 4, 'Assignment', 'Assignment 4', 19.00, 20.00),
(51, 6, 5, 5, 'Quiz', 'Quiz 1', 8.00, 10.00),
(52, 6, 5, 5, 'Quiz', 'Quiz 2', 7.50, 10.00),
(53, 6, 5, 5, 'Quiz', 'Quiz 3', 9.00, 10.00),
(54, 6, 5, 5, 'Quiz', 'Quiz 4', 8.50, 10.00),
(55, 6, 5, 5, 'Assignment', 'Assignment 1', 18.00, 20.00),
(56, 6, 5, 5, 'Assignment', 'Assignment 2', 19.00, 20.00),
(57, 6, 5, 5, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(58, 6, 5, 5, 'Final', 'Final Exam', 40.00, 50.00),
(59, 6, 5, 5, 'Assignment', 'Assignment 3', 18.00, 20.00),
(60, 6, 5, 5, 'Assignment', 'Assignment 4', 19.00, 20.00),
(61, 7, 6, 6, 'Quiz', 'Quiz 1', 8.00, 10.00),
(62, 7, 6, 6, 'Quiz', 'Quiz 2', 7.50, 10.00),
(63, 7, 6, 6, 'Quiz', 'Quiz 3', 9.00, 10.00),
(64, 7, 6, 6, 'Quiz', 'Quiz 4', 8.50, 10.00),
(65, 7, 6, 6, 'Assignment', 'Assignment 1', 18.00, 20.00),
(66, 7, 6, 6, 'Assignment', 'Assignment 2', 19.00, 20.00),
(67, 7, 6, 6, 'Midterm', 'Midterm Exam', 22.50, 30.00),
(68, 7, 6, 6, 'Final', 'Final Exam', 40.00, 50.00),
(69, 7, 6, 6, 'Assignment', 'Assignment 3', 18.00, 20.00),
(70, 7, 6, 6, 'Assignment', 'Assignment 4', 19.00, 20.00);
INSERT INTO Enrollments (student_id, course_id)
VALUES
 (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
(2, 1),  (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10),
(3, 1), (3, 2), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 10),
(4, 1), (4, 2), (4, 3), (4, 5), (4, 6), (4, 7), (4, 8), (4, 9), (4, 10),
(5, 1), (5, 2), (5, 3), (5, 4),  (5, 6), (5, 7), (5, 8), (5, 9), (5, 10),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5),  (6, 7), (6, 8), (6, 9), (6, 10),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6),  (7, 8), (7, 9), (7, 10),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7),  (8, 9), (8, 10),
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5), (9, 6), (9, 7), (9, 8),  (9, 10),
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 6), (10, 7), (10, 8), (10, 9), 
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5), (11, 6), (11, 7), (11, 8), (11, 9), (11, 10),
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5), (12, 6), (12, 7), (12, 8), (12, 9), (12, 10),
(13, 1), (13, 2), (13, 3), (13, 4), (13, 5), (13, 6), (13, 7), (13, 8), (13, 9), (13, 10),
(14, 1), (14, 2), (14, 3), (14, 4), (14, 5), (14, 6), (14, 7), (14, 8), (14, 9), (14, 10),
(15, 1), (15, 2), (15, 3), (15, 4), (15, 5), (15, 6), (15, 7), (15, 8), (15, 9), (15, 10),
(16, 1), (16, 2), (16, 3), (16, 4), (16, 5), (16, 6), (16, 7), (16, 8), (16, 9), (16, 10),
(17, 1), (17, 2), (17, 3), (17, 4), (17, 5), (17, 6), (17, 7), (17, 8), (17, 9), (17, 10),
(18, 1), (18, 2), (18, 3), (18, 4), (18, 5), (18, 6), (18, 7), (18, 8), (18, 9), (18, 10),
(19, 1), (19, 2), (19, 3), (19, 4), (19, 5), (19, 6), (19, 7), (19, 8), (19, 9), (19, 10),
(20, 1), (20, 2), (20, 3), (20, 4), (20, 5), (20, 6), (20, 7), (20, 8), (20, 9), (20, 10);

INSERT INTO Attendance (id, student_id, course_id, faculty_id, date, status)
VALUES
(11, 11, 1, 1, '2023-09-01', 'Present'),
(12, 12, 2, 1, '2023-09-01', 'Absent'),
(13, 13, 3, 2, '2023-09-01', 'Present'),
(14, 14, 4, 3, '2023-09-01', 'Present'),
(15, 15, 5, 5, '2023-09-01', 'Absent'),
(16, 16, 6, 6, '2023-09-01', 'Present'),
(17, 17, 7, 7, '2023-09-01', 'Absent'),
(18, 18, 8, 8, '2023-09-01', 'Present'),
(19, 19, 9, 9, '2023-09-01', 'Present'),
(20, 20, 10, 10, '2023-09-01', 'Absent'),
(21, 21, 1, 1, '2023-09-02', 'Present'),
(22, 22, 2, 1, '2023-09-02', 'Absent'),
(23, 23, 3, 2, '2023-09-02', 'Present'),
(24, 24, 4, 3, '2023-09-02', 'Present'),
(25, 25, 5, 5, '2023-09-02', 'Absent'),
(26, 26, 6, 6, '2023-09-02', 'Present'),
(27, 27, 7, 7, '2023-09-02', 'Absent'),
(28, 28, 8, 8, '2023-09-02', 'Present'),
(29, 29, 9, 9, '2023-09-02', 'Present'),
(30, 30, 10, 10, '2023-09-02', 'Absent'),
(31, 31, 1, 1, '2023-09-03', 'Present'),
(32, 32, 2, 1, '2023-09-03', 'Absent'),
(33, 33, 3, 2, '2023-09-03', 'Present'),
(34, 34, 4, 3, '2023-09-03', 'Present'),
(35, 35, 5, 5, '2023-09-03', 'Absent'),
(36, 36, 6, 6, '2023-09-03', 'Present'),
(37, 37, 7, 7, '2023-09-03', 'Absent'),
(38, 38, 8, 8, '2023-09-03', 'Present'),
(39, 39, 9, 9, '2023-09-03', 'Present'),
(40, 40, 10, 10, '2023-09-03', 'Absent'),
(41, 41, 1, 1, '2023-09-04', 'Present'),
(42, 42, 2, 1, '2023-09-04', 'Absent'),
(43, 43, 3, 2, '2023-09-04', 'Present'),
(44, 44, 4, 3, '2023-09-04', 'Present'),
(45, 45, 5, 5, '2023-09-04', 'Absent'),
(46, 46, 6, 6, '2023-09-04', 'Present'),
(47, 47, 7, 7, '2023-09-04', 'Absent'),
(48, 48, 8, 8, '2023-09-04', 'Present'),
(49, 49, 9, 9, '2023-09-04', 'Present'),
(50, 50, 10, 10, '2023-09-04', 'Absent'),
(51, 51, 1, 1, '2023-09-05', 'Present'),
(52, 52, 2, 1, '2023-09-05', 'Absent'),
(53, 53, 3, 2, '2023-09-05', 'Present'),
(54, 54, 4, 3, '2023-09-05', 'Present'),
(55, 55, 5, 5, '2023-09-05', 'Absent'),
(56, 56, 6, 6, '2023-09-05', 'Present'),
(57, 57, 7, 7, '2023-09-05', 'Absent'),
(58, 58, 8, 8, '2023-09-05', 'Present'),
(59, 59, 9, 9, '2023-09-05', 'Present'),
(60, 60, 10, 10, '2023-09-05', 'Absent'),
(61, 61, 1, 1, '2023-09-06', 'Present'),
(62, 62, 2, 1, '2023-09-06', 'Absent'),
(63, 63, 3, 2, '2023-09-06', 'Present'),
(64, 64, 4, 3, '2023-09-06', 'Present'),
(65, 65, 5, 5, '2023-09-06', 'Absent'),
(66, 66, 6, 6, '2023-09-06', 'Present'),
(67, 67, 7, 7, '2023-09-06', 'Absent'),
(68, 68, 8, 8, '2023-09-06', 'Present'),
(69, 69, 9, 9, '2023-09-06', 'Present'),
(70, 70, 10, 10, '2023-09-06', 'Absent'),
(71, 71, 1, 1, '2023-09-07', 'Present'),
(72, 72, 2, 1, '2023-09-07', 'Absent'),
(73, 73, 3, 2, '2023-09-07', 'Present'),
(74, 74, 4, 3, '2023-09-07', 'Present'),
(75, 75, 5, 5, '2023-09-07', 'Absent'),
(76, 76, 6, 6, '2023-09-07', 'Present'),
(77, 77, 7, 7, '2023-09-07', 'Absent'),
(78, 78, 8, 8, '2023-09-07', 'Present'),
(79, 79, 9, 9, '2023-09-07', 'Present'),
(80, 80, 10, 10, '2023-09-07', 'Absent'),
(81, 81, 1, 1, '2023-09-08', 'Present'),
(82, 82, 2, 1, '2023-09-08', 'Absent'),
(83, 83, 3, 2, '2023-09-08', 'Present'),
(84, 84, 4, 3, '2023-09-08', 'Present'),
(85, 85, 5, 5, '2023-09-08', 'Absent'),
(86, 86, 6, 6, '2023-09-08', 'Present'),
(87, 87, 7, 7, '2023-09-08', 'Absent'),
(88, 88, 8, 8, '2023-09-08', 'Present'),
(89, 89, 9, 9, '2023-09-08', 'Present'),
(90, 90, 10, 10, '2023-09-08', 'Absent'),
(91, 91, 1, 1, '2023-09-09', 'Present'),
(92, 92, 2, 1, '2023-09-09', 'Absent'),
(93, 93, 3, 2, '2023-09-09', 'Present'),
(94, 94, 4, 3, '2023-09-09', 'Present'),
(95, 95, 5, 5, '2023-09-09', 'Absent'),
(96, 96, 6, 6, '2023-09-09', 'Present'),
(97, 97, 7, 7, '2023-09-09', 'Absent'),
(98, 98, 8, 8, '2023-09-09', 'Present'),
(99, 99, 9, 9, '2023-09-09', 'Present'),
(100, 100, 10, 10, '2023-09-09', 'Absent');

INSERT INTO SemesterResults (id, student_id, semester, GPA, overall_grade, semester_name, total_credits, total_weighted_score)
VALUES
(1, 1, 'Semester 1', 3.85, 'A', 'Fall 2023', 15, 57.75),
(2, 2, 'Semester 2', 2.95, 'B', 'Spring 2023', 18, 53.10),
(3, 3, 'Semester 3', 3.45, 'B+', 'Fall 2023', 16, 55.20),
(4, 4, 'Semester 4', 3.70, 'A-', 'Spring 2023', 17, 62.90),
(5, 5, 'Semester 5', 2.80, 'B', 'Fall 2023', 14, 39.20),
(6, 6, 'Semester 6', 3.60, 'A-', 'Spring 2023', 16, 57.60),
(7, 7, 'Semester 7', 3.90, 'A', 'Fall 2023', 18, 70.20),
(8, 8, 'Semester 1', 2.65, 'C+', 'Spring 2023', 15, 39.75),
(9, 9, 'Semester 2', 3.50, 'B+', 'Fall 2023', 17, 59.50),
(10, 10, 'Semester 3', 2.50, 'C', 'Spring 2023', 16, 40.00),
(11, 11, 'Semester 4', 3.80, 'A', 'Fall 2023', 18, 68.40),
(12, 12, 'Semester 5', 3.00, 'B', 'Spring 2023', 14, 42.00),
(13, 13, 'Semester 6', 3.55, 'A-', 'Fall 2023', 16, 56.80),
(14, 14, 'Semester 7', 3.30, 'B+', 'Spring 2023', 17, 56.10),
(15, 15, 'Semester 1', 3.10, 'B', 'Fall 2023', 15, 46.50),
(16, 16, 'Semester 2', 3.65, 'A-', 'Spring 2023', 18, 65.70),
(17, 17, 'Semester 3', 3.00, 'B', 'Fall 2023', 14, 42.00),
(18, 18, 'Semester 4', 3.75, 'A', 'Spring 2023', 16, 60.00),
(19, 19, 'Semester 5', 3.20, 'B+', 'Fall 2023', 15, 48.00),
(20, 20, 'Semester 6', 2.85, 'B', 'Spring 2023', 16, 45.60),
(21, 21, 'Semester 7', 3.40, 'B+', 'Fall 2023', 17, 57.80),
(22, 22, 'Semester 1', 3.60, 'A-', 'Spring 2023', 18, 64.80),
(23, 23, 'Semester 2', 2.95, 'B', 'Fall 2023', 16, 47.20),
(24, 24, 'Semester 3', 3.15, 'B+', 'Spring 2023', 17, 53.55),
(25, 25, 'Semester 4', 3.25, 'B+', 'Fall 2023', 16, 52.00),
(26, 26, 'Semester 5', 3.50, 'A-', 'Spring 2023', 17, 59.50),
(27, 27, 'Semester 6', 3.40, 'B+', 'Fall 2023', 15, 51.00),
(28, 28, 'Semester 7', 2.70, 'B', 'Spring 2023', 16, 43.20),
(29, 29, 'Semester 1', 3.85, 'A', 'Fall 2023', 18, 69.30),
(30, 30, 'Semester 2', 2.55, 'C+', 'Spring 2023', 15, 38.25),
(31, 31, 'Semester 3', 3.90, 'A', 'Fall 2023', 18, 70.20),
(32, 32, 'Semester 4', 3.65, 'A-', 'Spring 2023', 16, 58.40),
(33, 33, 'Semester 5', 3.00, 'B', 'Fall 2023', 14, 42.00),
(34, 34, 'Semester 6', 2.95, 'B', 'Spring 2023', 16, 47.20),
(35, 35, 'Semester 7', 3.55, 'A-', 'Fall 2023', 17, 60.35),
(36, 36, 'Semester 1', 3.75, 'A', 'Spring 2023', 18, 67.50),
(37, 37, 'Semester 2', 2.80, 'B', 'Fall 2023', 16, 44.80),
(38, 38, 'Semester 3', 3.60, 'A-', 'Spring 2023', 15, 54.00),
(39, 39, 'Semester 4', 3.25, 'B+', 'Fall 2023', 17, 55.25),
(40, 40, 'Semester 5', 3.45, 'B+', 'Spring 2023', 16, 55.20),
(41, 41, 'Semester 6', 3.30, 'B+', 'Fall 2023', 16, 52.80),
(42, 42, 'Semester 7', 3.80, 'A', 'Spring 2023', 18, 68.40),
(43, 43, 'Semester 1', 3.10, 'B', 'Fall 2023', 14, 43.40),
(44, 44, 'Semester 2', 3.55, 'A-', 'Spring 2023', 17, 60.35),
(45, 45, 'Semester 3', 3.65, 'A-', 'Fall 2023', 16, 58.40),
(46, 46, 'Semester 4', 3.00, 'B', 'Spring 2023', 15, 45.00),
(47, 47, 'Semester 5', 3.85, 'A', 'Fall 2023', 18, 69.30),
(48, 48, 'Semester 6', 3.40, 'B+', 'Spring 2023', 17, 57.80),
(49, 49, 'Semester 7', 3.20, 'B+', 'Fall 2023', 16, 51.20),
(50, 50, 'Semester 1', 3.60, 'A-', 'Spring 2023', 15, 54.00);
--delete SemesterResults
-- Example CourseResults data
-- Inserting Schedule Data

INSERT INTO Schedule (course_id, day_of_week, start_time, end_time, room_number)
VALUES
-- For Dr. Alice Smith
(1, 'Monday', '09:00:00', '10:30:00', 'Room A101'), -- Algorithms
(1, 'Wednesday', '09:00:00', '10:30:00', 'Room A101'), -- Algorithms
(2, 'Tuesday', '11:00:00', '12:30:00', 'Room B202'), -- Data Structures
(2, 'Thursday', '11:00:00', '12:30:00', 'Room B202'), -- Data Structures

-- For Dr. Bob Johnson
(3, 'Friday', '14:00:00', '15:30:00', 'Room C303'), -- Database Systems
(4, 'Monday', '09:00:00', '10:30:00', 'Room A102'), -- Operating Systems
(4, 'Wednesday', '09:00:00', '10:30:00', 'Room A102'), -- Operating Systems

-- For Dr. Carol Lee
(5, 'Monday', '10:00:00', '11:30:00', 'Room B301'), -- Machine Learning
(5, 'Wednesday', '10:00:00', '11:30:00', 'Room B301'), -- Machine Learning
(6, 'Tuesday', '13:00:00', '14:30:00', 'Room C402'), -- AI
(6, 'Thursday', '13:00:00', '14:30:00', 'Room C402'), -- AI

-- For Dr. Dave Allen
(7, 'Monday', '14:00:00', '15:30:00', 'Room D505'), -- Digital Systems
(8, 'Tuesday', '09:00:00', '10:30:00', 'Room E606'), -- Electromagnetics
(9, 'Friday', '16:00:00', '17:30:00', 'Room F707'), -- Robotics
(10, 'Thursday', '14:00:00', '15:30:00', 'Room G808'), -- Fluid Mechanics

-- For Dr. Eve Wilson
(11, 'Wednesday', '11:00:00', '12:30:00', 'Room H909'), -- Hydraulics
(12, 'Friday', '09:00:00', '10:30:00', 'Room I1010'), -- Structural Analysis

-- For Dr. Frank Green
(13, 'Monday', '11:00:00', '12:30:00', 'Room J1111'), -- Marketing
(14, 'Tuesday', '13:00:00', '14:30:00', 'Room K1212'), -- HR Management

-- For Dr. Grace Taylor
(15, 'Wednesday', '14:00:00', '15:30:00', 'Room L1313'), -- Linear Algebra
(16, 'Friday', '13:00:00', '14:30:00', 'Room M1414'), -- Calculus

-- For Dr. Henry White
(17, 'Monday', '10:00:00', '11:30:00', 'Room N1515'), -- Quantum Mechanics
(18, 'Thursday', '10:00:00', '11:30:00', 'Room O1616'), -- Optics

-- For Dr. Irene Scott
(19, 'Tuesday', '14:00:00', '15:30:00', 'Room P1717'), -- Organic Chemistry
(20, 'Thursday', '14:00:00', '15:30:00', 'Room Q1818'); -- Biochemistry

-- Inserting Feedback Data

INSERT INTO Feedback (course_id, student_id, feedback_text, rating, feedback_date)
VALUES
-- For Dr. Alice Smith (Courses: Algorithms, Data Structures)
(1, 1, 'Great teaching style, but needs more examples.', 4, '2024-12-11'), -- Algorithms
(1, 2, 'Excellent explanations and interactive sessions.', 5, '2024-12-11'), -- Algorithms
(2, 3, 'Needs to improve course materials.', 3, '2024-12-11'), -- Data Structures
(2, 4, 'Helpful and approachable faculty.', 5, '2024-12-11'), -- Data Structures

-- For Dr. Bob Johnson (Courses: Database Systems, Operating Systems)
(3, 5, 'The pace of teaching was too fast.', 2, '2024-12-11'), -- Database Systems
(4, 6, 'Clear and concise lectures, but more practical sessions needed.', 4, '2024-12-11'), -- Operating Systems
(4, 7, 'Interesting concepts, but could use more examples.', 3, '2024-12-11'), -- Operating Systems

-- For Dr. Carol Lee (Courses: Machine Learning, AI)
(5, 8, 'Fantastic course! Learned a lot.', 5, '2024-12-11'), -- Machine Learning
(5, 9, 'The assignments were challenging but valuable.', 4, '2024-12-11'), -- Machine Learning
(6, 10, 'Great insights into AI concepts, but too much theory.', 3, '2024-12-11'), -- AI
(6, 11, 'Really enjoyed the practical applications of AI.', 5, '2024-12-11'), -- AI

-- For Dr. Dave Allen (Courses: Digital Systems, Electromagnetics)
(7, 12, 'Good course material, but needs more hands-on labs.', 4, '2024-12-11'), -- Digital Systems
(8, 13, 'The topics were well explained, but the class was too fast-paced.', 3, '2024-12-11'), -- Electromagnetics
(9, 14, 'The course was very engaging with excellent demonstrations.', 5, '2024-12-11'), -- Robotics
(10, 15, 'Fluid Mechanics was well-structured, but some concepts were unclear.', 3, '2024-12-11'), -- Fluid Mechanics

-- For Dr. Eve Wilson (Courses: Hydraulics, Structural Analysis)
(11, 16, 'The course content was very thorough and informative.', 4, '2024-12-11'), -- Hydraulics
(12, 17, 'Some topics were confusing, but the faculty was very helpful.', 3, '2024-12-11'), -- Structural Analysis

-- For Dr. Frank Green (Courses: Marketing, HR Management)
(13, 18, 'Very practical course with great real-world applications.', 5, '2024-12-11'), -- Marketing
(14, 19, 'HR Management was insightful, but could use more case studies.', 4, '2024-12-11'), -- HR Management

-- For Dr. Grace Taylor (Courses: Linear Algebra, Calculus)
(15, 20, 'Linear Algebra was well-paced, but the lectures could be more engaging.', 3, '2024-12-11'), -- Linear Algebra
(16, 21, 'Great teaching in Calculus, but too much theory and not enough practice.', 4, '2024-12-11'), -- Calculus

-- For Dr. Henry White (Courses: Quantum Mechanics, Optics)
(17, 22, 'The course was extremely challenging, but worth it.', 5, '2024-12-11'), -- Quantum Mechanics
(18, 23, 'Optics was very engaging, but could have more real-life applications.', 4, '2024-12-11'), -- Optics

-- For Dr. Irene Scott (Courses: Organic Chemistry, Biochemistry)
(19, 24, 'Organic Chemistry was well-structured, but lacked in-depth examples.', 3, '2024-12-11'), -- Organic Chemistry
(20, 25, 'Biochemistry was very informative, but a bit difficult to follow at times.', 3, '2024-12-11'); -- Biochemistry

-- Inserting Course Progress Data

INSERT INTO CourseProgress (course_id, total_topics, completed_topics, remaining_lectures)
VALUES
-- For Algorithms (course_id 1)
(1, 20, 15, 3),  -- Course ID 1

-- For Data Structures (course_id 2)
(2, 25, 20, 5),  -- Course ID 2

-- For Database Systems (course_id 3)
(3, 30, 18, 6),  -- Course ID 3

-- For Operating Systems (course_id 4)
(4, 28, 22, 4),  -- Course ID 4

-- For Machine Learning (course_id 5)
(5, 35, 30, 3),  -- Course ID 5

-- For AI (course_id 6)
(6, 32, 28, 4),  -- Course ID 6

-- For Digital Systems (course_id 7)
(7, 22, 18, 2),  -- Course ID 7

-- For Electromagnetics (course_id 8)
(8, 24, 20, 3),  -- Course ID 8

-- For Robotics (course_id 9)
(9, 30, 25, 4),  -- Course ID 9

-- For Fluid Mechanics (course_id 10)
(10, 26, 22, 5),  -- Course ID 10

-- For Hydraulics (course_id 11)
(11, 23, 18, 3),  -- Course ID 11

-- For Structural Analysis (course_id 12)
(12, 27, 20, 4),  -- Course ID 12

-- For Marketing (course_id 13)
(13, 19, 15, 2),  -- Course ID 13

-- For HR Management (course_id 14)
(14, 22, 18, 3),  -- Course ID 14

-- For Linear Algebra (course_id 15)
(15, 25, 20, 4),  -- Course ID 15

-- For Calculus (course_id 16)
(16, 28, 22, 5),  -- Course ID 16

-- For Quantum Mechanics (course_id 17)
(17, 30, 25, 4),  -- Course ID 17

-- For Optics (course_id 18)
(18, 20, 16, 3),  -- Course ID 18

-- For Organic Chemistry (course_id 19)
(19, 18, 15, 2),  -- Course ID 19

-- For Biochemistry (course_id 20)
(20, 24, 20, 3);  -- Course ID 20

-- Inserting Assignments Data

INSERT INTO Assignments (title, description, due_date, course_id, faculty_id)
VALUES
-- For Database Project (course_id 1)
('AI Research Paper', 'Write a research paper on a topic in artificial intelligence.', '2025-01-05 00:00:00.000', 1, 5),

-- For Web Development Assignment (course_id 2)
('E-commerce Website', 'Create an e-commerce website with user login and cart functionality.', '2025-01-10 00:00:00.000', 2, 6),

-- For Machine Learning Homework (course_id 3)
('Deep Learning Project', 'Implement a deep learning model for image classification.', '2025-01-15 00:00:00.000', 3, 7),

-- For Software Engineering Case Study (course_id 4)
('Agile Methodology Analysis', 'Analyze and compare the agile methodology with other approaches.', '2025-01-20 00:00:00.000', 4, 8),

-- For Data Structures Exam (course_id 1)
('Final Exam: Data Structures', 'Study all topics in data structures for the final exam.', '2025-01-25 00:00:00.000', 1, 5),

-- For Digital Systems (course_id 7)
('Digital Logic Design', 'Design a digital logic circuit using VHDL.', '2025-02-01 00:00:00.000', 7, 9),

-- For Electromagnetics (course_id 8)
('Electromagnetic Waves Assignment', 'Solve problems related to wave propagation.', '2025-02-05 00:00:00.000', 8, 10),

-- For Robotics (course_id 9)
('Robotics Simulation Project', 'Simulate a robot’s movements using MATLAB.', '2025-02-10 00:00:00.000', 9, 11),

-- For Fluid Mechanics (course_id 10)
('Fluid Dynamics Problem Set', 'Complete the assigned fluid dynamics problem set.', '2025-02-15 00:00:00.000', 10, 12),

-- For Hydraulics (course_id 11)
('Hydraulic Engineering Design', 'Design a hydraulic system for a building.', '2025-02-20 00:00:00.000', 11, 13);