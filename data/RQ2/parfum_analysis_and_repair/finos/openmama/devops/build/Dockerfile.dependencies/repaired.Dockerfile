# Use configurable image name
ARG IMAGE=centos:7.5.1804
FROM $IMAGE

# Assign arguments with defaults
ARG IMAGE

# Promote arguments to environment variables
ENV IMAGE $IMAGE

# Additional defaults for underlying scripts
ENV IS_DOCKER_BUILD true
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Add internal scripts here to prevent reruns
ADD install-dependencies.sh /tmp

# Run script to update dependencies
RUN /tmp/install-dependencies.sh

# Clean up dependency install script