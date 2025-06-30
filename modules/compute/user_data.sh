#!/bin/bash
# Install CloudWatch agent for metrics
yum install -y amazon-cloudwatch-agent

# Configure minimal metrics collection
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "resources": ["*"],
        "measurement": ["cpu_usage_idle", "cpu_usage_system", "cpu_usage_user"],
        "totalcpu": true
      },
      "mem": {
        "measurement": ["mem_used_percent"]
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Basic system updates
yum update -y
amazon-linux-extras install nginx1 python3.8 -y
yum install -y python3-pip mysql

# Install Python dependencies
pip3 install flask mysql-connector-python

# Create app directory
mkdir -p /var/www/app
cat > /var/www/app/app.py <<'EOW'
from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import os
import time
import sys

app = Flask(__name__)

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST'),
    'port': int(os.getenv('DB_PORT', 3306)),  # Convert port to integer
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}

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

@app.route('/')
def index():
    return render_template('index.html')

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

@app.route('/users')
def users():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    conn.close()
    
    return render_template('users.html', users=users)

if __name__ == '__main__':
    create_table()
    app.run(host='0.0.0.0', port=5000)
EOW

# Create templates directory
mkdir -p /var/www/app/templates
cat > /var/www/app/templates/index.html <<'EOW'
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="/login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
        <button type="submit">Login</button>
    </form>
</body>
</html>
EOW

cat > /var/www/app/templates/users.html <<'EOW'
<!DOCTYPE html>
<html>
<head>
    <title>Users</title>
</head>
<body>
    <h1>Registered Users</h1>
    <ul>
        {% for user in users %}
            <li>{{ user[1] }} - {{ user[2] }}</li>
        {% endfor %}
    </ul>
    <a href="/">Back to Login</a>
</body>
</html>
EOW

# Create systemd service
cat > /etc/systemd/system/flaskapp.service <<EOW
[Unit]
Description=Flask App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/app
Environment="DB_HOST=${db_host}"
Environment="DB_PORT=${db_port}"
Environment="DB_USER=${db_username}"
Environment="DB_PASSWORD=${db_password}"
Environment="DB_NAME=${db_name}"
ExecStart=/usr/bin/python3 /var/www/app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOW

# Start services
systemctl daemon-reload
systemctl enable flaskapp
systemctl start flaskapp

# Configure Nginx proxy
cat > /etc/nginx/conf.d/flaskapp.conf <<EOW
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOW

systemctl restart nginx