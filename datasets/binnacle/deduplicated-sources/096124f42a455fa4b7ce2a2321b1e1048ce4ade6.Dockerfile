# This Dockerfile is based off the Google App Engine Python runtime image
# https://github.com/GoogleCloudPlatform/python-runtime
FROM uccser/django:1.11.16

# Add metadata to Docker image
LABEL maintainer="csse-education-research@canterbury.ac.nz"

# Set terminal to be noninteractive
ARG DEBIAN_FRONTEND=noninteractive

ENV DJANGO_PRODUCTION=False
EXPOSE 8080

# Copy and create virtual environment
COPY requirements /requirements

# Install dependencies
RUN /docker_venv/bin/pip3 install -r /requirements/local.txt

RUN mkdir /cs-field-guide/
RUN mkdir /cs-field-guide/csfieldguide/
WORKDIR /cs-field-guide/csfieldguide/
