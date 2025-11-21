USE afterlife_db;
-- =============================================
-- DATA POPULATION
-- =============================================

-- 1. SPECIES
-- Ranges: Bacteria (<= -200), Pigeon (-199 to -1), Cat (0-79), Dog (80-119), Horse (120-199), Human (>=200)
INSERT INTO SPECIES (ID, Name, Soul_Score) VALUES
(1, 'Cat', 0),
(2, 'Human', 200),
(3, 'Horse', 120),
(4, 'Dog', 80),
(5, 'Pigeon', -30),
(6, 'Bacteria', -200);

-- 2. CARETAKERS
INSERT INTO CARETAKER (ID, Name, Class, Manager_ID) VALUES
(1, 'Michael', 'Angel', NULL),
(2, 'Lucifer', 'Demon', NULL),
(3, 'Raphael', 'Angel', 1),
(4, 'Azazel', 'Demon', 2),
(5, 'Gabriel', 'Angel', 3),
(6, 'Belial', 'Demon', 2);

-- 3. SOULS
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
-- The Legacy Entry (No lives, mysterious)
('N0','dombu','gabe','itch','Nirvana', NULL, NULL),
-- Active Data Souls
('N1','Asha','M.','Harjani','Nirvana', NULL, 1),
('N2','Bhav','R.','Patel','Nirvana', NULL, 1),
('S100','Anupama',NULL,'N','Heaven','2051-05-12',3),
('S101','Thomas','E.','Ng','Heaven','2034-11-01',3),
('S200','Kookoo',NULL,'Caw','Hell','2050-06-19',4),
('S201','Silya',NULL,'Drake','Hell','2035-09-08',6),
('S300','Slime',NULL,'Blob','Hell','2035-01-01',2),
('S301','Ravi',NULL,'Kumar','Earth', NULL, 5),
('S302','Sana',NULL,'Gomez','Earth', NULL, 1),
('S303','Hector',NULL,'Ho','Earth', NULL, 5),
('S304','Olda',NULL,'Fe', 'Earth', NULL, 6);

-- 4. LIVES_ON_EARTH
INSERT INTO LIVES_ON_EARTH
(Soul_ID, DOB, F_Name, M_Name, L_Name, Species_ID, DOD, Birth_Street, Birth_City, Birth_State, Birth_Country)
VALUES

-- N1 (Asha): Cat -> Human -> Nirvana
-- Life 1 (Cat): 1820-1830. Score +200 (Miracle Jump). 20yr Reward gap.
('N1','1820-01-01','Mina',NULL,'Purr',1,'1830-01-01', 'Temple Steps','Varanasi','Uttar Pradesh','India'),
-- Life 2 (Human): 1850-1900. Score +800.
('N1','1850-05-15','Asha','M.','Harjani',2,'1900-01-01', 'Ghat Road','Varanasi','Uttar Pradesh','India'),

-- N2 (Bhav): Cat -> Dog -> Horse -> Human -> Nirvana
-- Life 1 (Cat): 1800-1810. Score +80. Next: Dog. Gap ~2 yrs.
('N2','1800-01-01','Shadow',NULL,'Paws',1,'1810-01-01', 'Old Market','Surat','Gujarat','India'),
-- Life 2 (Dog): 1812-1822. Score +50. Next: Horse. Gap ~3 yrs.
('N2','1812-06-01','Sheru',NULL,'Bark',4,'1822-06-01', 'Farm Road','Surat','Gujarat','India'),
-- Life 3 (Horse): 1825-1845. Score +80. Next: Human. Reward 15 yrs.
('N2','1825-01-01','Badal',NULL,'Gallop',3,'1845-01-01', 'Royal Stables','Jaipur','Rajasthan','India'),
-- Life 4 (Human): 1860-1905. Score +900.
('N2','1860-08-20','Bhav','R.','Patel',2,'1905-01-01', 'River Ghat','Haridwar','Uttarakhand','India'),

