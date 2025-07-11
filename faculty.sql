use p
select * from Faculty
where id=2
-- Step 1: Upload an assignment for the faculty and course
EXEC UploadAssignment 
   @id = 7, 
   @Title = 'Database Project',  
   @Description = 'Submit a complete database design project.',  
   @DueDate = '2024-12-15', 
   @CourseID = 1,
   @FacultyID = 5; 
  
   -------------------delete assigment-
   EXEC DeleteAssignment @id = 7;


-- Step 3: View for faculty profile details 
SELECT * FROM FacultyProfileView; 

-- Step 4: View marks of all students for the courses taught by the faculty
SELECT * FROM FacultyStudentMarksView; 

-- Step 5: View attendance for all students in faculty's courses
SELECT * FROM FacultyStudentAttendanceView; 

-- Step 6: View overall performance of students (marks and attendance)
SELECT * FROM FacultyStudentPerformanceView; 


-- Step 7: View the courses the faculty is teaching along with student enrollment
SELECT * FROM FacultyCoursesView;  

-- Step 8: View teaching schedule for the faculty (day, time, room)
SELECT * FROM FacultyTeachingScheduleView;


-- Step 9: View feedback from students for the faculty's courses
SELECT * FROM FacultyStudentFeedbackView;  

-- Step 10: View the course progress for the faculty (completed vs remaining topics)
SELECT * FROM FacultyCourseProgressView;

-- Step 11: Upload marks for a student in a specific course and assessment
EXEC UploadStudentMarks 
   @FacultyID = 5, 
   @CourseID = 1,  
   @StudentID = 2,
   @AssessmentType = 'final',  -- Type of assessment (Midterm, Quiz, etc.)
   @MarksObtained = 85.00,  -- Marks obtained by the student
   @MaxMarks = 100.00;  -- Maximum marks for the assessment

-- Step 12: Upload attendance for a student in a specific course
EXEC UploadStudentAttendance 
   @FacultyID = 5, 
   @CourseID = 1,  
   @StudentID = 1,  
   @AttendanceDate = '2024-12-10', 
   @Status = 'absent'; 

-- Step 13: Delete an assignment by assignment ID
EXEC DeleteAssignment @id = 7;  

-- Step 14: Delete marks for a student in a specific course and assessment
EXEC DeleteStudentMarks 
   @FacultyID = 5,  -- Faculty ID
   @CourseID = 1,   -- Course ID
   @StudentID = 1,  -- Student ID
   @AssessmentType = 'Midterm';  

-- Step 15: Delete attendance for a student in a specific course on a specific date
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
    @Status = 'Present';      
	-------------FACULTY ALL INFo IN ONE----------------
	EXEC GetFacultyInformation @FacultyID = 5;

	-----------------------EXECT OF OF ALL STUDENT FOR FRONTEND----------
	--------------------------------------------------------------------------
	-- 1. Get Faculty Profile
EXEC GetFacultyProfile @FacultyID = 5; 

-- 2. Get Faculty Student Marks
EXEC GetFacultyStudentMarks @FacultyID = 1; 

-- 3. Get Faculty Student Attendance
EXEC GetFacultyStudentAttendance @FacultyID = 1;  

-- 4. Get Faculty Student Performance
EXEC GetFacultyStudentPerformance @FacultyID = 1; 

-- 5. Get Faculty Courses
EXEC GetFacultyCourses @FacultyID = 1; 

-- 6. Get Faculty Teaching Schedule
EXEC GetFacultyTeachingSchedule @FacultyID = 1;  

-- 7. Get Faculty Student Feedback
EXEC GetFacultyStudentFeedback @FacultyID = 1; 

-- 8. Get Faculty Course Progress
EXEC GetFacultyCourseProgress @FacultyID = 1;
   SELECT * FROM MarksAuditLog;
