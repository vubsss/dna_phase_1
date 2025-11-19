-- Data Population Script for Souls, Caretakers, and Deeds Management System
-- Phase 4: Database Implementation

USE mini_world_db;

-- Populate SPECIES table
INSERT INTO SPECIES (Name, Soul_Score) VALUES
('Human', 100),
('Dog', 50),
('Cat', 45),
('Dolphin', 60),
('Elephant', 55),
('Parrot', 30),
('Horse', 40);

-- Populate CARETAKER table
-- God/Top-level caretaker (ID = 1, default for souls without assigned caretaker)
INSERT INTO CARETAKER (Name, Class, Manager_ID) VALUES
('Dombu', 'Angel', NULL);

-- Top-level managers (no Manager_ID)
INSERT INTO CARETAKER (Name, Class, Manager_ID) VALUES
('Michael', 'Angel', NULL),
('Lucifer', 'Demon', NULL),
('Gabriel', 'Angel', NULL),
('Beelzebub', 'Demon', NULL);

-- Mid-level caretakers (report to top-level)
INSERT INTO CARETAKER (Name, Class, Manager_ID) VALUES
('Raphael', 'Angel', 2),
('Uriel', 'Angel', 2),
('Azrael', 'Angel', 4),
('Mammon', 'Demon', 3),
('Asmodeus', 'Demon', 3),
('Leviathan', 'Demon', 5),
('Belphegor', 'Demon', 5);

-- Junior caretakers
INSERT INTO CARETAKER (Name, Class, Manager_ID) VALUES
('Cassiel', 'Angel', 6),
('Metatron', 'Angel', 7),
('Sandalphon', 'Angel', 8),
('Abaddon', 'Demon', 9),
('Belial', 'Demon', 10),
('Mephistopheles', 'Demon', 11),
('Azazel', 'Demon', 12);

-- Populate SOULS table
-- Active Souls in Heaven (ID format: SX)
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
('S1', 'Eleanor', 'Marie', 'Shellstrop', 'Heaven', '2024-01-15', 6),
('S2', 'Chidi', 'Anagonye', 'Ekwonu', 'Heaven', '2024-02-20', 7),
('S3', 'Tahani', 'Jamil', 'Al-Jamil', 'Heaven', '2023-12-10', 8),
('S4', 'Jason', 'Mendoza', 'Fitzgerald', 'Heaven', '2024-03-05', 6),
('S5', 'Janet', NULL, 'Entity', 'Heaven', '2023-11-25', 7);

-- Active Souls in Hell (ID format: SX)
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
('S6', 'Trevor', 'James', 'Morrison', 'Hell', '2024-01-10', 9),
('S7', 'Vicky', 'Lynn', 'Chambers', 'Hell', '2024-02-14', 10),
('S8', 'Shawn', 'Michael', 'Hayes', 'Hell', '2023-10-30', 11),
('S9', 'Glenn', 'Robert', 'Stevens', 'Hell', '2024-04-01', 12),
('S10', 'Bambadjan', NULL, 'Pierre', 'Hell', '2023-09-15', 9);

-- Active Souls on Earth (still living, ID format: SX)
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
('S11', 'John', 'David', 'Smith', 'Earth', NULL, 1),
('S12', 'Maria', 'Elena', 'Garcia', 'Earth', NULL, 1),
('S13', 'Wei', NULL, 'Chen', 'Earth', NULL, 1),
('S14', 'Priya', 'Lakshmi', 'Sharma', 'Earth', NULL, 1),
('S15', 'Ahmed', 'Hassan', 'Ali', 'Earth', NULL, 1),
('S16', 'Sophie', 'Anne', 'Dubois', 'Earth', NULL, 1),
('S17', 'Yuki', NULL, 'Tanaka', 'Earth', NULL, 1),
('S18', 'Carlos', 'Miguel', 'Rodriguez', 'Earth', NULL, 1);

-- Souls who achieved Nirvana (ID format: NX)
-- Note: These souls have merged with the divine and are no longer in the cycle
INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID) VALUES
('N1', 'Buddha', 'Siddhartha', 'Gautama', 'Heaven', '0563-01-01', 1),
('N2', 'Mahavira', 'Vardhamana', 'Jnatrputra', 'Heaven', '0527-01-01', 1);

