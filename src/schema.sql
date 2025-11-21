-- Phase 4: Database Implementation
CREATE DATABASE IF NOT EXISTS afterlife_db;
USE afterlife_db;

-- Table: SPECIES
-- Stores different species that can have souls
CREATE TABLE SPECIES (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Soul_Score INT NOT NULL
);

-- Table: CARETAKER
-- Stores information about angels and demons who manage souls
CREATE TABLE CARETAKER (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Class ENUM('Angel', 'Demon') NOT NULL,
    Manager_ID INT DEFAULT NULL,
    CONSTRAINT fk_caretaker_manager FOREIGN KEY (Manager_ID) 
        REFERENCES CARETAKER(ID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

-- Table: SOULS
-- Stores information about souls in the afterlife
CREATE TABLE SOULS (
    ID VARCHAR(51) PRIMARY KEY,
    F_Name VARCHAR(100) NOT NULL,
    M_Name VARCHAR(100),
    L_Name VARCHAR(100) NOT NULL,
    Residence ENUM('Hell', 'Heaven', 'Earth', 'Nirvana') NOT NULL DEFAULT 'Earth',
    Date_of_Completion DATE DEFAULT NULL,
    Caretaker_ID INT,
    CONSTRAINT fk_souls_caretaker FOREIGN KEY (Caretaker_ID) 
        REFERENCES CARETAKER(ID) 
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_completion_date CHECK (
        (Residence = 'Earth' AND Date_of_Completion IS NULL) OR
        (Residence IN ('Hell', 'Heaven') AND Date_of_Completion IS NOT NULL) OR
        (Residence = 'Nirvana' AND Date_of_Completion IS NULL)
    )
);

-- Table: LIVES_ON_EARTH
-- Stores information about souls' lives on Earth
CREATE TABLE LIVES_ON_EARTH (
    Soul_ID VARCHAR(51) NOT NULL,
    DOB DATE NOT NULL,
    F_Name VARCHAR(100) NOT NULL,
    M_Name VARCHAR(100),
    L_Name VARCHAR(100) NOT NULL,
    Species_ID INT NOT NULL,
    DOD DATE DEFAULT NULL,
    Birth_Street VARCHAR(255),
    Birth_City VARCHAR(100),
    Birth_State VARCHAR(100),
    Birth_Country VARCHAR(100),
    PRIMARY KEY (Soul_ID, DOB),
    CONSTRAINT fk_lives_soul FOREIGN KEY (Soul_ID) 
        REFERENCES SOULS(ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_lives_species FOREIGN KEY (Species_ID) 
        REFERENCES SPECIES(ID) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT chk_dob_dod CHECK (DOD IS NULL OR DOD >= DOB)
);

-- Table: DEEDS
-- Stores deeds performed by souls
CREATE TABLE DEEDS (
    Deed_ID INT,
    Soul_ID VARCHAR(51) NOT NULL,
    Description TEXT NOT NULL,
    Status ENUM('Good', 'Bad', 'Neutral') NOT NULL,
    Timestamp TIME NOT NULL,
    Date DATE NOT NULL,
    Score INT NOT NULL,
    Street VARCHAR(255),
    City VARCHAR(100),
    D_State VARCHAR(100),
    Country VARCHAR(100)
    PRIMARY KEY (Deed_ID, Soul_ID),
    CONSTRAINT fk_deeds_soul FOREIGN KEY (Soul_ID) 
        REFERENCES SOULS(ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Table: DEED_ACTION_TYPE
-- Stores the action types (sins/virtues) associated with deeds
CREATE TABLE DEED_ACTION_TYPE (
    Deed_ID INT NOT NULL,
    Soul_ID VARCHAR(51) NOT NULL,
    Action_Type ENUM('greed', 'envy', 'pride', 'lust', 'sloth', 'gluttony', 'wrath') NOT NULL,
    PRIMARY KEY (Deed_ID, Soul_ID, Action_Type),
    CONSTRAINT fk_deed_action_deed FOREIGN KEY (Deed_ID, Soul_ID) 
        REFERENCES DEEDS(Deed_ID, Soul_ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Table: PUNISHMENTS
-- Stores types of punishments available
CREATE TABLE PUNISHMENTS (
    ID INT AUTO_INCREMENT,
    Action ENUM('greed', 'envy', 'pride', 'lust', 'sloth', 'gluttony', 'wrath') NOT NULL,
    Description TEXT NOT NULL,
    Location VARCHAR(255),
    PRIMARY KEY (ID, Action)
);

-- Table: PUNISHMENT_ASSIGNED
-- Stores punishments assigned to souls for their deeds
CREATE TABLE PUNISHMENT_ASSIGNED (
    Soul_ID VARCHAR(51) NOT NULL,
    Punishment_ID INT NOT NULL,
    Punishment_Action ENUM('greed', 'envy', 'pride', 'lust', 'sloth', 'gluttony', 'wrath') NOT NULL,
    Deed_ID INT NOT NULL,
    Duration INT NOT NULL,
    Status ENUM('Pending', 'In Progress', 'Completed') NOT NULL DEFAULT 'Pending',
    Supervisor INT DEFAULT 1,
    PRIMARY KEY (Soul_ID, Punishment_ID, Punishment_Action, Deed_ID),
    CONSTRAINT fk_punishment_assigned_soul FOREIGN KEY (Soul_ID) 
        REFERENCES SOULS(ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_punishment_assigned_punishment FOREIGN KEY (Punishment_ID, Punishment_Action) 
        REFERENCES PUNISHMENTS(ID, Action) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_punishment_assigned_deed FOREIGN KEY (Deed_ID, Soul_ID) 
        REFERENCES DEEDS(Deed_ID, Soul_ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_punishment_assigned_supervisor FOREIGN KEY (Supervisor) 
        REFERENCES CARETAKER(ID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    CONSTRAINT chk_duration CHECK (Duration > 0)
);

-- Create indexes for better query performance
CREATE INDEX idx_souls_residence ON SOULS(Residence);
CREATE INDEX idx_souls_caretaker ON SOULS(Caretaker_ID);
CREATE INDEX idx_deeds_status ON DEEDS(Status);
CREATE INDEX idx_deeds_date ON DEEDS(Date);
CREATE INDEX idx_lives_species ON LIVES_ON_EARTH(Species_ID);
CREATE INDEX idx_punishment_status ON PUNISHMENT_ASSIGNED(Status);
