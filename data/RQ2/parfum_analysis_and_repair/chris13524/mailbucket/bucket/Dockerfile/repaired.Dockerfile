# taken from https://github.com/mozart-analytics/grails-docker/blob/master/grails-3/Dockerfile
FROM java:8

# Set customizable env vars defaults.
# Set Grails version (default: 3.2.8; min: 3.0.0; max: 3.2.8).
ARG GRAILS_VERSION=3.3.1

# Install Grails