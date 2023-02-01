#Docker image for pogom

FROM python:2.7-alpine

# Default port the webserver runs on
EXPOSE 5000

# Working directory for the application
WORKDIR /usr/src/app

# Set Entrypoint
ENTRYPOINT ["python", "./runserver.py", "-H", "0.0.0.0", "-P", "5000"]

# Install required system packages