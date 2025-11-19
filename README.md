# Souls, Caretakers, and Deeds Management System

## Project Overview
This database system manages the afterlife, tracking souls, their caretakers (angels and demons), deeds performed during life, and punishments assigned for bad deeds. The system maintains records of souls across three realms: Earth (living), Heaven, and Hell.

## Database Schema

### Tables
1. **SPECIES** - Different species that can have souls (Human, Dog, Cat, etc.)
2. **CARETAKER** - Angels and Demons who manage souls, organized in a hierarchical structure
3. **SOULS** - Individual souls and their current residence (Earth/Heaven/Hell)
4. **LIVES_ON_EARTH** - Records of souls' lives on Earth (supports reincarnation)
5. **DEEDS** - Actions performed by souls (Good, Bad, or Neutral)
6. **DEED_ACTION_TYPE** - Categorizes bad deeds by sin type (greed, envy, pride, lust, sloth, gluttony, wrath)
7. **PUNISHMENTS** - Available punishment types for each sin
8. **PUNISHMENT_ASSIGNED** - Punishments assigned to souls for their bad deeds

### Key Features
- **Hierarchical Caretaker Management**: Caretakers have managers, creating an organizational structure
- **Multi-life Support**: Souls can have multiple lives on Earth (reincarnation)
- **Seven Deadly Sins**: Bad deeds are categorized by sin type
- **Referential Integrity**: Comprehensive foreign key constraints with appropriate CASCADE/RESTRICT actions
- **Data Validation**: CHECK constraints ensure data integrity (e.g., completion dates only for Heaven/Hell, positive durations)

## Setup Instructions

### Prerequisites
- MySQL Server 5.7 or higher
- Python 3.8 or higher
- pip (Python package manager)

### Database Setup
1. Start MySQL server
2. Create the database schema:
   ```bash
   mysql -u your_username -p < src/schema.sql
   ```
3. Populate the database with sample data:
   ```bash
   mysql -u your_username -p < src/populate.sql
   ```

### Python Application Setup
1. Install required dependencies:
   ```bash
   pip install pymysql
   ```
2. Run the application:
   ```bash
   python src/main_app.py
   ```

## Sample Data Overview

### Populated Data Includes:
- **7 Species** (Human, Dog, Cat, Dolphin, Elephant, Parrot, Horse)
- **18 Caretakers** (Angels and Demons in a 3-tier hierarchy)
- **18 Souls** (5 in Heaven, 5 in Hell, 8 on Earth)
- **18 Lives** documented on Earth
- **24 Deeds** (8 Good, 12 Bad, 4 Neutral)
- **14 Punishment Types** (2 per sin category)
- **11 Punishment Assignments** (various statuses)

### Sample Queries You Can Run

#### Query Operations (Minimum 5 required):

1. **List all souls in a specific residence (Heaven/Hell/Earth)**
   - Find all souls currently residing in Heaven, Hell, or Earth
   - Useful for afterlife population analysis

2. **Find all deeds by a specific soul**
   - Shows complete deed history for a soul
   - Includes deed type, score, and location

3. **Get caretakers and their subordinates (hierarchy)**
   - Display organizational structure of caretakers
   - Shows manager-subordinate relationships

4. **Find souls with pending punishments**
   - List souls who have punishments assigned but not yet started
   - Useful for punishment scheduling

5. **Calculate total deed score for each soul**
   - Aggregate score across all deeds
   - Determines if soul should go to Heaven or Hell

6. **Find all punishments for a specific sin type**
   - Shows available punishments for greed, envy, pride, etc.
   - Helps assign appropriate punishments

7. **List souls by species**
   - Shows distribution of souls across different species
   - Useful for species-based analysis

8. **Find caretakers managing the most souls**
   - Identifies workload distribution among caretakers
   - Helps with resource management

#### Update Operations (Minimum 3 required):

1. **Add a new deed for a soul**
   - Insert a new deed (Good, Bad, or Neutral)
   - Automatically updates soul's karma score

2. **Assign a punishment to a soul for a bad deed**
   - Links a punishment to a soul's bad deed
   - Requires supervisor assignment

3. **Update soul's residence (Earth → Heaven/Hell)**
   - Move soul from Earth to afterlife
   - Sets completion date and assigns caretaker

4. **Update punishment status (Pending → In Progress → Completed)**
   - Track punishment execution progress
   - Enables punishment lifecycle management

5. **Delete a deed (and associated punishments)**
   - Removes deed from record
   - Cascades to remove related action types and punishments

## Data Integrity Features

### CHECK Constraints:
- Soul completion dates only for Heaven/Hell residents
- Positive soul scores for species
- Valid date ranges (DOB before DOD)
- Positive punishment durations
- Residence restricted to {Hell, Heaven, Earth}
- Caretaker class restricted to {Angel, Demon}
- Deed status restricted to {Good, Bad, Neutral}
- Action types restricted to 7 deadly sins

### Foreign Key Relationships:
- Souls reference Caretakers (with NULL for Earth residents)
- Lives reference Souls and Species
- Deeds reference Souls
- Deed Action Types reference Deeds
- Punishments are composite key (ID, Action)
- Punishment Assignments reference Souls, Punishments, Deeds, and Supervisors

### Cascading Actions:
- Deleting a Soul cascades to Lives, Deeds, and Punishment Assignments
- Deleting a Deed cascades to Action Types
- Deleting Caretakers is restricted if they supervise punishments
- Manager deletions set Manager_ID to NULL

## Project Structure
```
dna_phase_1/
├── README.md                 # This file
├── phase3.pdf               # Phase 3 design document (3NF schema)
└── src/
    ├── schema.sql           # Database schema creation script
    ├── populate.sql         # Sample data insertion script
    └── main_app.py          # Python CLI application (to be implemented)
```

## Future Enhancements (Phase 4 Implementation)
- Python CLI application with menu-driven interface
- Parameterized queries for SQL injection prevention
- Transaction management for complex operations
- Advanced reporting and analytics
- Audit logging for all database changes

## Team Information
- Project: Phase 4 - Database Implementation
- Course: Design and Analysis of Algorithms
- Submission Date: November 20, 2025