-- S300: Cat -> Pigeon -> Bacteria (Hell Path)
('S300','1980-01-01','Mittens',NULL,'Catson',1,'1985-12-08', '12 Cat Lane','Thiruvananthapuram','Kerala','India'),
('S300','1987-06-10','Peck',NULL,'Feather',5,'1992-07-15', '2 Rooftop','Kochi','Kerala','India'),
('S300','2007-09-25','Slime',NULL,'Blob',6,'2022-11-30', 'Mud Alley','Kannur','Kerala','India'),

-- S301: Cat -> Dog -> Horse -> Human (Rising)
('S301','1975-03-05','Whiskers',NULL,'Paw',1,'1981-10-10', '4 Alley','Bengaluru','Karnataka','India'),
('S301','1982-11-12','Buddy',NULL,'Rover',4,'1989-01-15', '7 Kennel Rd','Hubli','Karnataka','India'),
('S301','1990-02-20','Storm',NULL,'Hoof',3,'1998-05-25', '9 Meadow','Udupi','Karnataka','India'),
('S301','1999-08-01','Ravi',NULL,'Kumar',2,NULL, '3 Gandhi Rd','Mangalore','Karnataka','India'),

-- S302: Cat -> Dog -> Human (Stumble)
('S302','1989-05-15','Pip',NULL,'Purr',1,'1995-06-20', '1 Whisker Ave','Manila','Metro Manila','Philippines'),
('S302','1996-07-07','Fido',NULL,'Bark',4,'2002-08-30', '2 Doggo St','Manila','Metro Manila','Philippines'),
('S302','2003-12-12','Sana',NULL,'Gomez',2,NULL, '10 Ocean View','Manila','Metro Manila','Philippines'),

-- S100: Cat -> Human -> Human (Saintly Path)
('S100','1920-04-01','OldTom',NULL,'Feline',1,'1930-05-05', 'Old Cat Rd','Kolkata','West Bengal','India'),
('S100','1950-09-10','Leela',NULL,'Roy',2,'1980-12-12', '7 Park Ave','Chennai','Tamil Nadu','India'),
('S100','2010-11-30','Anupama',NULL,'N',2,'2021-05-12', '7 Park Ave','Mumbai','Maharashtra','India'),

-- S101: Cat -> Human (Good Path)
('S101','1960-02-02','Moggy',NULL,'Tail',1,'1970-05-16', 'Pet Lane','Singapore','Singapore','Singapore'),
('S101','1985-06-06','Thomas',NULL,'Ng',2,'2019-11-01', '12 Hope Rd','London','London','UK'),

-- S200: Cat -> Horse -> Horse -> Pigeon -> Hell
('S200','1920-03-03','Stray',NULL,'Mews',1,'1930-08-06', 'Ancient Street','Varanasi','Uttar Pradesh','India'),
('S200','1935-08-08','Bridle',NULL,'Gallop',3,'1955-09-09', 'Stables','Agra','Uttar Pradesh','India'),
('S200','1960-10-10','Brutus',NULL,'Karn',3,'1975-12-12', '18 Ash St','Lucknow','Uttar Pradesh','India'),
('S200','2008-01-01','Kookoo',NULL,'Caw',5,'2015-03-20', 'Rooftop','Mathura','Uttar Pradesh','India'),

-- S201: Cat -> Bacteria -> Bacteria -> Hell
('S201','1950-12-12','Tiny',NULL,'Whisk',1,'1955-01-01', 'Backstreet','Nashik','Maharashtra','India'),
('S201','1997-04-04','Ilya',NULL,'Drake',6,'1998-06-01', 'Lab','Nagpur','Maharashtra','India'),
('S201','2012-09-09','Silya',NULL,'Drake',6,'2015-03-01', 'Lab2','Pune','Maharashtra','India'),

-- S303: Cat -> Horse -> Human
('S303','1982-01-01','Mog',NULL,'Purr',1,'1989-02-02', 'Alley','Chennai','Tamil Nadu','India'),
('S303','1990-06-06','Dash',NULL,'Hoof',3,'1997-07-07', 'Farm','Mahabalipuram','Tamil Nadu','India'),
('S303','1998-03-03','Hector',NULL,'Ho',2,NULL, 'Town','Madurai','Tamil Nadu','India'),