-- Populate LIVES_ON_EARTH table
INSERT INTO LIVES_ON_EARTH (Soul_ID, DOB, F_Name, M_Name, L_Name, Species_ID, DOD, Birth_Street, Birth_City, Birth_State, Birth_Country) VALUES
-- Eleanor's life
('S1', '1982-10-14', 'Eleanor', 'Marie', 'Shellstrop', 1, '2016-01-01', '123 Main St', 'Phoenix', 'Arizona', 'USA'),
-- Chidi's life
('S2', '1977-10-14', 'Chidi', 'Anagonye', 'Ekwonu', 1, '2016-03-14', '456 University Ave', 'Dakar', 'Dakar Region', 'Senegal'),
-- Tahani's life
('S3', '1989-02-14', 'Tahani', 'Jamil', 'Al-Jamil', 1, '2016-06-20', '1 Kensington Palace', 'London', 'England', 'UK'),
-- Jason's life
('S4', '1985-02-28', 'Jason', 'Mendoza', 'Fitzgerald', 1, '2016-05-15', '789 Beach Blvd', 'Jacksonville', 'Florida', 'USA'),
-- Janet (not human, but an entity)
('S5', '0001-01-01', 'Janet', NULL, 'Entity', 1, '2016-01-01', 'The Good Place', 'Afterlife', 'Ethereal', 'Universe'),
-- Trevor's life
('S6', '1975-06-06', 'Trevor', 'James', 'Morrison', 1, '2015-12-25', '666 Chaos Ave', 'Los Angeles', 'California', 'USA'),
-- Vicky's life
('S7', '1980-10-31', 'Vicky', 'Lynn', 'Chambers', 1, '2016-02-01', '13 Dark Lane', 'Salem', 'Massachusetts', 'USA'),
-- Shawn's life
('S8', '1970-04-01', 'Shawn', 'Michael', 'Hayes', 1, '2015-10-01', '100 Evil St', 'Detroit', 'Michigan', 'USA'),
-- Glenn's life
('S9', '1990-07-15', 'Glenn', 'Robert', 'Stevens', 1, '2016-03-30', '200 Fire Rd', 'Portland', 'Oregon', 'USA'),
-- Bambadjan's life
('S10', '1965-11-11', 'Bambadjan', NULL, 'Pierre', 1, '2015-08-20', '50 Ocean Dr', 'Paris', 'Ile-de-France', 'France'),
-- Currently living souls
('S11', '1995-03-22', 'John', 'David', 'Smith', 1, NULL, '500 Oak Street', 'New York', 'New York', 'USA'),
('S12', '1988-07-10', 'Maria', 'Elena', 'Garcia', 1, NULL, '234 Palm Ave', 'Madrid', 'Madrid', 'Spain'),
('S13', '1992-12-05', 'Wei', NULL, 'Chen', 1, NULL, '88 Dragon Road', 'Beijing', 'Beijing', 'China'),
('S14', '1990-01-18', 'Priya', 'Lakshmi', 'Sharma', 1, NULL, '42 Temple Street', 'Mumbai', 'Maharashtra', 'India'),
('S15', '1987-09-30', 'Ahmed', 'Hassan', 'Ali', 1, NULL, '15 Nile Avenue', 'Cairo', 'Cairo', 'Egypt'),
('S16', '1993-05-25', 'Sophie', 'Anne', 'Dubois', 1, NULL, '77 Eiffel Way', 'Paris', 'Ile-de-France', 'France'),
('S17', '1991-11-08', 'Yuki', NULL, 'Tanaka', 1, NULL, '5 Sakura Lane', 'Tokyo', 'Tokyo', 'Japan'),
('S18', '1989-08-14', 'Carlos', 'Miguel', 'Rodriguez', 1, NULL, '300 Beach Road', 'Barcelona', 'Catalonia', 'Spain');

