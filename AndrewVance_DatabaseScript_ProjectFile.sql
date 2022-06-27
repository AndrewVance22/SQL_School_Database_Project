USE master
IF DB_ID('Proj_AV') IS NOT NULL
BEGIN
	ALTER DATABASE LSP_AGV SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE LSP_AGV SET ONLINE;
	DROP DATABASE LSP_AGV;
END
CREATE DATABASE LSP_AGV
GO
USE LSP_AGV

CREATE TABLE dbo.Address
(
	AddressID int NOT NULL IDENTITY (1,1),
	PersonID int NULL,
	AddressType varchar(4) NULL,
	AddressLine varchar(50) NOT NULL,
	City varchar(30) NULL,
	State varchar (10) NULL,
	Country varchar(30) NULL,
	PostalCode varchar(15) NULL,
	CONSTRAINT PK_Address PRIMARY KEY(AddressID)
)

GO
CREATE TABLE dbo.Classlist(
	ClassListID int NOT NULL IDENTITY (1,1),
	SectionID int NOT NULL,
	PersonID int NOT NULL,
	Grade varchar(2) NULL,
	EnrollmentStatus varchar(2) NULL,
	TuitionAmount money NULL,
	CONSTRAINT PK_ClassList Primary KEY (ClassListID)
)

GO
CREATE TABLE dbo.Course
(
	CourseID int NOT NULL IDENTITY (1,1),
	CourseCode varchar(15) NULL,
	CourseTitle varchar(75) NULL,
	TotalWeeks int NULL,
	TotalHours numeric(5,1) NULL,
	FullCourseFee int NULL,
	CourseDescription varchar(500) NULL,
	CONSTRAINT PK_Course Primary Key (CourseID)
)

GO
CREATE TABLE dbo.Faculty
(
	FacultyID int NOT NULL IDENTITY (1,1),
	FacultyFirstName varchar(40) NULL,
	FacultyLastName varchar(50) NULL,
	FacultyEmail varchar(150) NULL,
	PrimaryPhone varchar(20) NULL,
	AlternatePhone varchar(20) NULL,
	FacultyAddressLine varchar(75) NULL,
	FacultyCity varchar(30) NULL,
	FacultyState char(2) NULL,
	FacultyPostalCode char(5) NULL,
	CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID)
)

GO
CREATE TABLE dbo.Payments
(
	PaymentsID int NOT NULL IDENTITY (1,1),
	FacultyID int NULL,
	SectionID int NULL,
	PrimaryInstructor varchar(50) NOT NULL,
	PaymentAmount numeric(9,2) NULL,
	CONSTRAINT PK_Payment PRIMARY KEY (PaymentsID)
)

GO
CREATE TABLE dbo.Person
(
	PersonID int NOT NULL IDENTITY (1,1),
	LastName varchar (50) NULL,
	FirstName varchar (50) NULL,
	MiddleName varchar (50) NULL,
	Gender char(1) NULL,
	Phone varchar(20) NULL,
	Email varchar(100) NULL,
	CONSTRAINT PK_Person PRIMARY KEY (PersonID)
)

GO
CREATE TABLE dbo.Room
(
	RoomID int NOT NULL IDENTITY (1,1),
	RoomName varchar(30) NULL,
	Capacity int NULL,
	CONSTRAINT PK_Room PRIMARY KEY (RoomID)
)

GO
CREATE TABLE dbo.Section
(
	SectionID int NOT NULL IDENTITY (10000,1),
	CourseID int NOT NULL,
	TermID int NOT NULL,
	StartDate date NULL,
	EndDate date NULL,
	Days varchar(10) NULL,
	SectionStatus varchar (50) NULL,
	RoomID int NULL,
	CONSTRAINT PK_Section PRIMARY KEY (SectionID)
)

GO
CREATE TABLE dbo.Term
(
	TermID int NOT NULL IDENTITY (1,1),
	TermCode char(4) NULL,
	TermName varchar(30) NULL,
	CalendarYear int NULL,
	AcademicYear int NULL,
	CONSTRAINT PK_Term PRIMARY KEY (TermID)
)

 GO
 ALTER TABLE dbo.Address
	ADD CONSTRAINT FK_Address_Person FOREIGN KEY(PersonID)
	REFERENCES dbo.Person (PersonID)
 GO
 ALTER TABLE dbo.ClassList
	ADD CONSTRAINT FK_Classlist_Person FOREIGN KEY(PersonID)
	REFERENCES dbo.Person (PersonID)
 GO
 ALTER TABLE dbo.ClassList 
	ADD CONSTRAINT FK_ClassList_Section FOREIGN KEY (SectionID)
	REFERENCES dbo.Section (SectionID)
 GO
 ALTER TABLE dbo.Payments
	ADD CONSTRAINT FK_Payments_Faculty FOREIGN KEY (FacultyID)
	REFERENCES dbo.Faculty (FacultyID)
 GO
 ALTER TABLE dbo.Payments
	ADD CONSTRAINT FK_Payments_Section FOREIGN KEY (SectionID)
	REFERENCES dbo.Section (SectionID)
 GO
 ALTER TABLE dbo.Section
	ADD CONSTRAINT FK_Section_Course FOREIGN KEY (CourseID)
	REFERENCES dbo.Course (CourseID)
 GO
 ALTER TABLE dbo.Section
	ADD CONSTRAINT FK_Section_Room FOREIGN KEY (RoomID)
	REFERENCES dbo.Room (RoomID)
 GO 
 ALTER TABLE dbo.Section
	ADD CONSTRAINT FK_Section_term FOREIGN KEY (TermID)
	REFERENCES dbo.Term (TermID)