-- S304: Cat -> Pigeon -> Human
('S304','1955-05-05','Mews',NULL,'Kit',1,'1960-06-06', 'OldRoad','Albuquerque','New Mexico','USA'),
('S304','1961-06-06','Twitch',NULL,'Wing',5,'1969-05-05', 'Cliff','Dallas','Texas','USA'),
('S304','1985-07-07','Olda',NULL,'Fe',2,NULL, '4th Avenue','Houston','Texas','USA');


-- 5. DEEDS
INSERT INTO DEEDS (Deed_ID, Soul_ID, Description, Status, Timestamp, Date, Score, Street, City) VALUES

-- N1 (Asha): Cat -> Human -> Nirvana
(25, 'N1', 'Saved a baby from a cobra', 'Good', '10:00:00', '1828-05-05', 200, 'Temple Steps', 'Varanasi'),
(26, 'N1', 'Dedicated life to universal compassion', 'Good', '00:00:00', '1899-12-31', 800, 'Ghat Road', 'Varanasi'),

-- N2 (Bhav): Cat -> Dog -> Horse -> Human -> Nirvana
(27, 'N2', 'Shared meager food with starving kitten', 'Good', '12:00:00', '1809-06-01', 80, 'Old Market', 'Surat'),
(28, 'N2', 'Died protecting master from bandits', 'Good', '23:00:00', '1822-05-31', 50, 'Farm Road', 'Surat'),
(29, 'N2', 'Carried heavy loads for building temple', 'Good', '10:00:00', '1840-01-01', 80, 'Royal Stables', 'Jaipur'),
(30, 'N2', 'Achieved total detachment from material world', 'Good', '00:00:00', '1904-12-31', 900, 'River Ghat', 'Haridwar'),

-- S300: Cat -> Pigeon -> Bacteria
(1, 'S300', 'Ate owner''s prize canary', 'Bad', '12:00:00', '1984-05-20', -35, '12 Cat Lane', 'Thiruvananthapuram'),
(2, 'S300', 'Infected a hospital water supply', 'Bad', '08:00:00', '2020-05-05', -170, 'Sewer', 'Kannur'),

-- S301: Cat -> Dog -> Horse -> Human
(3, 'S301', 'Comforted lonely widow', 'Good', '09:00:00', '1980-01-01', 85, '4 Alley', 'Bengaluru'),
(4, 'S301', 'Bit a postman unprovoked', 'Bad', '10:00:00', '1984-06-01', -20, '7 Kennel Rd', 'Hubli'),
(5, 'S301', 'Saved puppy from traffic', 'Good', '10:00:00', '1985-06-01', 70, '7 Kennel Rd', 'Hubli'),
(6, 'S301', 'Served faithfully in police force', 'Good', '16:30:00', '1995-09-01', 80, '9 Meadow', 'Udupi'),
(7, 'S301', 'Donated to shelter', 'Good', '12:00:00', '2021-02-02', 40, NULL, NULL),

-- S302: Cat -> Dog -> Human
(8, 'S302', 'Killed venomous snake near baby', 'Good', '07:45:00', '1994-11-11', 90, '1 Whisker Ave', 'Manila'),
(9, 'S302', 'Rescued family from fire', 'Good', '02:00:00', '2000-05-05', 115, '2 Doggo St', 'Manila'),
(10, 'S302', 'Illegally fished endangered species', 'Bad', '05:30:00', '2024-08-18', -40, '10 Ocean View', 'Manila'),
(11, 'S302', 'Helped marine rescue', 'Good', '12:00:00', '2024-09-01', 30, '10 Ocean View', 'Manila'),

-- S100: Cat -> Human -> Heaven
(12, 'S100', 'Led rescuers to trapped miners', 'Good', '10:00:00', '1925-06-06', 210, 'Old Cat Rd', 'Kolkata'),
(13, 'S100', 'Lifelong charity', 'Good', '10:00:00', '1975-06-06', 300, '7 Park Ave', 'Chennai'),

