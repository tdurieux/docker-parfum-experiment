# Base-image for nodejs on any machine using a template variable
FROM balenalib/%%BALENA_MACHINE_NAME%%-node:latest

# Set the maintainer
LABEL maintainer="Randall Wood <rhwood@mac.com>"

ARG WORKING_DIR=/usr/src/app

# Set the working directory
WORKDIR ${WORKING_DIR}

# Install dependencies
RUN install_packages jq

# Copy everything into the container
COPY . ./

# Install dependencies and clean up to minimize size
RUN JOBS=MAX npm ci --production --unsafe-perm \
  && npm cache clean --force

ENV WORKING_DIR ${WORKING_DIR}
ENV HOMEBRIDGE_DIR /data/.homebridge/

# Start application