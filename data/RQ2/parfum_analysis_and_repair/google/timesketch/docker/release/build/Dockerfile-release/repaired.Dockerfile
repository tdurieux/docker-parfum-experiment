# Use the official Docker Hub Ubuntu 20.04 base image
FROM ubuntu:20.04

ARG PPA_TRACK=stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-transport-https apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libterm-readline-gnu-perl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:gift/$PPA_TRACK

RUN apt-get -y update
RUN apt-get -y upgrade

# Install dependencies
RUN apt-get -y --no-install-recommends install ca-certificates lsb-release locales python3-psycopg2 && rm -rf /var/lib/apt/lists/*;

# Install Plaso
RUN apt-get -y --no-install-recommends install plaso-tools && rm -rf /var/lib/apt/lists/*;

# Install Timesketch
RUN apt-get -y --no-install-recommends install timesketch-server && rm -rf /var/lib/apt/lists/*;

# Clean up apt-get cache files
RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Set terminal to UTF-8 by default
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
