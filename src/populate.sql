USE afterlife_db;

-- =========================
-- SPECIES (reference scores)
-- Negative scores allowed
-- =========================
INSERT INTO SPECIES (ID, Name, Soul_Score) VALUES
(1, 'Cat',        0),     -- everyone’s first life
(2, 'Human',    200),     -- high-quality rebirth
(3, 'Horse',    120),     -- good quality
(4, 'Dog',       80),     -- decent quality
(5, 'Pigeon',   -30),     -- mild negative
(6, 'Bacteria', -200);    -- worst rebirth

-- =========================
-- CARETAKERS
-- =========================
INSERT INTO CARETAKER (ID, Name, Class, Manager_ID) VALUES
(1, 'Michael', 'Angel', NULL),
(2, 'Lucifer', 'Demon', NULL),
(3, 'Raphael', 'Angel', 1),
(4, 'Azazel', 'Demon', 2),
(5, 'Gabriel', 'Angel', 3),
(6, 'Belial', 'Demon', 2);

-- =========================
-- SOULS (current-life names = latest life)
-- We'll include N0, N1, N2 (Nirvana) + several S* souls
-- =========================
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
-- Nirvana / Divine
('N0','dombu','oombu','Divine','Nirvana', NULL, NULL),
('N1','Asha','M.','Harjani','Nirvana', NULL, 1),
('N2','Bhav','R.','Patel','Nirvana', NULL, 1),

-- Heaven examples (completed lives)
('S100','Leela',NULL,'Roy','Heaven','2021-05-12',3),
('S101','Thomas','E.','Ng','Heaven','2019-11-01',3),

-- Hell examples
('S200','Mord',NULL,'Karn','Hell','2018-03-20',4),
('S201','Ilya','V.','Drake','Hell','2020-08-15',6),

-- Earth (currently incarnated)
('S300','Priya','S.','Menon','Earth', NULL, 5),
('S301','Ravi',NULL,'Kumar','Earth', NULL, 5),
('S302','Sana',NULL,'Gomez','Earth', NULL, 1),
('S303','Hector',NULL,'Ho','Earth', NULL, 5),
('S304','Olda',NULL,'Fe', 'Earth', NULL, 6);

-- =========================
-- LIVES_ON_EARTH
-- Many lives per soul. First life always Cat (Species_ID = 1).
-- We pick DOB order so first life is earliest DOB.
-- Ladder mapping used when choosing species for later lives, so cumulative sums match thresholds.
-- =========================

INSERT INTO LIVES_ON_EARTH
(Soul_ID, DOB, F_Name, M_Name, L_Name, Species_ID, DOD,
 Birth_Street, Birth_City, Birth_State, Birth_Country)
VALUES

-- S300: Cat → Pigeon → Bacteria  (falling path)
('S300','1978-01-01','Mittens',NULL,'Catson',1,'1984-12-08',
 '12 Cat Lane','Thiruvananthapuram','Kerala','India'),
('S300','1985-06-10','Peck',NULL,'Feather',5,'1991-07-15',
 '2 Rooftop','Kochi','Kerala','India'),
('S300','1992-09-25','Slime',NULL,'Blob',6,'1993-11-30',
 'Mud Alley','Kannur','Kerala','India'),

-- S301: Cat → Dog → Horse → Human  (steady rise)
('S301','1975-03-05','Whiskers',NULL,'Paw',1,'1981-10-10',
 '4 Alley','Bengaluru','Karnataka','India'),
('S301','1982-11-12','Buddy',NULL,'Rover',4,'1989-01-15',
 '7 Kennel Rd','Hubli','Karnataka','India'),
('S301','1990-02-20','Storm',NULL,'Hoof',3,'1998-05-25',
 '9 Meadow','Udupi','Karnataka','India'),
('S301','1999-08-01','Ravi',NULL,'Kumar',2,NULL,
 '3 Gandhi Rd','Mangalore','Karnataka','India'),

-- S302: Cat → Dog → Human  (good progression)
('S302','1989-05-15','Pip',NULL,'Purr',1,'1995-06-20',
 '1 Whisker Ave','Manila','Metro Manila','Philippines'),
('S302','1996-07-07','Fido',NULL,'Bark',4,'2002-08-30',
 '2 Doggo St','Manila','Metro Manila','Philippines'),
