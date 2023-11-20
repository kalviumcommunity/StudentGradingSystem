-- CREATE DATABASE statement (to create the database)
CREATE DATABASE IF NOT EXISTS SGS;

USE SGS;

-- Student Table
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    DateOfBirth DATE
);

-- Teacher Table
CREATE TABLE IF NOT EXISTS Teacher (
    TeacherID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

-- Course Table
CREATE TABLE IF NOT EXISTS Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(255),
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Teacher(TeacherID)
);

-- Admin Table
CREATE TABLE IF NOT EXISTS Admin (
    AdminID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

-- Enrollment Table
CREATE TABLE IF NOT EXISTS Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Grade Table
CREATE TABLE IF NOT EXISTS Grade (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AssignmentName VARCHAR(255),
    Score INT,
    DateGraded DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Report Table
CREATE TABLE IF NOT EXISTS Report (
    ReportID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    GradeID INT,
    ReportContent TEXT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (GradeID) REFERENCES Grade(GradeID)
);

-- DROP TABLE statements (to drop tables if they exist)
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS Grade;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS Student;

-- DROP DATABASE statement (to drop the database if it exists)
DROP DATABASE IF EXISTS SGS;

SHOW TABLES FROM SGS;

ALTER TABLE Student
ADD MiddleName VARCHAR(255);

ALTER TABLE Student
DROP COLUMN MiddleName;






-- Retrieve Student Information
SELECT * FROM Student;

-- Retrieve Course Information
SELECT * FROM Course;

-- Retrieve Teacher Information
SELECT * FROM Teacher;

-- Retrieve Admin Information
SELECT * FROM Admin;

-- Inserting a New Student
INSERT INTO Student (StudentID, FirstName, LastName, Email, DateOfBirth)
VALUES (1, 'John', 'Doe', 'john@example.com', '2000-01-01');

-- Inserting a New Course
INSERT INTO Course (CourseID, CourseName, InstructorID, Description)
VALUES (101, 'Mathematics', 1, 'Introduction to Algebra');

-- Inserting a New Teacher
INSERT INTO Teacher (TeacherID, FirstName, LastName, Email)
VALUES (1, 'Jane', 'Smith', 'jane@example.com');

-- Inserting a New Admin
INSERT INTO Admin (AdminID, FirstName, LastName, Email)
VALUES (1, 'Admin', 'Adminson', 'admin@example.com');

-- Update Student Information
UPDATE Student
SET Email = 'newemail@example.com'
WHERE StudentID = 1;

-- Update Course Information
UPDATE Course
SET Description = 'Algebra and Calculus'
WHERE CourseID = 101;

-- Update Teacher Information
UPDATE Teacher
SET Email = 'newemail@example.com'
WHERE TeacherID = 1;

-- Delete a Student
DELETE FROM Student
WHERE StudentID = 1;

-- Delete a Course
DELETE FROM Course
WHERE CourseID = 101;

-- Delete a Teacher
DELETE FROM Teacher
WHERE TeacherID = 1;





-- Create Roles

-- Administrator Role with Full Access
CREATE ROLE Administrator;

-- Instructor Role for Course and Grade Access
CREATE ROLE Instructor;

-- Parent Role with Limited Access
CREATE ROLE Parent;

-- Grant Permissions to Roles

-- Administrator Role Permissions (Full Access)
GRANT ALL PRIVILEGES ON Student, Course, Teacher, Admin, Enrollment, Grade, Report TO Administrator;

-- Instructor Role Permissions (Course and Grade Access)
GRANT SELECT, UPDATE ON Student TO Instructor;
GRANT SELECT, UPDATE ON Course TO Instructor;
GRANT SELECT, UPDATE ON Grade TO Instructor;

-- Parent Role Permissions (Limited Access)
GRANT SELECT ON Student TO Parent;
GRANT SELECT ON Grade TO Parent;

-- Create User Accounts and Assign Roles

-- Administrator User Account
CREATE USER admin_user IDENTIFIED BY 'admin_password';
GRANT Administrator TO admin_user;

-- Instructor User Account
CREATE USER instructor_user IDENTIFIED BY 'instructor_password';
GRANT Instructor TO instructor_user;

-- Parent User Account
CREATE USER parent_user IDENTIFIED BY 'parent_password';
GRANT Parent TO parent_user;




-- Retrieve Student Information with Enrolled Courses
SELECT Student.StudentID, Student.FirstName, Student.LastName, Course.CourseName
FROM Student
INNER JOIN Enrollment ON Student.StudentID = Enrollment.StudentID
INNER JOIN Course ON Enrollment.CourseID = Course.CourseID;

-- Retrieve Student Grades with Course Information
SELECT Student.FirstName, Student.LastName, Course.CourseName, Grade.Score
FROM Student
INNER JOIN Grade ON Student.StudentID = Grade.StudentID
INNER JOIN Course ON Grade.CourseID = Course.CourseID;

-- Top Performers in a Course using Subquery
SELECT StudentID, Score
FROM Grade
WHERE Score = (SELECT MAX(Score) FROM Grade WHERE CourseID = 101);

-- Students with Maximum Grades in Each Course using GROUP BY
SELECT CourseID, MAX(Score) AS MaxScore
FROM Grade
GROUP BY CourseID;

-- Top 5 Performers in Overall Scores using GROUP BY and ORDER BY
SELECT StudentID, SUM(Score) AS TotalScore
FROM Grade
GROUP BY StudentID
ORDER BY TotalScore DESC
LIMIT 5;

-- Courses with Highest Average Grades using GROUP BY and ORDER BY
SELECT CourseID, AVG(Score) AS AverageScore
FROM Grade
GROUP BY CourseID
ORDER BY AverageScore DESC;
