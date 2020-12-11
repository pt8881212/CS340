-- MY WEBSITE LINK
-- http://web.engr.oregonstate.edu/~agap/cs340/index.php






-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 11, 2020 at 05:40 AM
-- Server version: 10.4.15-MariaDB-log
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_agap`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`cs340_agap`@`%` PROCEDURE `InitDeptStats` ()  NO SQL
INSERT INTO DEPT_STATS
	SELECT Dno, Count(*), AVG(Salary)
    FROM DEPARTMENT, EMPLOYEE
    WHERE DEPARTMENT.Dnumber = EMPLOYEE.Dno
    GROUP by Dno$$

--
-- Functions
--
CREATE DEFINER=`cs340_agap`@`%` FUNCTION `PayLevel` (`SSN` INT) RETURNS VARCHAR(15) CHARSET utf8 NO SQL
BEGIN	
	DECLARE Emp_sal DECIMAL(10,2);
    DECLARE Avg_sal DECIMAL(10,2);
    
    SELECT E.Salary INTO Emp_sal
    FROM EMPLOYEE AS E
    WHERE E.Ssn = SSN
    GROUP BY E.Ssn;
    
    SELECT DEP.Avg_salary INTO Avg_sal
    FROM EMPLOYEE AS E, DEPT_STATS AS DEP
    WHERE E.Dno = DEP.Dnumber AND E.Ssn = SSN;
    
    IF (Emp_sal = Avg_sal) THEN
    	RETURN 'Average';
    END IF;
    IF(Emp_sal > Avg_sal)THEN
    	RETURN 'Above Average';
    END IF;
    	RETURN 'Below Average'; 
      
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `COURSE`
--

CREATE TABLE `COURSE` (
  `Course_name` varchar(30) NOT NULL,
  `Course_number` varchar(8) NOT NULL,
  `Credit_hours` int(1) NOT NULL,
  `Department` char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `COURSE`
--

INSERT INTO `COURSE` (`Course_name`, `Course_number`, `Credit_hours`, `Department`) VALUES
('Data Structures', 'CS261', 4, 'CS'),
('Web Dev', 'CS290', 4, 'CS'),
('Algorithms', 'CS325', 4, 'CS'),
('Database', 'CS340', 4, 'CS'),
('Discrete Math', 'MTH231', 4, 'MTH'),
('Differential Calculus', 'MTH251', 4, 'MTH');

-- --------------------------------------------------------

--
-- Table structure for table `DEPARTMENT`
--

CREATE TABLE `DEPARTMENT` (
  `Dname` varchar(20) NOT NULL,
  `Dnumber` int(2) NOT NULL CHECK (`Dnumber` > 0 and `Dnumber` < 21),
  `Mgr_ssn` char(9) NOT NULL,
  `Mgr_start_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `DEPARTMENT`
--

INSERT INTO `DEPARTMENT` (`Dname`, `Dnumber`, `Mgr_ssn`, `Mgr_start_date`) VALUES
('Headquarters', 1, '888665555', '1981-06-19'),
('Administration', 4, '987654321', '1995-01-01'),
('Research', 5, '333445555', '1988-05-22');

-- --------------------------------------------------------

--
-- Table structure for table `DEPENDENT`
--

