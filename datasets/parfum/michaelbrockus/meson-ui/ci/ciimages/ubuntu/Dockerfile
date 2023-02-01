FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
RUN apt-get update --fix-missing && apt-get upgrade -y
RUN apt-get -y install apt-utils python3 python3-pip python3-wheel python3-setuptools

# Upgrade 'pip' package manager
RUN pip3 -q install --upgrade pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py