-- Past lives for enlightened souls (multiple reincarnations)
INSERT INTO LIVES_ON_EARTH (Soul_ID, DOB, F_Name, M_Name, L_Name, Species_ID, DOD, Birth_Street, Birth_City, Birth_State, Birth_Country) VALUES
('N1', '0563-04-08', 'Siddhartha', NULL, 'Gautama', 1, '0483-01-01', 'Lumbini Gardens', 'Lumbini', 'Kapilavastu', 'Nepal'),
('N1', '0643-01-01', 'Unknown', NULL, 'Ascetic', 1, '0583-01-01', 'Forest Path', 'Bodh Gaya', 'Bihar', 'India'),
('N2', '0599-01-01', 'Vardhamana', NULL, 'Jnatrputra', 1, '0527-01-01', 'Kshatriyakund', 'Vaishali', 'Bihar', 'India');

-- Populate DEEDS table
-- Good deeds
INSERT INTO DEEDS (Soul_ID, Description, Status, Timestamp, Date, Score, Street, City) VALUES
('S1', 'Donated to charity anonymously', 'Good', '14:30:00', '2015-06-15', 50, '123 Main St', 'Phoenix'),
('S2', 'Helped elderly neighbor with groceries', 'Good', '10:15:00', '2015-11-20', 30, '456 University Ave', 'Dakar'),
('S3', 'Organized fundraiser for children hospital', 'Good', '18:00:00', '2015-08-10', 80, '1 Kensington Palace', 'London'),
('S4', 'Rescued a puppy from traffic', 'Good', '09:45:00', '2015-12-05', 40, '789 Beach Blvd', 'Jacksonville'),
('S11', 'Volunteered at homeless shelter', 'Good', '16:20:00', '2025-01-10', 60, '500 Oak Street', 'New York'),
('S12', 'Tutored underprivileged children', 'Good', '15:00:00', '2025-02-14', 55, '234 Palm Ave', 'Madrid'),
('S13', 'Planted trees in community park', 'Good', '08:30:00', '2025-03-22', 45, '88 Dragon Road', 'Beijing'),
('S14', 'Donated blood regularly', 'Good', '11:00:00', '2025-04-05', 35, '42 Temple Street', 'Mumbai'),
('S5', 'Helped lost soul find purpose', 'Good', '12:00:00', '2015-07-01', 90, 'The Good Place', 'Afterlife'),
('S2', 'Taught philosophy with patience', 'Good', '09:00:00', '2015-10-10', 70, '456 University Ave', 'Dakar');

-- Bad deeds
INSERT INTO DEEDS (Soul_ID, Description, Status, Timestamp, Date, Score, Street, City) VALUES
('S6', 'Embezzled money from company', 'Bad', '22:30:00', '2015-10-15', -100, '666 Chaos Ave', 'Los Angeles'),
('S7', 'Spread malicious rumors about colleague', 'Bad', '13:45:00', '2015-11-25', -40, '13 Dark Lane', 'Salem'),
('S8', 'Cheated on partner multiple times', 'Bad', '23:00:00', '2015-09-10', -70, '100 Evil St', 'Detroit'),
('S9', 'Stole from workplace repeatedly', 'Bad', '19:20:00', '2015-12-20', -60, '200 Fire Rd', 'Portland'),
('S10', 'Verbally abused family members', 'Bad', '20:15:00', '2015-07-30', -80, '50 Ocean Dr', 'Paris'),
('S11', 'Littered in national park', 'Bad', '12:00:00', '2024-08-15', -20, '500 Oak Street', 'New York'),
('S15', 'Cut in line at grocery store', 'Bad', '17:30:00', '2025-05-10', -10, '15 Nile Avenue', 'Cairo'),
('S18', 'Took credit for coworker work', 'Bad', '14:45:00', '2025-06-20', -50, '300 Beach Road', 'Barcelona'),
('S6', 'Hoarded resources during crisis', 'Bad', '15:20:00', '2015-11-01', -85, '666 Chaos Ave', 'Los Angeles'),
('S7', 'Gossiped about friend success', 'Bad', '11:30:00', '2015-12-10', -35, '13 Dark Lane', 'Salem'),
('S8', 'Lied to avoid responsibility', 'Bad', '16:45:00', '2015-08-25', -45, '100 Evil St', 'Detroit'),
('S10', 'Destroyed someone reputation out of anger', 'Bad', '19:00:00', '2015-06-15', -90, '50 Ocean Dr', 'Paris');