CREATE TABLE `DEPENDENT` (
  `Essn` char(9) NOT NULL,
  `Dependent_name` varchar(15) NOT NULL,
  `Sex` char(1) NOT NULL,
  `Bdate` date NOT NULL,
  `Relationship` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `DEPENDENT`
--

INSERT INTO `DEPENDENT` (`Essn`, `Dependent_name`, `Sex`, `Bdate`, `Relationship`) VALUES
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('333445555', 'Alice', 'F', '1986-04-04', 'Daughter'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse');

-- --------------------------------------------------------

--
-- Table structure for table `DEPT_LOCATIONS`
--

CREATE TABLE `DEPT_LOCATIONS` (
  `Dnumber` int(2) NOT NULL,
  `Dlocation` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `DEPT_LOCATIONS`
--

INSERT INTO `DEPT_LOCATIONS` (`Dnumber`, `Dlocation`) VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Houston'),
(5, 'Sugarland');

-- --------------------------------------------------------

--
-- Table structure for table `DEPT_STATS`
--

CREATE TABLE `DEPT_STATS` (
  `Dnumber` int(2) NOT NULL,
  `Emp_count` int(11) NOT NULL,
  `Avg_salary` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `DEPT_STATS`
--

INSERT INTO `DEPT_STATS` (`Dnumber`, `Emp_count`, `Avg_salary`) VALUES
(1, 2, '0.00'),
(4, 3, '31000.00'),
(5, 4, '33250.00');

-- --------------------------------------------------------

--
-- Table structure for table `EMPLOYEE`
--

CREATE TABLE `EMPLOYEE` (
  `Fname` varchar(15) NOT NULL,
  `Lname` varchar(15) NOT NULL,
  `Ssn` char(9) NOT NULL,
  `Bdate` date NOT NULL,
  `Address` varchar(30) NOT NULL,
  `Sex` char(1) NOT NULL,
  `Salary` decimal(10,2) NOT NULL,
  `Super_ssn` char(9) DEFAULT NULL,
  `Dno` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `EMPLOYEE`
--

INSERT INTO `EMPLOYEE` (`Fname`, `Lname`, `Ssn`, `Bdate`, `Address`, `Sex`, `Salary`, `Super_ssn`, `Dno`) VALUES
('John', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston TX', 'M', '30000.00', '333445555', 5),
('Franklin', 'Wong', '333445555', '1965-12-08', '638 Voss, Houston TX', 'M', '40000.00', '888665555', 5),
('Joyce', 'English', '453453453', '1972-07-31', '5631 Rice, Houston TX', 'F', '25000.00', '333445555', 5),
('Ramesh', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble TX', 'M', '38000.00', '333445555', 5),
('James', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston TX', 'M', '55000.00', NULL, 1),
('Jennifer', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire TX', 'F', '43000.00', '888665555', 4),
('Ahmad', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston TX', 'M', '25000.00', '987654321', 4),
('Alicia', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring TX', 'F', '25000.00', '987654321', 4);

--
-- Triggers `EMPLOYEE`
--
DELIMITER $$
CREATE TRIGGER `DELETEDeptStats` AFTER DELETE ON `EMPLOYEE` FOR EACH ROW BEGIN
	IF (OLD.Dno IS NOT NULL) THEN
        UPDATE DEPT_STATS
        SET Avg_salary = Avg_salary - OLD.Salary
        WHERE DEPT_STATS.Dnumber = OLD.Dno;
    END IF;
    
    	UPDATE DEPT_STATS
        	SET Emp_count = Emp_count - 1 WHERE
            DEPT_STATS.Dnumber = OLD.Dno;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `INSERTDeptStats` AFTER INSERT ON `EMPLOYEE` FOR EACH ROW BEGIN
	IF(New.Dno IS NOT NULL)THEN
   		UPDATE DEPT_STATS
    	SET Avg_salary = Avg_salary + New.Salary
    	WHERE DEPT_STATS.Dnumber = New.Dno;
   
        	UPDATE DEPT_STATS
       		SET Emp_count = Emp_count + 1 WHERE
            DEPT_STATS.Dnumber = New.Dno;
     END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UPDATEDeptStats` AFTER UPDATE ON `EMPLOYEE` FOR EACH ROW BEGIN
-- remove old salary
	IF(OLD.Dno IS NOT NULL) THEN
		UPDATE DEPT_STATS
    	SET Avg_salary = Avg_salary - OLD.Salary
    	WHERE DEPT_STATS.Dnumber = OLD.Dno;
    END IF;
-- update new salary 
	IF (NEW.Dno IS NOT NULL) THEN
    	UPDATE DEPT_STATS
    	SET Avg_salary = Avg_salary + New.Salary
    	WHERE DEPT_STATS.Dnumber = NEW.Dno;
    END IF;
    
      UPDATE DEPT_STATS
        	SET Emp_count = Emp_count + 1 WHERE
            DEPT_STATS.Dnumber = OLD.Dno;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `GRADE_REPORT`
--

CREATE TABLE `GRADE_REPORT` (
  `Student_number` char(8) NOT NULL,
  `Section_identifier` int(11) NOT NULL,
  `Grade` varchar(2) NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `GRADE_REPORT`
--

INSERT INTO `GRADE_REPORT` (`Student_number`, `Section_identifier`, `Grade`) VALUES
('111', 112, 'D'),
('111', 166, 'A'),
('111', 444, 'A'),
('111', 555, 'A-'),
('222', 213, 'A'),
('222', 222, 'A'),
('222', 300, 'A'),
('222', 444, 'B'),
('333', 213, 'C'),
('555', 112, 'B'),
('555', 555, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `PREREQUISITE`
--

CREATE TABLE `PREREQUISITE` (
  `Course_number` varchar(8) NOT NULL,
  `Pre_number` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PREREQUISITE`
--

INSERT INTO `PREREQUISITE` (`Course_number`, `Pre_number`) VALUES
('CS325', 'CS261'),
('CS325', 'MTH251'),
('CS340', 'CS290');

-- --------------------------------------------------------

--
-- Table structure for table `PROJECT`
--

CREATE TABLE `PROJECT` (
  `Pname` varchar(20) NOT NULL,
  `Pnumber` int(4) NOT NULL,
  `Plocation` varchar(20) NOT NULL,
  `Dnum` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `PROJECT`
--

INSERT INTO `PROJECT` (`Pname`, `Pnumber`, `Plocation`, `Dnum`) VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

-- --------------------------------------------------------

--
-- Table structure for table `SECTION`
--

CREATE TABLE `SECTION` (
  `Section_id` int(11) NOT NULL,
  `Course_number` varchar(8) NOT NULL,
  `Semester` varchar(8) NOT NULL,
  `Year` int(4) NOT NULL,
  `Instructor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `SECTION`
--

INSERT INTO `SECTION` (`Section_id`, `Course_number`, `Semester`, `Year`, `Instructor`) VALUES
(112, 'CS261', 'Fall', 2017, 'Smith'),
(166, 'MTH231', 'Fall', 2018, 'Lee'),
(213, 'MTH251', 'Spring', 2018, 'Lee'),
(222, 'CS290', 'Spring', 2018, 'Roberts'),
(300, 'CS261', 'Fall', 2018, 'Johnson'),
(444, 'CS261', 'Fall', 2018, 'Smith'),
(555, 'CS325', 'Spring', 2018, 'Jones');

-- --------------------------------------------------------

--
-- Table structure for table `STUDENT`
--

CREATE TABLE `STUDENT` (
  `Name` varchar(30) NOT NULL,
  `Student_number` char(8) NOT NULL,
  `Class` int(11) NOT NULL,
  `Major` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `STUDENT`
--

INSERT INTO `STUDENT` (`Name`, `Student_number`, `Class`, `Major`) VALUES
('Amy', '111', 3, 'CS'),
('Bob', '222', 3, 'MTH'),
('Dave', '333', 3, 'CS'),
('Chris', '555', 4, 'CS'),
('Steve', '789', 4, 'MTH');

-- --------------------------------------------------------

--
-- Table structure for table `WORKS_ON`
--

CREATE TABLE `WORKS_ON` (
  `Essn` char(9) NOT NULL,
  `Pno` int(2) NOT NULL,
  `Hours` decimal(3,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `WORKS_ON`
--

INSERT INTO `WORKS_ON` (`Essn`, `Pno`, `Hours`) VALUES
('123456789', 1, '32.5'),
('123456789', 2, '7.5'),
('333445555', 2, '10.0'),
('333445555', 3, '10.0'),
('333445555', 10, '10.0'),
('333445555', 20, '10.0'),
('453453453', 1, '20.0'),
('453453453', 2, '20.0'),
('666884444', 3, '40.0'),
('888665555', 20, NULL),
('987654321', 20, '15.0'),
('987654321', 30, '20.0'),
('987987987', 10, '35.0'),
('987987987', 30, '5.0'),
('999887777', 10, '10.0'),
('999887777', 30, '30.0');

--
-- Triggers `WORKS_ON`
--
DELIMITER $$
CREATE TRIGGER `MaxTotalHours` BEFORE INSERT ON `WORKS_ON` FOR EACH ROW BEGIN
	DECLARE counter integer;
    DECLARE customMessage VARCHAR(100);
    SELECT COUNT(*) INTO counter
    	FROM WORKS_ON
        WHERE Hours = New.Hours;
	IF(counter > 40) THEN
    	SET customMessage = concat('Error 40 hours exceeded');
        SIGNAL SQLSTATE'45000' SET MESSAGE_TEXT = customMessage;
        
    END IF;
   
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `COURSE`
--
ALTER TABLE `COURSE`
  ADD PRIMARY KEY (`Course_number`);

--
-- Indexes for table `DEPARTMENT`
--
ALTER TABLE `DEPARTMENT`
  ADD PRIMARY KEY (`Dnumber`),
  ADD UNIQUE KEY `Dname` (`Dname`),
  ADD KEY `depemp` (`Mgr_ssn`);

--
-- Indexes for table `DEPENDENT`
--
ALTER TABLE `DEPENDENT`
  ADD PRIMARY KEY (`Essn`,`Dependent_name`);

--
-- Indexes for table `DEPT_LOCATIONS`
--
ALTER TABLE `DEPT_LOCATIONS`
  ADD PRIMARY KEY (`Dnumber`,`Dlocation`);

--
-- Indexes for table `EMPLOYEE`
--
ALTER TABLE `EMPLOYEE`
  ADD PRIMARY KEY (`Ssn`),
  ADD UNIQUE KEY `Fullname` (`Fname`,`Lname`),
  ADD KEY `Dno` (`Dno`),
  ADD KEY `empemp` (`Super_ssn`);

--
-- Indexes for table `GRADE_REPORT`
--
ALTER TABLE `GRADE_REPORT`
  ADD PRIMARY KEY (`Student_number`,`Section_identifier`),
  ADD KEY `Section_identifier` (`Section_identifier`);

--
-- Indexes for table `PREREQUISITE`
--
ALTER TABLE `PREREQUISITE`
  ADD PRIMARY KEY (`Course_number`,`Pre_number`),
  ADD KEY `Pre_number` (`Pre_number`);

--
-- Indexes for table `PROJECT`
--
ALTER TABLE `PROJECT`
  ADD PRIMARY KEY (`Pnumber`),
  ADD UNIQUE KEY `Pname` (`Pname`),
  ADD KEY `Dnum` (`Dnum`);

--
-- Indexes for table `SECTION`
--
ALTER TABLE `SECTION`
  ADD PRIMARY KEY (`Section_id`),
  ADD KEY `Course_number` (`Course_number`);

--
-- Indexes for table `STUDENT`
--
ALTER TABLE `STUDENT`
  ADD PRIMARY KEY (`Student_number`);

--
-- Indexes for table `WORKS_ON`
--
ALTER TABLE `WORKS_ON`
  ADD PRIMARY KEY (`Essn`,`Pno`),
  ADD KEY `Pno` (`Pno`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `DEPARTMENT`
--
ALTER TABLE `DEPARTMENT`
  ADD CONSTRAINT `depemp` FOREIGN KEY (`Mgr_ssn`) REFERENCES `EMPLOYEE` (`Ssn`);

--
-- Constraints for table `DEPENDENT`
--
ALTER TABLE `DEPENDENT`
  ADD CONSTRAINT `DEPENDENT_ibfk_1` FOREIGN KEY (`Essn`) REFERENCES `EMPLOYEE` (`Ssn`);

--
-- Constraints for table `DEPT_LOCATIONS`
--
ALTER TABLE `DEPT_LOCATIONS`
  ADD CONSTRAINT `DEPT_LOCATIONS_ibfk_1` FOREIGN KEY (`Dnumber`) REFERENCES `DEPARTMENT` (`Dnumber`);

--
-- Constraints for table `EMPLOYEE`
--
ALTER TABLE `EMPLOYEE`
  ADD CONSTRAINT `EMPLOYEE_ibfk_1` FOREIGN KEY (`Dno`) REFERENCES `DEPARTMENT` (`Dnumber`),
  ADD CONSTRAINT `empemp` FOREIGN KEY (`Super_ssn`) REFERENCES `EMPLOYEE` (`Ssn`);

--
-- Constraints for table `GRADE_REPORT`
--
ALTER TABLE `GRADE_REPORT`
  ADD CONSTRAINT `GRADE_REPORT_ibfk_1` FOREIGN KEY (`Section_identifier`) REFERENCES `SECTION` (`Section_id`),
  ADD CONSTRAINT `GRADE_REPORT_ibfk_2` FOREIGN KEY (`Student_number`) REFERENCES `STUDENT` (`Student_number`);

--
-- Constraints for table `PREREQUISITE`
--
ALTER TABLE `PREREQUISITE`
  ADD CONSTRAINT `PREREQUISITE_ibfk_1` FOREIGN KEY (`Course_number`) REFERENCES `COURSE` (`Course_number`),
  ADD CONSTRAINT `PREREQUISITE_ibfk_2` FOREIGN KEY (`Pre_number`) REFERENCES `COURSE` (`Course_number`);

--
-- Constraints for table `PROJECT`
--
ALTER TABLE `PROJECT`
  ADD CONSTRAINT `PROJECT_ibfk_1` FOREIGN KEY (`Dnum`) REFERENCES `DEPARTMENT` (`Dnumber`);

--
-- Constraints for table `SECTION`
--
ALTER TABLE `SECTION`
  ADD CONSTRAINT `SECTION_ibfk_1` FOREIGN KEY (`Course_number`) REFERENCES `COURSE` (`Course_number`) ON UPDATE CASCADE;

--
-- Constraints for table `WORKS_ON`
--
ALTER TABLE `WORKS_ON`
  ADD CONSTRAINT `WORKS_ON_ibfk_1` FOREIGN KEY (`Essn`) REFERENCES `EMPLOYEE` (`Ssn`),
  ADD CONSTRAINT `WORKS_ON_ibfk_2` FOREIGN KEY (`Pno`) REFERENCES `PROJECT` (`Pnumber`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
