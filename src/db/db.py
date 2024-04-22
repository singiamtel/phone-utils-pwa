import sqlite3

db = sqlite3.connect("db.sqlite3")

db.execute(
    """
        CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT
                )
"""
)