-- Neutral deeds
INSERT INTO DEEDS (Soul_ID, Description, Status, Timestamp, Date, Score, Street, City) VALUES
('S1', 'Bought coffee', 'Neutral', '07:00:00', '2015-05-01', 0, '123 Main St', 'Phoenix'),
('S4', 'Watched TV all day', 'Neutral', '12:00:00', '2015-10-30', 0, '789 Beach Blvd', 'Jacksonville'),
('S16', 'Went for a walk', 'Neutral', '06:30:00', '2025-07-01', 0, '77 Eiffel Way', 'Paris'),
('S17', 'Read a book', 'Neutral', '19:00:00', '2025-08-12', 0, '5 Sakura Lane', 'Tokyo'),
('S12', 'Ate lunch alone', 'Neutral', '13:00:00', '2025-03-15', 0, '234 Palm Ave', 'Madrid');

-- Populate DEED_ACTION_TYPE table
-- Bad deeds action types (sins)
INSERT INTO DEED_ACTION_TYPE (Deed_ID, Soul_ID, Action_Type) VALUES
(11, 'S6', 'greed'),
(12, 'S7', 'envy'),
(13, 'S8', 'lust'),
(14, 'S9', 'greed'),
(15, 'S10', 'wrath'),
(16, 'S11', 'sloth'),
(17, 'S15', 'pride'),
(18, 'S18', 'envy'),
(19, 'S6', 'greed'),
(19, 'S6', 'gluttony'),
(20, 'S7', 'envy'),
(20, 'S7', 'wrath'),
(21, 'S8', 'pride'),
(22, 'S10', 'wrath');

-- Populate PUNISHMENTS table
INSERT INTO PUNISHMENTS (Action, Description, Location) VALUES
('greed', 'Push heavy boulders up a mountain eternally', 'Circle 4 of Hell'),
('greed', 'Boiled in oil while counting worthless coins', 'Greed Vault'),
('envy', 'Eyes sewn shut while hearing others happiness', 'Envy Chamber'),
('envy', 'Forced to watch others receive praise eternally', 'Hall of Mirrors'),
('pride', 'Broken on the wheel repeatedly', 'Pride Peak'),
('pride', 'Carry heavy stones on back while crawling', 'Mount Humility'),
('lust', 'Blown about by violent storms eternally', 'Second Circle'),
('lust', 'Burned in flames of desire', 'Passion Pit'),
('sloth', 'Run continuously without rest', 'Sloth Stadium'),
('sloth', 'Forced to do endless meaningless tasks', 'Futility Fields'),
('gluttony', 'Lie in vile slush while being rained on', 'Circle 3 of Hell'),
('gluttony', 'Force-fed until bursting, then healed', 'Feast Hall'),
('wrath', 'Fight each other in muddy river eternally', 'River Styx'),
('wrath', 'Torn apart by demons repeatedly', 'Wrath Arena');

-- Populate PUNISHMENT_ASSIGNED table
-- Punishments for souls in Hell
INSERT INTO PUNISHMENT_ASSIGNED (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID, Duration, Status, Supervisor) VALUES
('S6', 1, 'greed', 11, 3650, 'In Progress', 9),
('S6', 5, 'pride', 11, 1825, 'Pending', 9),
('S7', 3, 'envy', 12, 2000, 'In Progress', 10),
('S8', 7, 'lust', 13, 5000, 'In Progress', 11),
('S8', 5, 'pride', 21, 1000, 'Completed', 11),
('S9', 2, 'greed', 14, 2500, 'In Progress', 12),
('S10', 13, 'wrath', 15, 4000, 'In Progress', 9),
('S10', 6, 'pride', 15, 1500, 'Pending', 9);

-- Some punishments for currently living souls (pending for afterlife)
INSERT INTO PUNISHMENT_ASSIGNED (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID, Duration, Status, Supervisor) VALUES
('S11', 9, 'sloth', 16, 365, 'Pending', 12),
('S15', 5, 'pride', 17, 180, 'Pending', 9),
('S18', 4, 'envy', 18, 500, 'Pending', 10);

-- Additional punishments for multiple infractions
INSERT INTO PUNISHMENT_ASSIGNED (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID, Duration, Status, Supervisor) VALUES
('S6', 11, 'gluttony', 19, 2000, 'Pending', 16),
('S7', 13, 'wrath', 20, 1200, 'Pending', 17),
('S10', 14, 'wrath', 22, 1800, 'In Progress', 9);
