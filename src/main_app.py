#!/usr/bin/env python3
"""
main_app.py - CLI interface for mini_world_db (Phase 4)
Implements:
- Write operations:
    * Insert new soul
    * Insert a deed
    * Update soul id
    * Update punishment status
    * Update residence of souls (Earth -> Hell)
    * Delete caretaker (handles referential integrity errors)
- Read operations (5 queries):
    1) Location Analysis: Negative Deed Percentage (by City)
    2) Caretaker Workload Evaluation (Max Workload)
    3) Caretaker Fairness: Harshness Index
    4) Species Behavior Analysis
    5) Unresolved Punishments Audit (maps 'Active' -> 'In Progress')
"""
import sys
import pymysql
from getpass import getpass
from datetime import datetime

DB_HOST = 'localhost'
DB_NAME = 'afterlife_db'


def get_db_connection(db_user, db_pass, db_host, db_name):
    try:
        conn = pymysql.connect(
            host=db_host,
            user=db_user,
            password=db_pass,
            database=db_name,
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=False
        )
        print("Database connection successful.")
        return conn
    except pymysql.Error as e:
        print(f"Error connecting to MySQL Database: {e}", file=sys.stderr)
        return None


# -----------------------
# Write operations
# -----------------------
def insert_new_soul(conn):
    """
    Insert into SOULS:
    ID (varchar), F_Name, M_Name (optional), L_Name, Residence, Date_of_Completion (optional), Caretaker_ID (optional)
    """
    print("\n--- Insert New Soul ---")
    sid = input("Soul ID (e.g. S999 or N123): ").strip()
    fname = input("First name: ").strip()
    mname = input("Middle name (press Enter if none): ").strip() or None
    lname = input("Last name: ").strip()
    residence = input("Residence (Hell/Heaven/Earth/Nirvana) [default Earth]: ").strip() or 'Earth'
    doc_input = input("Date_of_Completion (YYYY-MM-DD) or blank: ").strip()
    doc = doc_input if doc_input else None
    caretaker_input = input("Caretaker_ID (numeric) or blank: ").strip()
    caretaker_id = int(caretaker_input) if caretaker_input else None

    sql = """
    INSERT INTO SOULS (ID, F_Name, M_Name, L_Name, Residence, Date_of_Completion, Caretaker_ID)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (sid, fname, mname, lname, residence, doc, caretaker_id))
        conn.commit()
        print(f"Inserted soul {sid}")
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error inserting soul: {e}")


def insert_deed(conn):
    """
    Insert into DEEDS. Deed_ID is AUTO_INCREMENT; omit it to let DB assign.
    Required: Soul_ID, Description, Status, Timestamp, Date, Score
    Optional: Street, City
    """
    print("\n--- Insert Deed ---")
    soul_id = input("Soul ID (must exist): ").strip()
    description = input("Description: ").strip()
    status = input("Status (Good/Bad/Neutral): ").strip()
    time_str = input("Time (HH:MM:SS) [default now]: ").strip() or datetime.now().strftime("%H:%M:%S")
    date_str = input("Date (YYYY-MM-DD) [default today]: ").strip() or datetime.now().strftime("%Y-%m-%d")
    score_input = input("Score (integer, positive good, negative bad): ").strip() or "0"
    try:
        score = int(score_input)
    except ValueError:
        print("Invalid score; using 0.")
        score = 0
    street = input("Street (optional): ").strip() or None
    city = input("City (optional): ").strip() or None

    sql = """
    INSERT INTO DEEDS (Soul_ID, Description, Status, Timestamp, Date, Score, Street, City)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (soul_id, description, status, time_str, date_str, score, street, city))
        conn.commit()
        # fetch last insert id for convenience
        with conn.cursor() as cur:
            cur.execute("SELECT LAST_INSERT_ID() AS last_id")
            last = cur.fetchone()
        print(f"Inserted deed (Deed_ID={last['last_id']}) for soul {soul_id}")
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error inserting deed: {e}")


def update_soul_id(conn):
    """
    Update SOULS ID (primary key) from old to new.
    This will cascade to dependent tables if ON UPDATE CASCADE present.
    """
    print("\n--- Update Soul ID ---")
    old_id = input("Existing Soul ID (to change): ").strip()
    new_id = input("New Soul ID: ").strip()

    sql = "UPDATE SOULS SET ID = %s WHERE ID = %s"
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (new_id, old_id))
        affected = cur.rowcount
        conn.commit()
        if affected:
            print(f"Updated soul ID: {old_id} -> {new_id} (affected rows in SOULS: {affected})")
        else:
            print("No rows updated (old ID not found).")
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error updating soul ID: {e}")


