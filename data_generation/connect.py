from dotenv import load_dotenv
import os
import oracledb
import random
from faker import Faker
# .env-Datei laden
load_dotenv()

# Umgebungsvariablen holen
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
service = os.getenv("DB_SERVICE")

# DSN zusammenbauen im Format host:port/service
dsn = f"{host}:{port}/{service}"

# Verbindung herstellen
connection = oracledb.connect(
    user=user,
    password=password,
    dsn=dsn
)
fake = Faker()
# Test-Query
with connection.cursor() as cursor:
    cursor.execute("DELETE FROM PurchasePart")
    cursor.execute("DELETE FROM Purchase")
    cursor.execute("DELETE FROM HomeAddress")
    cursor.execute("DELETE FROM Thing")
    cursor.execute("DELETE FROM Client")
    connection.commit()
    clients=[]
    for i in range(10):
        name =fake.name()
        email = fake.email()
        cursor.execute("INSERT INTO CLIENT (CLIENT_ID, NAME, EMAIL_ADDRESS) VALUES (:1, :2, :3)", (i+1, name, email))
        connection.commit()
        clients.append(i+1)
        street=fake.street_address()
        city=fake.city()
        postal_code=fake.postalcode()
        cursor.execute("""
        INSERT INTO HOMEADDRESS (home_address_id,client_id,street,city,postal_code)
                       VALUES(:1,:2,:3,:4,:5)
                       """,((i+1),(i+1),street,city,postal_code))

    things=[]
    for i in range(5):
        name=fake.word().capitalize()
        description=fake.sentence()
        purchase_price=round(random.uniform(5,20),2)    
        sell_price = round(purchase_price * random.uniform(1.2, 2.0), 2)
        cursor.execute("""
        INSERT INTO Thing (thing_id, thing_name, thing_description, purchase_price, sell_price)
        VALUES (:1, :2, :3, :4, :5)
        """, (i+1, name, description, purchase_price, sell_price))
        connection.commit()
        things.append(i+1)

    purchase_id = 1
    purchase_part_id = 1
    for i in range(50):
        client_id = random.choice(clients)
        cursor.execute("INSERT INTO PURCHASE (PURCHASE_ID, CLIENT_ID) VALUES (:1, :2)", (i + 1, client_id))
        
        for _ in range(random.randint(1, 3)):
            thing_id = random.choice(things)
            quantity = random.randint(1, 5)
            cursor.execute("""
                INSERT INTO PURCHASEPART (PURCHASE_PART_ID, PURCHASE_ID, THING_ID, QUANTITY)
                VALUES (:1, :2, :3, :4)
            """, (purchase_part_id, i + 1, thing_id, quantity))  # i+1 statt purchase_id
            purchase_part_id += 1

        connection.commit() 

connection.close()
