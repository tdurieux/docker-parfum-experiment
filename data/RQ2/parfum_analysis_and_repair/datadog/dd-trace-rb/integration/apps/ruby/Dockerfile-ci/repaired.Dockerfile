# Select base image
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Add gem
COPY . /vendor/dd-trace-rb

# Install dependencies
# Setup specific version of ddtrace, if specified.