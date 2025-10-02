-- task 1

CREATE Table department(
deptno int NOT NULL,
deptname varchar(45),
floor int,
CONSTRAINT PK_Employee PRIMARY KEY (deptno)
);

DROP TABLE employee;

CREATE Table employee(
empno int NOT NULL,
empname varchar(45),
dno int,
CONSTRAINT PK_Employee PRIMARY KEY (empno),
CONSTRAINT FK_Department_Employee FOREIGN KEY (dno)
REFERENCES department(deptno) ON DELETE CASCADE
);

INSERT INTO department
	values 
        (1, '영업', 8),
        (2, '영업', 10),
        (3, '영업', 9);
        
INSERT INTO employee
	values 
        (2106, '김창섭', 2),
        (3426, '박영권', 3),
        (3011, '이수민', 1),
        (1003, '조민희', 1),
        (3427, '최종철', 3);
        ;
		
-- 이거 하면, cascade 를 넣어놨으므로, 자동으로 참고하고 있던 tuples 가 삭제됨.
DELETE FROM department WHERE deptno = 3;


-- task 2

SELECT Name, CountryCode
FROM City T
where CountryCode = (
	SELECT Code
    FROM country C
    ORDER BY Population DESC
    LIMIT 1
);

-- task 3
-- Have cities with population of more than 5 million 
SELECT Name
FROM CITY 
WHERE Population > 5000000
ORDER BY population DESC;

-- Located on the same continent with Uzbekistan
# step 1. # uzb continent 구하기
SELECT Continent 
FROM country 
WHERE Name = 'Uzbekistan';

# step 1. uzbekistan 내 country들의 CODE 들 구하기
SELECT CODE
FROM country
where Continent = (
	SELECT Continent 
	FROM country 
	WHERE Name = 'Uzbekistan'
);

# 3. 2의 결과를 1의 where 조건에 추가하기.
SELECT Name
FROM CITY 
WHERE Population > 5000000 
AND 
CountryCode in (
    SELECT CODE
	FROM country
	where Continent = (
		SELECT Continent 
		FROM country 
		WHERE Name = 'Uzbekistan'
	)
)
ORDER BY population DESC;


-- task4
/*
Find countries with the following requirements:​
The country must be in Asia​
The language speaking percentage must be equal or above 50%​
Make two queries: (1) using JOIN and (2) using Derived Table
*/

-- 1. JOIN 사용
SELECT DISTINCT C.Name
FROM country C
JOIN countrylanguage L ON C.Code = L.CountryCode
WHERE C.Continent = 'Asia' AND L.percentage >= 0.5;

-- 2. nested query 사용
SELECT DISTINCT Name
FROM country 
WHERE Continent = 'Asia' AND 
	Code in (
		SELECT DISTINCT CountryCode
        FROM countrylanguage
        where percentage >= 0.5
);


-- Task 5
/*
Find bilingual countries with the following requirements​

	Find bilingual countries (two officially spoken language)​
	Sort the result in ascending order by country names​
	Use Derived Table
*/
-- step 1. Find Code which is bilingual
SELECT CountryCode, Count(Language) AS NumOfLanguages
FROM countrylanguage
WHERE IsOfficial = 'T' 
GROUP BY CountryCode
HAVING NumOfLanguages > 2
ORDER BY NumOfLanguages DESC;

-- step 2. Find Countries
SELECT Name 
FROM country
where EXISTS (
	SELECT CountryCode, Count(Language) AS NumOfLanguages
	FROM countrylanguage
	WHERE IsOfficial = 'T' 
	GROUP BY CountryCode
	HAVING NumOfLanguages > 2
	ORDER BY NumOfLanguages DESC
)
ORDER BY NAME ASC



