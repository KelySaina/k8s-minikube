from flask import Flask
import pymysql
import os

app = Flask(__name__)

@app.route('/')
def hello():
    db = pymysql.connect(
        host=os.environ.get('MYSQL_HOST', 'localhost'),
        user=os.environ.get('MYSQL_USER', 'root'),
        password=os.environ.get('MYSQL_PASSWORD', ''),
        database=os.environ.get('MYSQL_DATABASE', '')
    )
    cursor = db.cursor()
    cursor.execute("SHOW TABLES;")
    tables = cursor.fetchall()
    return f"MySQL tables: {tables}"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
