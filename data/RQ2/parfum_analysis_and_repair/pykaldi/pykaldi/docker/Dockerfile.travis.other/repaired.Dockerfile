# Dockerfile for building pykaldi image from pykaldi-min image
FROM pykaldi/pykaldi:latest

# Copy pykaldi directory into the container
COPY . /pykaldi_travis

# Install PyKaldi