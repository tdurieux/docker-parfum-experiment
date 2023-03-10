# The base image we inherit from is videofront:alpine, but you can override this by
# passing a build argument to your build command, e.g.:
#
# docker build --build-arg BASE_TAG=${CIRCLE_SHA1}-alpine .
#
ARG BASE_TAG=alpine

FROM videofront:${BASE_TAG}

# Switch back to the root user to install development dependencies
USER root:root

# Create statics and media folders as defined in Development settings
RUN mkdir -p /data/{media,static}

# Install curl
RUN apk --no-cache add --update \
        curl \
        vim

# Install development dependencies
RUN python -c "import configparser; c = configparser.ConfigParser(); c.read('setup.cfg'); \
    print(c['options.extras_require']['dev'] + c['options.extras_require']['test'] + \
    c['options.extras_require']['quality'])" | xargs pip install

# Install dockerize. It is used to ensure that the database service is accepting
# connections before trying to access it from the main application.
ENV DOCKERIZE_VERSION v0.6.1
RUN curl -f -L \
         --output dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
         https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