INSERT INTO Course --REfresh data for varchar500 descriptions
(
CourseCode,	CourseTitle,TotalWeeks,TotalHours,FullCourseFee,CourseDescription
)
SELECT
	CourseCode,
	CourseTitle,
	TotalWeeks,
	TotalHours,
	FullCourseFee,
	CourseDescription
FROM MyDB_av..Courses15$
UNION
SELECT
	CourseCode,
	CourseTitle,
	TotalWeeks,
	TotalHours,
	FullCourseFee,
	CourseDescription
FROM MyDB_av..Courses19$

INSERT INTO Faculty
(
FacultyFirstName,FacultyLastName,FacultyEmail,PrimaryPhone,AlternatePhone,
FacultyAddressLine,FacultyCity,FacultyState,FacultyPostalCode
)
SELECT
	FacultyFirstName,
	FacultyLastName,
	FacultyEmail,
	PrimaryPhone,
	AlternatePhone,
	FacultyAddressLine,
	FacultyCity,
	FacultyState,
	FacultyPostalCode
FROM MyDB_av..Faculty15$
UNION
SELECT
	FacultyFirstName,
	FacultyLastName,
	FacultyEmail,
	PrimaryPhone,
	AlternatePhone,
	FacultyAddressLine,
	FacultyCity,
	FacultyState,
	FacultyPostalCode
FROM MyDB_av..Faculty19$

SET IDENTITY_INSERT Person ON
INSERT INTO Person
(
PersonID, LastName, FirstName, MiddleName, Gender, Phone, Email
)
SELECT
	PersonID,
	LastName,
	FirstName,
	MiddleName,
	Gender,
	Phone,
	Email
FROM MyDB_av..Persons15$
UNION
SELECT
	PersonID,
	LastName,
	FirstName,
	MiddleName,
	Gender,
	Phone,
	Email
FROM MyDB_av..Persons19$
SET IDENTITY_INSERT Person OFF

INSERT INTO ROOM
(
RoomName, Capacity
)
SELECT
	RoomName,
	Capacity
FROM MyDB_av..Rooms15$


SET IDENTITY_INSERT Term ON
INSERT INTO Term
(
TermID, TermCode, TermName, CalendarYear, AcademicYear
)
SELECT
	TermID,
	TermCode,
	TermName,
	CalendarYear,
	AcademicYear
FROM MyDB_av..Terms15$
UNION
SELECT
	TermID,
	TermCode,
	TermName,
	CalendarYear,
	AcademicYear
FROM MyDB_av..Terms19$
SET IDENTITY_INSERT TERM OFF

SET IDENTITY_INSERT SECTION ON
INSERT INTO Section
(
SectionID, CourseID, TermID, StartDate,	EndDate, Days, SectionStatus, R.RoomID
)
SELECT
	SectionID,
	C.CourseID,
	TermID,
	StartDate,
	EndDate,
	Days,
	SectionStatus,
	R.RoomID
FROM MyDB_av..['Sections SU11-SU15$'] S
LEFT JOIN ROOM R
	ON R.RoomName = S.RoomName
LEFT JOIN Course C
	ON C.CourseCode = S.CourseCode
UNION
SELECT
	SectionID,
	C.CourseID,
	TermID,
	StartDate,
	EndDate,
	Days,
	SectionStatus,
	R.RoomID
FROM MyDB_av..['Sections FA15-SU19$'] S
LEFT JOIN Room R
	ON R.RoomName = S.RoomName
LEFT JOIN COURSE C
	ON C.CourseCode = S.CourseCode
SET IDENTITY_INSERT Section OFF

INSERT INTO Payments
(
FacultyID, SectionID, PrimaryInstructor,PaymentAmount
)
SELECT
	F.FacultyID,
	S.SectionID,
	'Y',
	S.PrimaryPayment
FROM MyDB_av..['Sections FA15-SU19$'] S
JOIN Faculty F
	ON CONCAT(LEFT(FacultyFirstName,1),'. ',FacultyLastName) = S.PrimaryInstructor
UNION
SELECT
	F.FacultyID,
	S.SectionID,
	'Y',
	S.PrimaryPayment
FROM MyDB_av..['Sections SU11-SU15$'] S
JOIN Faculty F
	ON CONCAT(LEFT(FacultyFirstName,1),'. ',FacultyLastName) = S.PrimaryInstructor
UNION
SELECT
	F.FacultyID,
	S.SectionID,
	'N',
	S.SecondaryPayment