('S302','2003-12-12','Sana',NULL,'Gomez',2,NULL,
 '10 Ocean View','Manila','Metro Manila','Philippines'),

-- S100: Cat → Human → Human (virtuous → Heaven)
('S100','1930-04-01','OldTom',NULL,'Feline',1,'2021-05-12',
 'Old Cat Rd','Kolkata','West Bengal','India'),
('S100','1955-09-10','Leela',NULL,'Roy',2,'2021-05-12',
 '7 Park Ave','Chennai','Tamil Nadu','India'),
('S100','1978-11-30','Leela',NULL,'Roy',2,'2021-05-12',
 '7 Park Ave','Mumbai','Maharashtra','India'),

-- S101: Cat → Human (mildly good → Heaven)
('S101','1945-02-02','Moggy',NULL,'Tail',1,'2019-11-01',
 'Pet Lane','Singapore','Singapore','Singapore'),
('S101','1965-06-06','Thomas',NULL,'Ng',2,'2019-11-01',
 '12 Hope Rd','London','London','UK'),

-- S200: Cat → Horse → Horse → Pigeon (rise then decline)
('S200','1938-03-03','Stray',NULL,'Mews',1,'1958-08-06',
 'Ancient Street','Varanasi','Uttar Pradesh','India'),
('S200','1958-08-08','Bridle',NULL,'Gallop',3,'1974-09-09',
 'Stables','Agra','Uttar Pradesh','India'),
('S200','1975-10-10','Brutus',NULL,'Karn',3,'1995-12-12',
 '18 Ash St','Lucknow','Uttar Pradesh','India'),
('S200','1998-01-01','Kookoo',NULL,'Caw',5,'2018-03-20',
 'Rooftop','Mathura','Uttar Pradesh','India'),

-- S201: Cat → Bacteria → Bacteria (downward → Hell)
('S201','1940-12-12','Tiny',NULL,'Whisk',1,'1960-01-01',
 'Backstreet','Nashik','Maharashtra','India'),
('S201','1962-04-04','Ilya',NULL,'Drake',6,'1970-01-01',
 'Lab','Nagpur','Maharashtra','India'),
('S201','1980-09-09','Ilya',NULL,'Drake',6,'1981-03-01',
 'Lab2','Pune','Maharashtra','India'),

-- S303: Cat → Horse → Human (good rise)
('S303','1982-01-01','Mog',NULL,'Purr',1,'1989-02-02',
 'Alley','Chennai','Tamil Nadu','India'),
('S303','1990-06-06','Dash',NULL,'Hoof',3,'1997-07-07',
 'Farm','Mahabalipuram','Tamil Nadu','India'),
('S303','1998-03-03','Hector',NULL,'Ho',2,NULL,
 'Town','Madurai','Tamil Nadu','India'),

-- S304: Cat → Pigeon → Human (chaotic but ends positive)
('S304','1955-05-05','Mews',NULL,'Kit',1,'1963-06-06',
 'OldRoad','Albuquerque','New Mexico','USA'),
('S304','1965-06-06','Twitch',NULL,'Wing',5,'1973-05-05',
 'Cliff','Dallas','Texas','USA'),
('S304','1975-07-07','Olda',NULL,'Fe',2,NULL,
 'Block','Houston','Texas','USA');
       -- Human (200) cumulative 170

-- =========================
-- DEEDS
-- neutral = 0, good > 0, bad < 0
-- Important: large positive deeds for N1 and N2 to ensure Nirvana >500 via deed totals.
-- =========================
DELETE FROM DEEDS;
INSERT INTO DEEDS (Deed_ID, Soul_ID, Description, Status, Timestamp, Date, Score, Street, City) VALUES
-- S300 deeds (mostly negative)
(1, 'S300', 'Scavenged food selfishly',       'Bad',    '10:00:00', '1986-03-01', -20, 'Mud Alley', 'Thiruvananthapuram'),
(2, 'S300', 'Spread pest spores',             'Bad',    '08:00:00', '1993-05-05', -50, 'Sewer', 'Thiruvananthapuram'),

