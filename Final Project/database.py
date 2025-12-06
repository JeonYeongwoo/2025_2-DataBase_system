import mysql.connector

def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="qpwoeiruty1!",  # <- change to your MySQL password
        database="db_apartment"
    )