def update_punishment_status(conn):
    """
    Update PUNISHMENT_ASSIGNED.Status for a given composite key.
    """
    print("\n--- Update Punishment Status ---")
    soul_id = input("Soul_ID: ").strip()
    punishment_id_input = input("Punishment_ID (int): ").strip()
    deed_id_input = input("Deed_ID (int): ").strip()
    action = input("Punishment_Action (greed/envy/pride/lust/sloth/gluttony/wrath): ").strip()
    new_status = input("New Status (Pending/In Progress/Completed/Pardoned): ").strip()

    try:
        punishment_id = int(punishment_id_input)
        deed_id = int(deed_id_input)
    except ValueError:
        print("Punishment_ID and Deed_ID must be integers.")
        return

    sql = """
    UPDATE PUNISHMENT_ASSIGNED
    SET Status = %s
    WHERE Soul_ID = %s AND Punishment_ID = %s AND Punishment_Action = %s AND Deed_ID = %s
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (new_status, soul_id, punishment_id, action, deed_id))
        affected = cur.rowcount
        conn.commit()
        if affected:
            print(f"Updated punishment status to '{new_status}' for ({soul_id}, {punishment_id}, {action}, {deed_id})")
        else:
            print("No matching punishment assignment found.")
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error updating punishment status: {e}")


def update_residence_of_souls(conn):
    """
    Update residence of SOULS: set Residence = 'Hell' WHERE Residence = 'Earth'
    (user requested that operation)
    """
    print("\n--- Update Residence: Earth -> Hell ---")
    sql = "UPDATE SOULS SET Residence = %s WHERE Residence = %s"
    try:
        with conn.cursor() as cur:
            cur.execute(sql, ('Hell', 'Earth'))
        affected = cur.rowcount
        conn.commit()
        print(f"Updated residence from 'Earth' to 'Hell' for {affected} rows.")
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error updating residence: {e}")


def delete_caretaker(conn):
    """
    Delete CARETAKER by ID. If referential integrity prevents deletion, report error and suggest action.
    Note: some FKs are ON DELETE SET NULL (SOULS.Caretaker_ID), others are RESTRICT (PUNISHMENT_ASSIGNED.Supervisor).
    """
    print("\n--- Delete Caretaker ---")
    cid_input = input("Caretaker ID to delete (int): ").strip()
    try:
        cid = int(cid_input)
    except ValueError:
        print("Invalid ID.")
        return

    sql = "DELETE FROM CARETAKER WHERE ID = %s"
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (cid,))
        affected = cur.rowcount
        conn.commit()
        if affected:
            print(f"Caretaker {cid} deleted (rows affected: {affected}).")
        else:
            print("No caretaker deleted (ID not found).")
    except pymysql.Error as e:
        conn.rollback()
        # Likely cause: RESTRICT due to existing referenced rows (e.g., active punishments supervised)
        print(f"Error deleting caretaker: {e}")
        print("Likely cause: referential integrity restriction (caretaker is referenced by other rows).")
        print("Options: reassign or remove dependent rows in PUNISHMENT_ASSIGNED or set Supervisor to NULL where allowed.")


# -----------------------
# Read operations (queries)
# -----------------------
def query_location_negative_deed_percentage(conn):
    """
    Location Analysis: Negative Deed Percentage.
    Note: DEEDS table in your schema has City and Street but not State/Country; we compute by City.
    Filters by a date range provided by user.
    """
    print("\n--- Location Analysis: Negative Deed Percentage (by City) ---")
    date_from = input("Start date (YYYY-MM-DD) [default 1990-01-01]: ").strip() or '1990-01-01'
    date_to = input("End date (YYYY-MM-DD) [default 2023-12-31]: ").strip() or '2023-12-31'
    min_deeds_input = input("Minimum deeds per city to include (default 1): ").strip() or '1'
    try:
        min_deeds = int(min_deeds_input)
    except ValueError:
        min_deeds = 1

    # Using City as location granularity because DEEDS lacks State/Country
    sql = f"""
    SELECT
        City,
        COUNT(Deed_ID) AS Total_Deeds,
        SUM(CASE WHEN Score < 0 THEN 1 ELSE 0 END) AS Negative_Deed_Count,
        (SUM(CASE WHEN Score < 0 THEN 1 ELSE 0 END) / NULLIF(COUNT(Deed_ID), 0)) * 100 AS Negative_Deed_Percentage
    FROM DEEDS
    WHERE Date BETWEEN %s AND %s
    GROUP BY City
    HAVING COUNT(Deed_ID) >= %s
    ORDER BY Negative_Deed_Percentage DESC
    LIMIT 100
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (date_from, date_to, min_deeds))
            rows = cur.fetchall()
        if not rows:
            print("No results for given date range / thresholds.")
            return
        print(f"{'City':30s} | Total | Negative | % Negative")
        print("-" * 70)
        for r in rows:
            city = r['City'] or '(Unknown)'
            print(f"{city:30s} | {r['Total_Deeds']:5d} | {r['Negative_Deed_Count']:8d} | {float(r['Negative_Deed_Percentage'] or 0):8.2f}%")
    except pymysql.Error as e:
        print(f"Error running query: {e}")


