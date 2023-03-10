# Use an official Python runtime as a base image
FROM python:3.6.9

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app
# ADD requirements.txt /app

# Expose the port uWSGI will listen on
EXPOSE 5000

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Define environment variable
ENV FLASK_ENV=development
ENV FLASK_DEBUG=1
ENV API_TOKEN=python-microservices-key
