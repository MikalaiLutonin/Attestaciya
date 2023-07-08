-- 7)
DROP DATABASE IF EXISTS human_friends;
CREATE DATABASE human_friends;
show databases;

-- 8)
USE human_friends;
CREATE TABLE класс_животные
(
	Id INT AUTO_INCREMENT PRIMARY KEY, 
	Class_name VARCHAR(20)
);
INSERT INTO класс_животные (Class_name)
VALUES ('домашние'),
('вьючные');  
CREATE TABLE домашние_животные
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    вид_животного VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES класс_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO домашние_животные (вид_животного, Class_id)
VALUES ('Собаки', 1),
('Кошки', 1),  
('Хомяки', 1); 
CREATE TABLE вьючные_животные
(
	  Id INT AUTO_INCREMENT PRIMARY KEY,
    вид_животного VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES класс_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO вьючные_животные (вид_животного, Class_id)
VALUES ('Лошади', 2),
('Верблюды', 2),  
('Ослы', 2); 
    
-- 9)
CREATE TABLE собаки
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20),
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES домашние_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO собаки (Name, Commands, Birthday, Genus_id)
VALUES ('Шарик', 'охранять, сидеть, апорт, лежать', '2018-04-02', 1),
('Бобик', 'голос, просить, лежать', '2023-02-03', 1),  
('Лайка', 'умереть, замри, танцевать, искать', '2020-07-07', 1), 
('Каштанка', 'копать, взять, спать, просить', '2021-09-08', 1);

CREATE TABLE кошки
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20),
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES домашние_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO кошки (Name, Commands, Birthday,  Genus_id)
VALUES ('Барсик', 'изчезни!', '2011-01-01', 2),
('Рыжик', 'в туалет!','2016-01-01', 2),  
('Боня', 'лизать!', '2018-02-14',2),
('Жорик', 'Жорик, блядь!', '2021-04-29', 2); 

CREATE TABLE хомяки 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES домашние_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO хомяки (Name, Commands, Birthday, Genus_id)
VALUES ('Белый', 'беги', '2023-01-02', 3),
('Серый', 'кушать', '2023-02-03', 3),  
('Рыжий', 'кушать', '2023-03-04', 3), 
('Крыса', 'кушать', '2023-04-05', 3);


CREATE TABLE лошади 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES вьючные_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO лошади (Name, Commands, Birthday, Genus_id)
VALUES ('Мажор', 'шагом', '2015-02-16', 1),
('Рысь', 'бегом', '2018-03-23', 1),  
('Блэк', 'быстро', '2018-05-18', 1), 
('Турбо', 'рвать', '2020-11-10', 1);

CREATE TABLE верблюды 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES вьючные_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO верблюды (Name, Commands, Birthday, Genus_id)
VALUES ('Первый', 'сидеть','2013-11-04', 2),
('Вер', 'встать', '2015-08-02', 2),  
('Блюд', 'идти', '2015-09-15', 2), 
('Четвертый', 'стоять', '2014-03-08', 2);

CREATE TABLE ослы
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Commands VARCHAR(50),
    Birthday DATE,
    Genus_id int,
    Foreign KEY (Genus_id) REFERENCES вьючные_животные (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO ослы (Name, Commands, Birthday, Genus_id)
VALUES ('Большой', 'вперед', '2018-02-27', 3),
('Малой', 'нельзя', '2019-06-05', 3),  
('Тормоз', 'ждать', '2020-03-11', 3), 
('Жук', 'не пить', '2021-02-06', 3);

-- 10)
SET SQL_SAFE_UPDATES = 0;
DELETE FROM верблюды;
SELECT Name, Commands, Birthday FROM лошади
UNION SELECT  Name, Commands, Birthday FROM ослы;

-- 11)
CREATE TEMPORARY TABLE все_животные AS 
SELECT *, 'Собака' AS genus FROM собаки
UNION SELECT *, 'Кошка' AS genus FROM кошки
UNION SELECT *, 'Хомяк' AS genus FROM хомяки
UNION SELECT *, 'Лошадь' AS genus FROM лошади
UNION SELECT *, 'Осел' AS genus FROM ослы;

CREATE TABLE молодые_животные AS
SELECT genus, Name, Birthday, Commands, TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Age_in_month
FROM все_животные WHERE Birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);
SELECT * FROM молодые_животные;

-- 12)
SELECT d.Name,  d.Commands, d.Birthday, ha.вид_животного, ya.Age_in_month 
FROM собаки d
LEFT JOIN молодые_животные ya ON ya.Name = d.Name
LEFT JOIN домашние_животные ha ON ha.Id = d.Genus_id
UNION
SELECT c.Name, c.Commands, c.Birthday, ha.вид_животного, ya.Age_in_month 
FROM кошки c
LEFT JOIN молодые_животные ya ON ya.Name = c.Name
LEFT JOIN домашние_животные ha ON ha.Id = c.Genus_id
UNION
SELECT hm.Name, hm.Commands, hm.Birthday, ha.вид_животного, ya.Age_in_month 
FROM хомяки hm
LEFT JOIN молодые_животные ya ON ya.Name = hm.Name
LEFT JOIN домашние_животные ha ON ha.Id = hm.Genus_id
UNION
SELECT h.Name, h.Commands, h.Birthday, pa.вид_животного, ya.Age_in_month 
FROM лошади h
LEFT JOIN молодые_животные ya ON ya.Name = h.Name
LEFT JOIN вьючные_животные pa ON pa.Id = h.Genus_id
UNION 
SELECT d.Name, d.Commands, d.Birthday, pa.вид_животного, ya.Age_in_month 
FROM ослы d 
LEFT JOIN молодые_животные ya ON ya.Name = d.Name
LEFT JOIN вьючные_животные pa ON pa.Id = d.Genus_id;
