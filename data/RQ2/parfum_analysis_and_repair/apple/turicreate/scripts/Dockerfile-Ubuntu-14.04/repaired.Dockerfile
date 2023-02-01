# This image is intended for testing Turi Create on Ubuntu 14.04.

FROM ubuntu:14.04

# Prevent apt-get from asking questions and expecting answers
ENV DEBIAN_FRONTEND noninteractive

# Update package database
RUN apt-get update && apt-get -y --no-install-recommends install python2.7 python3.5 libgomp1 && rm -rf /var/lib/apt/lists/*; # Upgrade all possible packages
RUN apt-get -y upgrade

# Install Python 2.7 and 3.5 with apt, as well as
# turicreate and upstream dependencies


# Install pip and virtualenv
ADD https://bootstrap.pypa.io/pip/2.7/get-pip.py /src/get-pip.py
WORKDIR /src
RUN python2.7 get-pip.py
RUN pip2.7 install virtualenv
RUN python3.5 get-pip.py
RUN pip3.5 install virtualenv
