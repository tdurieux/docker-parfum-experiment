############################################################################
#
# This Dockerfile will create a docker image to run e2e tests using Protractor.
#
# Building:
#   $ docker build -t <image-name> .
#
# Usage:
#   $ docker run --rm <image-name>
#
############################################################################

FROM node:10

ARG project=ngx-smart-popover
ENV PROJECT_NAME=${project}

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -qy \
        openjdk-8-jre \
        chromium \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Add project files.
RUN mkdir /usr/src/app && rm -rf /usr/src/app
COPY ./ /usr/src/app/
WORKDIR /usr/src/app

ENTRYPOINT npm run e2e:entrypoint
