# Use an official Python runtime as a parent image
FROM python:3.7

# Set the working directory to /app
WORKDIR /app

RUN mkdir /app/shared

# Copy the requirement.txt file
COPY requirements.txt /app/requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Copy the whole project
COPY . /app/soweego

# Move to soweego folder
WORKDIR /app/soweego

# Enable the logging config file
RUN mv pipeline-logging-config.json logging.json

# Defines the entry point of the image
ENTRYPOINT [ "python", "-m", "soweego", "-l", "soweego", "DEBUG", "run" ]
