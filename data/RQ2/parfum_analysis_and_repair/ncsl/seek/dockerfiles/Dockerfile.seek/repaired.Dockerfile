# 18.04 or 20.04+ should work
FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

LABEL authors="Christopher Coogan <c.coogan2201@gmail.com>, Adam Li <ali39@jhu.edu>"

############# SYSTEM LEVEL INSTALLS #############
# install basic ubuntu utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential wget \
    python apt-utils \
    libglu1-mesa \
    git g++ gcc \
    libxmu-dev libxi6 libgconf-2-4 \
    libfontconfig1 libxrender1 \
    octave gawk \
    unzip curl \
    libxss1 libjpeg62 \
    tcsh bc dialog && rm -rf /var/lib/apt/lists/*;

# Node & bids-validator
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i -g bids-validator && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Seek dependencies as a python virtual environment
FROM python:3.8
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pipenv

# copy over Pipfiles
COPY Pipfile /tmp/

# Copy locking -> requirements.txt and install using pip
#RUN cd /tmp && pipenv lock --requirements > requirements.txt
#RUN pip3 install -r /tmp/requirements.txt

# or install by copying entire directory
#COPY . /tmp/myapp
#RUN pip3 install /tmp/myapp

# install via pipenv
RUN cd /tmp && pipenv install --skip-lock --system

############# KEEP BELOW SYSTEM LEVEL INSTALLS #############
# setup working directories
#WORKDIR /seek

# set environment variable for where analysis takes place
#ENV SEEKHOME /seek
#
## copy over data files
#COPY data /data
#
## copy over code and workflows
#COPY ./seek/ /seek/
#COPY ./workflow/ /workflow/
#COPY ./config/ /config/
