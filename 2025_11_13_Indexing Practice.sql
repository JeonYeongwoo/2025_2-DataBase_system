-- Query 준비용 쿼리

SET SESSION net_read_timeout = 1200;
SET SESSION net_write_timeout = 1200;
SET SESSION wait_timeout = 28800;
SET SESSION interactive_timeout = 28800;
SET autocommit = 1;
CREATE DATABASE IF NOT EXISTS companyDB2;
USE companyDB2;
CREATE TABLE Department (
 DeptNo INT PRIMARY KEY,
 DeptName VARCHAR(50),
 Floor INT
) ENGINE=InnoDB;
CREATE TABLE Employee (
 EmpNo INT PRIMARY KEY,
 EmpName VARCHAR(50),
 Title VARCHAR(30),
 Manager INT,
 Salary INT UNSIGNED,
 DNo INT,
 FOREIGN KEY (DNo) REFERENCES Department(DeptNo)
) ENGINE=InnoDB;
INSERT INTO Department (DeptNo, DeptName, Floor) VALUES
(1, 'Sales', 8),
(2, 'Planning', 10),
(3, 'Development', 9),
(4, 'General Affairs', 7);
DELIMITER $$
CREATE PROCEDURE insert_employees()
BEGIN
 DECLARE i INT DEFAULT 1;
 WHILE i <= 1000000 DO
 INSERT INTO Employee (EmpNo, EmpName, Title, Manager, Salary, DNo)
 VALUES (
 2000 + i,
 CONCAT('Employee_', i),
 ELT(FLOOR(1 + (RAND() * 5)),
 'Staff','Engineer','Planner','Assistant Manager','Manager'),
 FLOOR(1000 + (RAND() * 10)), -- 1000..1009
 FLOOR(1500000 + (RAND() * 3500000)), -- 1,500,000..4,999,999
 FLOOR(1 + (RAND() * 4)) -- 1..4
 );
 SET i = i + 1;
 END WHILE;
END$$
DELIMITER ;
CALL insert_employees();





-- 실습

/*
Task :

Perform practice on companyDB2​

USE companyDB2;​
Design your queries (Without Index) and measure execution time​

Add a Single-Column Index​
Add a Composite (Compound) Index​

Compare the execution time before and after using index​
*/


use companydb2;

Select * from employee
where Empname =  'Employee_1000000';

show index from employee;

select EmpName From Employee
where EmpName = 'Employee_1000000';

CREATE INDEX idx_name ON Employee(Empname);

DROP INDEX idx_name ON  Employee;

-- 복합 인덱스
Select  DNO ,Count(salary)
From Employee
where salary > 4000000
Group By Dno;
-- before 16:21:46	Select  DNO ,Count(salary) From Employee where salary > 4000000 Group By Dno	4 row(s) returned	2.765 sec / 0.000 sec
-- after 16:29:02	Select  DNO ,Count(salary) From Employee where salary > 4000000 Group By Dno	4 row(s) returned	0.562 sec / 0.000 sec

CREATE INDEX idx_dept_salary​
ON Employee (DNo, salary);

-- 단일 인덱스
Select  *
From Employee
where EmpName = 'Employee_494';
-- before 16:27:30	Select  * From Employee where EmpName = 'Employee_494'	1 row(s) returned	0.672 sec / 0.000 sec
-- after 16:28:40	Select  * From Employee where EmpName = 'Employee_494'	1 row(s) returned	0.031 sec / 0.000 sec

CREATE INDEX idx_EmpName
ON Employee (EmpName);