-- S301 deeds (improvement)
(3, 'S301', 'Played with neighbourhood dogs', 'Good',   '09:00:00', '1983-04-01', 10, '7 Kennel Rd', 'Bengaluru'),
(4, 'S301', 'Saved a child from a well',      'Good',   '16:30:00', '1999-09-01', 100, 'Riverbank', 'Bengaluru'),
(5, 'S301', 'Donated to shelter',             'Good',   '12:00:00', '2001-02-02', 40, NULL, NULL),

-- S302 deeds
(6, 'S302', 'Helped marine rescue',           'Good',   '07:45:00', '2003-11-11', 30, '10 Ocean View', 'Manila'),
(7, 'S302', 'Illegally fished',               'Bad',    '05:30:00', '2004-08-18', -12, '10 Ocean View', 'Manila'),

-- S100 deeds (virtuous)
(8, 'S100', 'Lifelong charity',               'Good',   '10:00:00', '1960-06-06', 200, '7 Park Ave', 'Kolkata'),
(9, 'S100', 'Trained many healers',           'Good',   '09:00:00', '1979-09-09', 150, '7 Park Ave', 'Kolkata'),

-- S101 deeds
(10,'S101','Ran free clinic',                 'Good',   '10:00:00', '1966-04-04', 120, '12 Hope Rd', 'Singapore'),

-- S200 deeds (mixed)
(11,'S200','Horse theft ring leader',         'Bad',    '23:00:00', '1976-12-12', -40, '18 Ash St', 'Varanasi'),
(12,'S200','Rescued foals in flood',          'Good',   '06:00:00', '1990-10-10', 60, 'Stables', 'Varanasi'),

-- S201 deeds (bad)
(13,'S201','Toxic experiment release',        'Bad',    '02:00:00', '1970-01-01', -100, 'Lab', 'SomeCity'),

-- S302 further deeds
(14,'S302','Volunteered at cleanup',          'Good',   '08:00:00', '2010-05-05', 20, '10 Ocean View', 'Manila'),

-- S303 deeds
(15,'S303','Saved a village from flood',      'Good',   '11:11:00', '2000-07-07', 180, 'Town', 'CityA'),

-- S304 deeds
(16,'S304','Scared birds away',               'Neutral','12:12:00', '1976-08-08', 0, 'Cliff', 'CityB'),

-- Nirvana large deeds (ensure >500)
(100,'N1','Millennia-long meditation benefiting many','Good','00:00:00','1900-01-01',600,NULL,NULL),
(101,'N2','Selfless multigenerational service','Good','00:00:00','1905-01-01',700,NULL,NULL);


-- =========================
-- DEED_ACTION_TYPE
-- =========================
DELETE FROM DEED_ACTION_TYPE;
INSERT INTO DEED_ACTION_TYPE (Deed_ID, Soul_ID, Action_Type) VALUES
(1,'S300','greed'),
(2,'S300','gluttony'),
(3,'S301','envy'),
(4,'S301','wrath'),
(5,'S301','greed'),
(6,'S302','envy'),
(7,'S302','gluttony'),
(8,'S100','pride'),
(9,'S100','pride'),
(10,'S101','pride'),
(11,'S200','greed'),
(12,'S200','sloth'),
(13,'S201','greed'),
(14,'S302','sloth'),
(15,'S303','wrath'),
(16,'S304','sloth'),
(100,'N1','pride'),
(101,'N2','envy');

-- =========================
-- PUNISHMENTS
-- =========================
INSERT INTO PUNISHMENTS (ID, Action, Description, Location) VALUES
(1,'greed','Endless counting of unspendable coins','Vault of Echoes'),
(2,'envy','Ceaseless watching of others’ joy','Glass Garden'),
(3,'pride','Shrinking halls of mirrors','The Diminishing Hall'),
(4,'sloth','Uphill endless tasks','Slope of Toil'),
(5,'gluttony','Taste without nourishment','Banquetless Court'),
(6,'wrath','Flames that mirror one’s rage','The Ember Pit');

-- =========================
-- PUNISHMENT_ASSIGNED
-- =========================
INSERT INTO PUNISHMENT_ASSIGNED (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID, Duration, Status, Supervisor) VALUES
('S200',6,'wrath',11,1200,'In Progress',4),
('S201',1,'greed',13,2400,'In Progress',6),
('S300',5,'gluttony',2,365,'Pending',2),
('S302',5,'gluttony',7,180,'Pending',1);