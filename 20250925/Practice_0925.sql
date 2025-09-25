INSERT INTO ADDRESS 
VALUES ('청주', '청주시 서원구', 1);

INSERT INTO ADDRESS 
VALUES ('구미', '청주시 성북구', 1);

INSERT INTO TEAM -- 이거 어떻게 default 값 쓸 수 있능지 찾아보깅 -
values ('아지즈', 'ㅁㄴㅇㄹ', DEFAULT , '청주');

INSERT INTO PLAYER
values ('아지즈', '아지증', 1234 , '아지즈');


/*task 3
Show the countries and their cities where city population exceeds
5,000,000 people
*/
USE world;

SELECT C.Name AS CityName, T.Name AS CountryName, T.population AS populations
From City T
JOIN Country C On C.Code = T.CountryCode
Where T.population > 5000000
ORDER BY populations DESC;

/*What is the capital city of Sweden and its official spoken language*/

SELECT T.Name AS SwedenCapital, L.Language AS Lan
From Country C
JOIN countrylanguage L On C.Code = L.CountryCode
JOIN City T On C.Code = T.CountryCode
Where C.Name = 'Sweden' AND L.IsOfficial = 1 AND  C.Capital = T.ID;

/*Final Tasks​
Find the names of all countries where Korean is spoken​
Find all cities in Korea and Japan​
Find the country with the most official languages
*/
/*f-1*/
SELECT C.Name AS CountrySpeakingKorean
From Country C
JOIN countrylanguage L On C.Code = L.CountryCode
WHERE L.Language = 'Korean';

/* f-2 Find all cities in Korea and Japan​ */

SELECT C.Name AS Nations,  T.Name AS CitiesInKOR_JP
From Country C
JOIN countrylanguage L On C.Code = L.CountryCode
JOIN City T On C.Code = T.CountryCode
where C.Name IN ('korea', 'Japan');

/* f-3 Find the country with the most official languages countrylanguage */
SELECT C.Name AS Nation, Count(*) AS NUM -- count(L.Language) 왜 안되징
From Country C
JOIN countrylanguage L On C.Code = L.CountryCode
WHERE L.IsOfficial = 'T'
GROUP BY C.Name
ORDER BY NUM DESC
LIMIT 1
;