FROM MyDB_av..['Sections FA15-SU19$'] S
JOIN Faculty F
	ON CONCAT(LEFT(FacultyFirstName,1),'. ',FacultyLastName) = S.SecondaryInstructor
SELECT
	F.FacultyID,
	S.SectionID,
	'N',
	S.SecondaryPayment
FROM MyDB_av..['Sections SU11-SU15$'] S
JOIN Faculty F
	ON CONCAT(LEFT(FacultyFirstName,1),'. ',FacultyLastName) = S.SecondaryInstructor


INSERT INTO Address
(
AddressType, AddressLine, City, State, PostalCode, Country, PersonID
)
SELECT
	'Home',
	AddressLine,
	City,
	State,
	PostalCode,
	NULL,
	PersonID
FROM MyDB_av..Persons15$
WHERE AddressLine IS NOT NULL
UNION
SELECT
	'Home',
	AddressLine,
	City,
	State,
	PostalCode,
	NULL,
	PersonID
FROM MyDB_av..Persons19$
WHERE AddressLine IS NOT NULL

INSERT INTO ClassList
(
SectionID, PersonID, Grade, EnrollmentStatus, TuitionAmount
)
SELECT
	SectionID,
	PersonID,
	Grade,
	EnrollmentStatus,
	TuitionAmount
FROM MyDB_av..['ClassList FA15-SU19$']
UNION
SELECT
	SectionID,
	PersonID,
	Grade,
	EnrollmentStatus,
	TuitionAmount
FROM MyDB_av..['ClassList SU11-SU15$']

GO
CREATE VIEW CourseRevenue_V AS 
SELECT
	C.CourseCode,
	C.CourseTitle,
	COUNT(DISTINCT S.SectionID) AS SectionCount,
	SUM(CL.TuitionAmount) AS TotalRevenue,
	CAST(SUM(CL.TuitionAmount)/CAST(COUNT(DISTINCT S.SectionID) AS numeric) AS numeric(9,2)) AS AverageRevenue
FROM Course C
LEFT JOIN Section S
	ON S. CourseID = C.CourseID AND S.SectionStatus != 'CN'
LEFT JOIN Classlist CL
	ON CL.SectionID = S.SectionID

GROUP BY C.CourseCode, C.CourseTitle


GO
CREATE VIEW AnnualRevenue_v AS
WITH CTE AS
(
SELECT
	S.SectionID,
	SUM(CL.TuitionAmount) AS TotalTuition
FROM Section S
JOIN ClassList CL
	ON CL.SectionID = S.SectionID
GROUP BY S.SectionID
)
SELECT
	T.AcademicYear,
	SUM(CTE.TotalTuition) AS TotalTuition,
	SUM(P.PaymentAmount) AS TotalFacultyPayments
FROM Course C
JOIN Section S
	ON S.CourseID = C.CourseID
JOIN Term T
	ON T.TermID = S.TermID
LEFT JOIN Payments P
	ON P.SectionID = S.SectionID
LEFT JOIN CTE
	ON CTE.SectionID = S.SectionID
GROUP BY T.AcademicYear


GO
CREATE PROC StudentHistory_p @PersonID int AS
SELECT
	CONCAT(P.FirstName,' ',P.LastName) AS StudentName,
	S.SectionID,
	C.CourseCode,
	C.CourseTitle,
	CONCAT(F.FacultyFirstName,' ',F.FacultyLastName) AS FacultyName,
	T.TermCode,
	S.StartDate,
	CL.TuitionAmount,
	CL.Grade
FROM Person P
JOIN Classlist CL
	ON CL.PersonID = P.PersonID
JOIN Section S
	ON S.SectionID = CL.SectionID
JOIN Term T
	ON T.TermID = S.TermID
JOIN Course C
	ON C.CourseID = S.CourseID
JOIN Payments Pay
	ON Pay.SectionID = S.SectionID AND PAY.PrimaryInstructor = 'Y'
JOIN Faculty F
	ON F.FacultyID = Pay.FacultyID
WHERE P.PersonID = @PersonID
ORDER BY StartDate


GO
CREATE PROC InsertPerson_p
	@FirstName varchar(35),
	@LastName varchar(50),
	@AddressType varchar(10),
	@AddressLine varchar(50),
	@City varchar(25)
AS
CREATE TABLE #Person(PersonID int)
INSERT INTO Person
(FirstName, LastName)
OUTPUT inserted.PersonID INTO #Person
VALUES (@FirstName, @LastName)

INSERT INTO Address
(AddressType, AddressLine, City, PersonID)
SELECT
	@AddressType,
	@AddressLine,
	@City,
	#Person.PersonID
FROM #Person


GO




SELECT * FROM CourseRevenue_V ORDER BY CourseCode
SELECT * FROM AnnualRevenue_v ORDER BY AcademicYear

EXEC StudentHistory_p 1400
EXEC InsertPerson_p 'Eric','Williamson','work','500 Elm St.','North Pole'

SELECT TOP 1 * FROM Person ORDER BY PersonID DESC
SELECT TOP 1 * FROM Address ORDER BY AddressID DESC
