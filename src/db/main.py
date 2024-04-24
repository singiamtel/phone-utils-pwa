import sqlite3

connection = sqlite3.connect("db.sqlite3")

connection.execute(
    """
        CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT UNIQUE,
        email TEXT UNIQUE,
        password_hash TEXT
                )
"""
)
