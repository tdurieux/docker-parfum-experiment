# Use an official Python runtime as a parent image
FROM python:3.7-slim

# Set the working directory to /app
WORKDIR /app

# Install needed packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    iputils-ping \
    curl \
    bc && rm -rf /var/lib/apt/lists/*;

# Copy the current directory contents into the container at /app
ADD ./wsgi.py /app/wsgi.py

# Copy licence
ADD ./LICENSE /app

# Copy test data
ADD ./docker/backend/tests /app/tests

# master / worker port
EXPOSE 17011

# backend port
EXPOSE 5005

# Create worker user
RUN useradd -c "Worker" worker  -s /bin/bash
RUN chmod 700 /app
RUN chmod 1777 /tmp

# Add dev watch script
COPY ./scripts/watch.sh /app/watch.sh

# Build PLynx package
ADD ./plynx /tmp/plynx
ADD ./setup.py /tmp/setup.py
ADD ./requirements.txt /tmp/requirements.txt
ADD ./requirements-dev.txt /tmp/requirements-dev.txt
RUN cd /tmp && python setup.py install

# install extra docker requirements
ADD ./docker/backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
RUN rm /app/requirements.txt
