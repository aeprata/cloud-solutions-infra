from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import os
import time
import sys

app = Flask(__name__)

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}

# Function to create the users table if it doesn't exist
def create_table():
    max_retries = 5
    wait_seconds = 5
    
    for attempt in range(max_retries):
        try:
            conn = mysql.connector.connect(**db_config)
            cursor = conn.cursor()
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    username VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            conn.commit()
            conn.close()
            print("Table created successfully")
            return
        except mysql.connector.Error as err:
            print(f"Database connection failed (attempt {attempt+1}/{max_retries}): {err}")
            time.sleep(wait_seconds)
    
    print("FATAL: Could not connect to database after multiple attempts")
    sys.exit(1)

# Route for the login page
@app.route('/')
def index():
    return render_template('index.html')

# Route to handle login form submission and save user to database
@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    
    # Save to database
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO users (username) VALUES (%s)", (username,))
    conn.commit()
    conn.close()
    
    return redirect(url_for('users'))

# Route to display all registered users
@app.route('/users')
def users():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    conn.close()
    
    return render_template('users.html', users=users)

if __name__ == '__main__':
    # Create the users table and start the Flask app
    create_table()
    app.run(host='0.0.0.0', port=5000)