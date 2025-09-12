import sqlite3
import pandas as pd
import os

carpeta = 'exports'  # puede ser una ruta absoluta o relativa
os.makedirs(carpeta, exist_ok=True)  # crea la carpeta si no existe


for tabla in ['users', 'products', 'orders','order_items', 'events']:
    conn = sqlite3.connect('ecommerce.db')
    df = pd.read_sql_query(f'SELECT * FROM {tabla}', conn)

    ruta_csv = os.path.join(carpeta, f'{tabla}.csv')

    df.to_csv(ruta_csv, index=False)
    conn.close()

