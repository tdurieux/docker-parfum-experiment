# Set Up the Basic System
FROM python:3-slim

# Mount the host directory
COPY . /opt/django
WORKDIR /opt/django

# Get Packages and Other Dependencies
RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r /opt/django/requirements.txt gunicorn supervisor certbot

# Set environment variables
RUN python ./deploy/generate_env.py

EXPOSE 80
EXPOSE 443
