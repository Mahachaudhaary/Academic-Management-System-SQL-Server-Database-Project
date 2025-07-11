use p
select * from Students where id=1
select * from StudentProfileView
SELECT * FROM Student WHERE id = 1


-- Execute the procedure to get Student Profile Information
EXEC GetStudentProfile @StudentID =1 ;

-- Execute the procedure to get Course Enrollments Information
EXEC GetCourseEnrollments @StudentID = 1;

-- Execute the procedure to get Assessment Summary
EXEC GetAssessmentSummary @StudentID = 1;

-- Execute the procedure to get Semester Performance
EXEC GetSemesterPerformance @StudentID = 1;

-- Execute the procedure to get Detailed Student Performance
EXEC GetDetailedStudentPerformance @StudentID = 1;

-- Execute the procedure to get Attendance Summary
EXEC GetAttendanceSummary @StudentID = 1

-- Execute the procedure to get Student Assignment Uploads
EXEC GetStudentAssignmentUploads @StudentID = 1;

-- Execute the procedure to get Previous Semester GPA
EXEC GetPreviousSemesterGPA @StudentID = 4;
EXEC GetPreviousSemesterGPA 2;
EXECUTE  GetMarksCurrentSemester  @StudentID = 1;

-----------------------------------------------------
--------------------------------------------------------
--------------------------------final-----------------------
--------------------------------------------------------
-- Execute the procedure to get Full Student Details
EXEC GetStudentFullDetails @StudentID = 1;
------------------------------------------------
-------------------------------------------
------------------------------------------------
-------------DISPLAY OF STUDENT-------
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

-- Insert an Assignment Upload

INSERT INTO StudentAssignments ( student_id, assignment_id, uploaded_file_path)
VALUES 
    ( 5, 4, 'D:\\Submissions\\NDNBVRBDC.pdf');


	EXEC InsertFeedback 
   @StudentID = 2,        -- Student ID
   @CourseID = 2,         -- Course ID
   @FeedbackText = 'Great course, very informative!',   -- Feedback text
   @Rating = 5;           -- Rating
  
