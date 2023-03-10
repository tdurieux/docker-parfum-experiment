# Docker Image for Isomer
#
# This image essentially packages up Isomer along with mongodb
# into a Docker Image/Container.
#
# Usage Examples::
#
# To run your instance and see if the backend starts:
#     $ docker run -i -t isomeric/isomer /bin/bash -c "/etc/init.d/mongodb start && iso launch"
#
# To investigate problems on the docker container, i.e. get a shell:
#     $ docker run -i -t --name isomer-test-live -t isomeric/isomer
#
# If you want to run a productive instance with working SSL:
#     $ docker run -i -p 127.0.0.1:443:443 -t isomeric/isomer /bin/bash -c "/etc/init.d/mongodb start && \
#       python3 iso launch --port 443 --cert /etc/ssl/certs/isomer/selfsigned.pem --log 10 --dev"
#
# VERSION: 1.1.2
#
# Last Updated: 20170712

FROM debian:experimental
MAINTAINER Heiko 'riot' Weinen <riot@c-base.org>

# Install dependencies

RUN echo "C.UTF-8" > /etc/locale.gen
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /home/isomer

# Copy repository

COPY . isomer
WORKDIR isomer

# Install Isomer

RUN install

#  Services

# Activate mongodb

RUN echo smallfiles = true >> /etc/mongodb.conf

EXPOSE 443

# There is a frontend development server with hot reloading which can be started with
#   $ isomer/frontend/npm run start
# If you want to run the frontend development live server, uncomment this:
#
# EXPOSE 8081