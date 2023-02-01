FROM ubuntu:14.04

MAINTAINER Deshraj

# We will install the bare minimum required to run the django server

# Basics

RUN apt-get update && apt-get install --no-install-recommends -y build-essential g++ gcc gfortran wget python-dev git libjpeg-dev python-psycopg2 libpq-dev python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# Install dependencies for CloudCV Server

COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt
