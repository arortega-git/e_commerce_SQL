import pandas as pd
import numpy as np
import os
import random
import sqlite3 as sql
from faker import Faker
from datetime import datetime, timedelta

conn = sql.connect('ecommerce.db')
cur = conn.cursor()

# Create tables

cur.executescript(
'''
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_time;
DROP TABLE IF EXISTS events;

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    signup_date DATE,
    country TEXT
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    category TEXT,
    price REAL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    order_date TIMESTAMP,
    total_amount REAL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price REAL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE events (
    event_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    event_type TEXT,
    event_time TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
'''
)

# Generate sample data

fake = Faker()
Faker.seed(42)
random.seed(42)

# Insertar usuarios
countries = ["Spain", "USA", "Germany", "France"]
for i in range(50):  
    signup_date = fake.date_between(start_date="-1y", end_date="today")
    cur.execute("INSERT INTO users (signup_date, country) VALUES (?, ?)",
                (signup_date, random.choice(countries)))

# Insertar productos
categories = ["Electronics", "Clothing", "Books", "Home"]
for i in range(20):  
    price = round(random.uniform(5, 500), 2)
    cur.execute("INSERT INTO products (category, price) VALUES (?, ?)",
                (random.choice(categories), price))

# Insertar pedidos y order_items
user_ids = [row[0] for row in cur.execute("SELECT user_id FROM users").fetchall()]
product_ids = [row[0] for row in cur.execute("SELECT product_id FROM products").fetchall()]

for i in range(200):  
    user_id = random.choice(user_ids)
    order_date = fake.date_time_between(start_date="-6m", end_date="now")
    total_amount = 0
    cur.execute("INSERT INTO orders (user_id, order_date, total_amount) VALUES (?, ?, ?)",
                (user_id, order_date, total_amount))
    order_id = cur.lastrowid
    
    for _ in range(random.randint(1, 5)):  # entre 1 y 5 productos por pedido
        product_id = random.choice(product_ids)
        quantity = random.randint(1, 3)
        price = cur.execute("SELECT price FROM products WHERE product_id=?",
                            (product_id,)).fetchone()[0]
        cur.execute("INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)",
                    (order_id, product_id, quantity, price))
        total_amount += price * quantity
    
    # update total
    cur.execute("UPDATE orders SET total_amount=? WHERE order_id=?", (total_amount, order_id))

# Insertar eventos
event_types = ["page_view", "add_to_cart", "purchase"]
for i in range(1000):  
    user_id = random.choice(user_ids)
    event_type = random.choice(event_types)
    event_time = fake.date_time_between(start_date="-6m", end_date="now")
    cur.execute("INSERT INTO events (user_id, event_type, event_time) VALUES (?, ?, ?)",
                (user_id, event_type, event_time))

# Guardar
conn.commit()
conn.close()