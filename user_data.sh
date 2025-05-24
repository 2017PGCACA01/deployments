#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip git
pip3 install flask gunicorn

# Clone the feature branch of the repository
git clone -b feature https://github.com/2017PGCACA01/user_doc_ing.git /home/ubuntu/app
cd /home/ubuntu/app

# Start the Flask application using Gunicorn
nohup gunicorn app:app --bind 0.0.0.0:5000 &
