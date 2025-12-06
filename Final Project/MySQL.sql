Drop DATABASE db_apartment;
Create DATABASE IF NOT EXISTS db_apartment ;
Use db_apartment; 

Create Table Resident(
	resident_id int,
	First_name varchar(20),
	last_name varchar(20),
	CONSTRAINT pk_resident
	primary key (resident_id)
);
Create Table Building(
	building_id int,
	construction_date int,
	building_name varchar(15),
	address varchar (100),
	CONSTRAINT pk_building
    primary key (building_id)
);
Create Table Unit(
	building_id int,
	unit_id int,
	exclusive_area int,
	common_area int,
	Constraint pk_unit
	primary key (building_id, unit_id),
	Constraint fk_unit_building
	foreign key (building_id) references Building(building_id)
);

Create Table Vehicle(
	vehicle_number int,
	vehicle_type varchar(20),
	resident_id int,
	building_id int,
	registered_date int,
	Constraint pk_vehicle
	primary key (vehicle_number),
	Constraint fk_vehicle_resident
	foreign key (resident_id) references Resident(resident_id),
	Constraint fk_vehicle_building
	foreign key (building_id) references Building(building_id)
);

Create Table Unit_Resident_relation(
	building_id int,
	unit_id int,
	resident_id int,
	Constraint pk_unit_res_relation
	primary key (building_id, unit_id, resident_id),
	Constraint fk_relation_unit
	foreign key (building_id, unit_id) references Unit(building_id, unit_id),
	Constraint fk_relation_resident
	foreign key (resident_id) references Resident(resident_id)
);

Create Table Resident_PhoneNumber(
	resident_id int,
	phone_number int,
	Constraint pk_phoneNumber
	primary key (resident_id, phone_number),
	Constraint fk_phoneNumber
	Foreign key (resident_id) references Resident(resident_id)
);












/*
데이터 인서팅 쿼리문
*/

INSERT INTO Building VALUES
(101, 2015, 'A-Tower',   'Seoul, Gangnam-gu 123'),
(102, 2018, 'B-Tower',   'Seoul, Seocho-gu 456'),
(103, 2020, 'C-Tower',   'Seoul, Songpa-gu 789'),
(104, 2017, 'D-Tower',   'Seoul, Mapo-gu 111'),
(105, 2019, 'E-Tower',   'Seoul, Jongno-gu 222'),
(106, 2021, 'F-Tower',   'Seoul, Yongsan-gu 333'),
(107, 2016, 'G-Tower',   'Seoul, Seodaemun-gu 444'),
(108, 2014, 'H-Tower',   'Seoul, Nowon-gu 555'),
(109, 2022, 'I-Tower',   'Seoul, Gwanak-gu 666'),
(110, 2023, 'J-Tower',   'Seoul, Gangdong-gu 777'),
(111, 2013, 'K-Tower',   'Seoul, Dobong-gu 888'),
(112, 2011, 'L-Tower',   'Seoul, Eunpyeong-gu 999'),
(113, 2010, 'M-Tower',   'Seoul, Jung-gu 147'),
(114, 2016, 'N-Tower',   'Seoul, Songpa-gu 258'),
(115, 2018, 'O-Tower',   'Seoul, Gangnam-gu 369'),
(116, 2012, 'P-Tower',   'Seoul, Seocho-gu 741'),
(117, 2020, 'Q-Tower',   'Seoul, Guro-gu 852'),
(118, 2021, 'R-Tower',   'Seoul, Yeongdeungpo-gu 963'),
(119, 2023, 'S-Tower',   'Seoul, Seongbuk-gu 159'),
(120, 2019, 'T-Tower',   'Seoul, Dongdaemun-gu 753');

INSERT INTO Unit VALUES
(101, 101, 84, 20),
(102, 202, 74, 18),
(103, 303, 92, 25),
(104, 404, 66, 15),
(105, 505, 77, 17),
(106, 606, 81, 19),
(107, 707, 90, 21),
(108, 808, 56, 13),
(109, 909, 88, 22),
(110, 110, 70, 16),
(111, 111, 73, 15),
(112, 112, 95, 27),
(113, 113, 67, 14),
(114, 114, 82, 19),
(115, 115, 100, 30),
(116, 116, 68, 13),
(117, 117, 71, 18),
(118, 118, 87, 23),
(119, 119, 79, 20),
(120, 120, 93, 25);

INSERT INTO Resident VALUES
(1,  'Minho',      'Lee'),
(2,  'Jisoo',      'Park'),
(3,  'Hyunwoo',    'Choi'),
(4,  'Soyeon',     'Kim'),
(5,  'Taehyun',    'Jung'),
(6,  'Yuna',       'Han'),
(7,  'Seungmin',   'Kang'),
(8,  'Eunji',      'Yoon'),
(9,  'Jaehyun',    'Lim'),
(10, 'Hyejin',     'Kwon'),
(11, 'Donghyun',   'Shin'),
(12, 'Nayeon',     'Baek'),
(13, 'Jinhwan',    'Hwang'),
(14, 'Yuri',       'Oh'),
(15, 'Sunwoo',     'Chung'),
(16, 'Mina',       'Jo'),
(17, 'Gyuri',      'Seo'),
(18, 'Jungwoo',    'Moon'),
(19, 'Arin',       'Na'),
(20, 'Jaeho',      'Ryu');


INSERT INTO Unit_Resident_relation VALUES
(101, 101, 1),
(102, 202, 2),
(103, 303, 3),
(104, 404, 4),
(105, 505, 5),
(106, 606, 6),
(107, 707, 7),
(108, 808, 8),
(109, 909, 9),
(110, 110, 10),
(111, 111, 11),
(112, 112, 12),
(113, 113, 13),
(114, 114, 14),
(115, 115, 15),
(116, 116, 16),
(117, 117, 17),
(118, 118, 18),
(119, 119, 19),
(120, 120, 20);


INSERT INTO Vehicle VALUES
(1111, 'Sedan',       1, 101, 20230101),
(2222, 'SUV',         2, 102, 20230215),
(3333, 'Motorcycle',  3, 103, 20230310),
(4444, 'Hatchback',   4, 104, 20230420),
(5555, 'Sedan',       5, 105, 20230511),
(6666, 'SUV',         6, 106, 20230605),
(7777, 'Sedan',       7, 107, 20230718),
(8888, 'Coupe',       8, 108, 20230822),
(9999, 'Truck',       9, 109, 20230930),
(1212, 'EV',         10, 110, 20231010),
(1313, 'Sedan',      11, 111, 20231105),
(1414, 'SUV',        12, 112, 20231201),
(1515, 'Motorcycle', 13, 113, 20240120),
(1616, 'SUV',        14, 114, 20240214),
(1717, 'EV',         15, 115, 20240301),
(1818, 'Sedan',      16, 116, 20240404),
(1919, 'Truck',      17, 117, 20240509),
(2020, 'SUV',        18, 118, 20240606),
(2121, 'Hatchback',  19, 119, 20240707),
(2223, 'EV',         20, 120, 20240808);

INSERT INTO Resident_PhoneNumber VALUES
(1,  1011112222),
(2,  1022223333),
(3,  1033334444),
(4,  1044445555),
(5,  1055556666),
(6,  1066667777),
(7,  1077778888),
(8,  1088889999),
(9,  1099991111),
(10, 1100002222),
(11, 1111113333),
(12, 1122224444),
(13, 1133335555),
(14, 1144446666),
(15, 1155557777),
(16, 1166668888),
(17, 1177779999),
(18, 1188881111),
(19, 1199992222),
(20, 1200003333);
