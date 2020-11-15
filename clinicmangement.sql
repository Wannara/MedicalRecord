-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 15, 2020 at 04:55 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `clinicmangement`
--

-- --------------------------------------------------------

--
-- Table structure for table `drug`
--

CREATE TABLE `drug` (
  `drugID` char(3) NOT NULL,
  `drugName` varchar(15) NOT NULL,
  `Price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `drug`
--

INSERT INTO `drug` (`drugID`, `drugName`, `Price`) VALUES
('001', 'Paracetamal', 2),
('002', 'Acetromycin', 5),
('003', 'Amoxycilin', 3),
('004', 'Omeplazol', 5);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmpID` char(6) NOT NULL,
  `fname` varchar(15) NOT NULL,
  `lname` varchar(15) NOT NULL,
  `Type` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `fname`, `lname`, `Type`) VALUES
('111110', 'Nake', 'Bloom', 1),
('111111', 'Jack', 'Wang', 1),
('111112', 'John', 'Nicol', 1),
('111113', 'Emily', 'Vui', 1),
('222220', 'Emily', 'Maco', 4),
('222221', 'Jared', 'Nocol', 4);

-- --------------------------------------------------------

--
-- Table structure for table `medical_record`
--

CREATE TABLE `medical_record` (
  `MRno` int(11) NOT NULL,
  `doctorID` char(6) NOT NULL,
  `HN` char(9) NOT NULL,
  `SBP/DBP` varchar(10) NOT NULL,
  `weight/height` varchar(10) NOT NULL,
  `earlySymptoms` varchar(35) NOT NULL,
  `diagnostic` varchar(35) NOT NULL,
  `Date` date NOT NULL,
  `PriceMed` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `medical_record`
--

INSERT INTO `medical_record` (`MRno`, `doctorID`, `HN`, `SBP/DBP`, `weight/height`, `earlySymptoms`, `diagnostic`, `Date`, `PriceMed`) VALUES
(1, '111110', '000000001', '80/120', '56/153', 'เจ็บท้อง', 'ประจำเดือน', '2020-10-11', 300),
(2, '111110', '000000002', '80/120', '59/175', 'stomachache', 'gastritis', '2020-10-11', 300),
(3, '111113', '000000003', '70/120', '59/175', 'stomachache', 'gastritis', '2020-10-12', 300),
(4, '111112', '000000005', '69/112', '63/170', 'headache,fatigue', 'fever', '2020-10-12', 300),
(6, '111111', '000000002', '80/120', '80/190', 'ปวดขา', 'เก็า', '2020-10-18', 300),
(7, '111111', '000000005', '80/115', '80/180', 'ปวดเข่า', 'ข้อเข่าเสื่อม', '2020-10-18', 300),
(8, '111111', '000000005', '80/115', '80/180', 'ปวดเข่า', 'ข้อเข่าเสื่อม', '2020-10-18', 300);

-- --------------------------------------------------------

--
-- Table structure for table `medical_record_drug`
--

CREATE TABLE `medical_record_drug` (
  `MRno` int(11) NOT NULL,
  `drugID` char(3) NOT NULL,
  `No_of_drug` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `medical_record_drug`
--

INSERT INTO `medical_record_drug` (`MRno`, `drugID`, `No_of_drug`) VALUES
(1, '003', 10),
(1, '002', 3),
(2, '004', 5),
(3, '003', 10),
(3, '002', 5),
(4, '004', 2),
(6, '001', 3),
(6, '004', 1),
(8, '001', 3),
(8, '004', 1),
(7, '003', 3),
(7, '004', 1);

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `HN` char(9) NOT NULL,
  `fname` varchar(15) NOT NULL,
  `lname` varchar(15) NOT NULL,
  `Birthdate` date NOT NULL,
  `Address` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`HN`, `fname`, `lname`, `Birthdate`, `Address`) VALUES
('000000001', 'Panis', 'Puresri', '1991-02-03', '123 Peachtree, Atlanta, GA'),
('000000002', 'Wanna', 'Boonsri', '1995-10-13', '156 Jordan, Milwaukee, WI'),
('000000003', 'Somchai', 'Boonma', '1995-10-10', '124 Peachtree, Atlanta, GA'),
('000000004', 'Justin', 'Mark', '1991-10-04', '76 Main St., Atlanta, GA'),
('000000005', 'Evan', 'Wallis', '1958-01-16', '134 Pelham, Milwaukee, WI'),
('000000006', 'Jenny', 'Carter', '1960-03-21', '565 Jordan, Milwaukee, WI');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drug`
--
ALTER TABLE `drug`
  ADD PRIMARY KEY (`drugID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmpID`);

--
-- Indexes for table `medical_record`
--
ALTER TABLE `medical_record`
  ADD PRIMARY KEY (`MRno`),
  ADD KEY `doctorID` (`doctorID`),
  ADD KEY `HN` (`HN`);

--
-- Indexes for table `medical_record_drug`
--
ALTER TABLE `medical_record_drug`
  ADD KEY `MRno` (`MRno`),
  ADD KEY `drugID` (`drugID`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`HN`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `medical_record`
--
ALTER TABLE `medical_record`
  MODIFY `MRno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `medical_record`
--
ALTER TABLE `medical_record`
  ADD CONSTRAINT `medical_record_ibfk_1` FOREIGN KEY (`doctorID`) REFERENCES `employee` (`EmpID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `medical_record_ibfk_2` FOREIGN KEY (`HN`) REFERENCES `patient` (`HN`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `medical_record_drug`
--
ALTER TABLE `medical_record_drug`
  ADD CONSTRAINT `medical_record_drug_ibfk_1` FOREIGN KEY (`MRno`) REFERENCES `medical_record` (`MRno`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `medical_record_drug_ibfk_2` FOREIGN KEY (`drugID`) REFERENCES `drug` (`drugID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
