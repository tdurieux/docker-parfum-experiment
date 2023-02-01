# Dockerfile for building pykaldi image from pykaldi-min image
FROM pykaldi/prereqs:latest

# Copy pykaldi directory into the container
COPY . /pykaldi

# Install PyKaldi