def query_caretaker_workload(conn):
    """
    Caretaker Workload Evaluation (Max Workload)
    """
    print("\n--- Caretaker Workload Evaluation ---")
    sql = """
    SELECT 
        C.ID AS Caretaker_ID,
        C.Name AS Caretaker_Name,
        C.Class,
        COUNT(DISTINCT S.ID) AS Total_Souls_Supervised,
        COUNT(DISTINCT PA.Punishment_ID) AS Total_Punishments_Overseen,
        (COUNT(DISTINCT S.ID) + COUNT(DISTINCT PA.Punishment_ID)) / 2.0 AS Avg_Workload_Score
    FROM 
        CARETAKER C
    LEFT JOIN 
        SOULS S ON C.ID = S.Caretaker_ID
    LEFT JOIN 
        PUNISHMENT_ASSIGNED PA ON C.ID = PA.Supervisor
    GROUP BY 
        C.ID, C.Name, C.Class
    ORDER BY 
        Avg_Workload_Score DESC
    LIMIT 100
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = cur.fetchall()
        if not rows:
            print("No caretakers found.")
            return
        print(f"{'ID':3s} {'Name':20s} {'Class':6s} {'Souls':6s} {'Punishments':11s} {'AvgWorkload':10s}")
        print("-" * 70)
        for r in rows:
            print(f"{r['Caretaker_ID']:3d} {r['Caretaker_Name'][:20]:20s} {r['Class'][:6]:6s} "
                  f"{r['Total_Souls_Supervised']:6d} {r['Total_Punishments_Overseen']:11d} {float(r['Avg_Workload_Score']):10.2f}")
    except pymysql.Error as e:
        print(f"Error running query: {e}")


def query_harshness_index(conn):
    """
    Caretaker Fairness: Harshness Index
    Focus on negative deeds only.
    """
    print("\n--- Caretaker Fairness: Harshness Index (negative deeds only) ---")
    sql = """
    SELECT 
        C.Name AS Caretaker_Name,
        DAT.Action_Type,
        AVG(ABS(D.Score)) AS Avg_Severity_Magnitude,
        AVG(PA.Duration) AS Avg_Punishment_Duration,
        (AVG(PA.Duration) / NULLIF(AVG(ABS(D.Score)), 0)) AS Harshness_Index
    FROM 
        CARETAKER C
    JOIN 
        PUNISHMENT_ASSIGNED PA ON C.ID = PA.Supervisor
    JOIN 
        DEEDS D ON PA.Deed_ID = D.Deed_ID
    JOIN 
        DEED_ACTION_TYPE DAT ON D.Deed_ID = DAT.Deed_ID
    WHERE 
        D.Score < 0
    GROUP BY 
        C.Name, DAT.Action_Type
    ORDER BY 
        Harshness_Index DESC
    LIMIT 200
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = cur.fetchall()
        if not rows:
            print("No data for harshness index.")
            return
        print(f"{'Caretaker':20s} {'Action':10s} {'AvgSeverity':12s} {'AvgDuration':12s} {'Harshness':10s}")
        print("-" * 80)
        for r in rows:
            sev = float(r['Avg_Severity_Magnitude'] or 0)
            dur = float(r['Avg_Punishment_Duration'] or 0)
            hi = float(r['Harshness_Index'] or 0)
            print(f"{r['Caretaker_Name'][:20]:20s} {r['Action_Type'][:10]:10s} {sev:12.2f} {dur:12.2f} {hi:10.2f}")
    except pymysql.Error as e:
        print(f"Error running query: {e}")


def query_species_behavior(conn):
    """
    Species Behavior Analysis - average deed score by species
    """
    print("\n--- Species Behavior Analysis ---")
    sql = """
    SELECT 
        SP.Name AS Species_Name,
        COUNT(D.Deed_ID) AS Total_Deeds_Recorded,
        AVG(D.Score) AS Average_Deed_Score
    FROM 
        SPECIES SP
    JOIN 
        LIVES_ON_EARTH L ON SP.ID = L.Species_ID
    JOIN 
        DEEDS D ON L.Soul_ID = D.Soul_ID
    GROUP BY 
        SP.Name
    ORDER BY 
        Average_Deed_Score ASC
    LIMIT 200
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = cur.fetchall()
        if not rows:
            print("No species-deed linkage data found.")
            return
        print(f"{'Species':15s} {'Total Deeds':12s} {'Avg Deed Score':14s}")
        print("-" * 45)
        for r in rows:
            print(f"{r['Species_Name'][:15]:15s} {r['Total_Deeds_Recorded']:12d} {float(r['Average_Deed_Score'] or 0):14.2f}")
    except pymysql.Error as e:
        print(f"Error running query: {e}")


def query_unresolved_punishments(conn):
    """
    Unresolved Punishments Audit
    The user requested 'Active' status; schema uses values like 'In Progress'.
    We'll treat 'Active' as equivalent to 'In Progress'. We'll include both 'In Progress' and 'Pending' optionally.
    """
    print("\n--- Unresolved Punishments Audit ---")
    print("Note: 'Active' mapped to 'In Progress' in this DB.")
    sql = """
    SELECT 
        S.F_Name, 
        S.L_Name, 
        P.Action AS Punishment_Type, 
        PA.Duration AS Duration_Remaining, 
        PA.Status AS Punishment_Status,
        C.Name AS Supervisor_Name
    FROM 
        SOULS S
    JOIN 
        PUNISHMENT_ASSIGNED PA ON S.ID = PA.Soul_ID
    JOIN 
        PUNISHMENTS P ON PA.Punishment_ID = P.ID
    JOIN 
        CARETAKER C ON PA.Supervisor = C.ID
    WHERE 
        PA.Status = 'In Progress'
    ORDER BY 
        PA.Duration DESC
    LIMIT 500
    """
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = cur.fetchall()
        if not rows:
            print("No unresolved (In Progress) punishments found.")
            return
        print(f"{'Soul':25s} {'Punishment':25s} {'Duration':8s} {'Status':12s} {'Supervisor':15s}")
        print("-" * 100)
        for r in rows:
            soul_name = f"{r['F_Name']} {r['L_Name']}"
            print(f"{soul_name[:25]:25s} {r['Punishment_Type'][:25]:25s} {r['Duration_Remaining']:8d} {r['Punishment_Status'][:12]:12s} {r['Supervisor_Name'][:15]:15s}")
    except pymysql.Error as e:
        print(f"Error running query: {e}")


# -----------------------
# CLI main loop
# -----------------------
def main_cli(conn):
    try:
        while True:
            print("\n========== Mini World DB Interface ==========")
            print("WRITE / UPDATE / DELETE")
            print("1: Insert new soul")
            print("2: Insert a deed")
            print("3: Update soul ID (primary key change)")
            print("4: Update punishment status")
            print("5: Update residence of souls (set Earth -> Hell)")
            print("6: Delete caretaker (may fail if referenced)")
            print("")
            print("READ / QUERY")
            print("7: Location Analysis: Negative Deed Percentage (by City)")
            print("8: Caretaker Workload Evaluation (Max Workload)")
            print("9: Caretaker Fairness: Harshness Index")
            print("10: Species Behavior Analysis")
            print("11: Unresolved Punishments Audit (In Progress)")
            print("")
            print("q: Quit")
            print("===========================================")

            choice = input("Enter your choice: ").strip().lower()
            if choice == '1':
                insert_new_soul(conn)
            elif choice == '2':
                insert_deed(conn)
            elif choice == '3':
                update_soul_id(conn)
            elif choice == '4':
                update_punishment_status(conn)
            elif choice == '5':
                update_residence_of_souls(conn)
            elif choice == '6':
                delete_caretaker(conn)
            elif choice == '7':
                query_location_negative_deed_percentage(conn)
            elif choice == '8':
                query_caretaker_workload(conn)
            elif choice == '9':
                query_harshness_index(conn)
            elif choice == '10':
                query_species_behavior(conn)
            elif choice == '11':
                query_unresolved_punishments(conn)
            elif choice == 'q':
                print("Exiting application...")
                break
            else:
                print("Invalid choice. Please try again.")
    finally:
        if conn:
            conn.close()
            print("Database connection closed.")


if __name__ == "__main__":
    print("Please enter your MySQL credentials.")
    DB_USER = input("Username: ").strip()
    DB_PASS = getpass("Password: ")

    conn = get_db_connection(DB_USER, DB_PASS, DB_HOST, DB_NAME)
    if conn:
        main_cli(conn)
    else:
        print("Failed to connect to the database. Application will exit.")
        sys.exit(1)