-- S200: Cat -> Horse -> Horse -> Pigeon -> Hell
(14, 'S200', 'Guided lost child home', 'Good', '10:00:00', '1925-01-01', 130, 'Ancient Street', 'Varanasi'),
(15, 'S200', 'Won races honorably', 'Good', '10:00:00', '1945-01-01', 10, 'Stables', 'Agra'),
(16, 'S200', 'Trampled owner in rage', 'Bad', '23:00:00', '1974-12-12', -180, '18 Ash St', 'Lucknow'),
(17, 'S200', 'Ruined crop harvest', 'Bad', '14:00:00', '2014-03-20', -170, 'Farm', 'Mathura'),

-- S201: Cat -> Bacteria -> Bacteria -> Hell
(18, 'S201', 'Savaged a baby in cradle', 'Bad', '02:00:00', '1954-02-01', -210, 'Backstreet', 'Nashik'),
(19, 'S201', 'Caused necrotic outbreak', 'Bad', '00:00:00', '1998-02-28', -50, 'Lab', 'Nagpur'),
(20, 'S201', 'Infected scientist', 'Bad', '00:00:00', '2014-09-09', -50, 'Lab2', 'Pune'),

-- S304: Cat -> Pigeon -> Human
(21, 'S304', 'Destroyed vase', 'Bad', '09:00:00', '1959-05-05', -35, 'OldRoad', 'Albuquerque'),
(22, 'S304', 'Sacrificed life for child', 'Good', '12:12:00', '1968-05-05', 240, 'Cliff', 'Dallas'),

-- S303
(23, 'S303', 'Saved farm from rats', 'Good', '1985-01-01', '1985-01-01', 130, 'Alley', 'Chennai'),
(24, 'S303', 'Worked to death', 'Good', '1995-01-01', '1995-01-01', 90, 'Farm', 'Mahabalipuram');

-- 6. DEED_ACTION_TYPE
INSERT INTO DEED_ACTION_TYPE (Deed_ID, Soul_ID, Action_Type) VALUES
(1, 'S300', 'gluttony'),
(2, 'S300', 'gluttony'),
(4, 'S301', 'wrath'), 
(10, 'S302', 'greed'),
(16, 'S200', 'wrath'),
(17, 'S200', 'envy'),
(18, 'S201', 'wrath'),
(19, 'S201', 'gluttony'),
(20, 'S201', 'gluttony'),
(21, 'S304', 'pride');

-- 7. PUNISHMENTS
INSERT INTO PUNISHMENTS (ID, Action, Description, Location) VALUES
(1,'greed','Endless counting of unspendable coins','Vault of Echoes'),
(2,'envy','Ceaseless watching of others’ joy','Glass Garden'),
(3,'pride','Shrinking halls of mirrors','The Diminishing Hall'),
(4,'sloth','Uphill endless tasks','Slope of Toil'),
(5,'gluttony','Taste without nourishment','Banquetless Court'),
(6,'wrath','Flames that mirror one’s rage','The Ember Pit'),
(7,'lust','Chasing a mirage of desire','Desert of Want');

-- 8. PUNISHMENT_ASSIGNED
INSERT INTO PUNISHMENT_ASSIGNED (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID, Duration, Status, Supervisor) VALUES
('S300', 5, 'gluttony', 1, 35, 'Completed', 2),
('S300', 5, 'gluttony', 2, 4700, 'In Progress', 2),
('S302', 1, 'greed', 10, 100, 'Pending', 5),
('S200', 6, 'wrath', 16, 12000, 'Completed', 4),
('S200', 2, 'envy', 17, 12700, 'In Progress', 6),
('S201', 6, 'wrath', 18, 15000, 'Completed', 2),
('S201', 5, 'gluttony', 19, 5000, 'Completed', 6),
('S201', 5, 'gluttony', 20, 7300, 'In Progress', 6),
('S304', 3, 'pride', 21, 60, 'Completed', 2);
