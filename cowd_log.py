import mysql.connector
import random
import time
from datetime import datetime

# -----------------------------
# Database Connection
# -----------------------------
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="urbanflow"
)

cursor = db.cursor()

# -----------------------------
# Configuration
# -----------------------------
VEHICLE_IDS = [101, 102, 201, 202]   # existing vehicles
MAX_CAPACITY = 50                   # assumed max capacity
INTERVAL = 60                       # seconds

print("🚍 UrbanFlow Crowd Simulator Started...\n")

# -----------------------------
# Infinite Simulation Loop
# -----------------------------
while True:
    vehicle_id = random.choice(VEHICLE_IDS)

    # Simulated sensor passenger count
    passenger_count = random.randint(0, MAX_CAPACITY + 20)

    query = """
        INSERT INTO Crowd_Logs (vehicle_id, passenger_count, timestamp)
        VALUES (%s, %s, %s)
    """

    values = (vehicle_id, passenger_count, datetime.now())

    cursor.execute(query, values)
    db.commit()

    print(f"Inserted → Vehicle {vehicle_id} | "
          f"Passengers: {passenger_count}")

    time.sleep(INTERVAL)
