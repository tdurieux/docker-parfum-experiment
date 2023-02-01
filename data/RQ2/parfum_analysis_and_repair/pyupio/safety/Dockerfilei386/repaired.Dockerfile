#
# This dockerfile is used to build the 32bit linux binary
#
FROM i386/python:3.6-buster

RUN apt-get update

RUN python3 -m pip install --upgrade pip

# Install this before PyInstaller
RUN python3 -m pip install setuptools

# Test and build dependencies
RUN python3 -m pip install pyinstaller pytest

RUN mkdir /app
WORKDIR /app
COPY . ./

# Install this project dependencies