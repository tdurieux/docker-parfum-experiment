FROM python:3.7-slim

MAINTAINER AMAN SRIVASTAVA

WORKDIR /embedding-as-service

# assuming repo is up to date on host machine
RUN apt update -y && apt-get install --no-install-recommends -y \
    build-essential \
    vim \
    libicu-dev \
    build-essential \
    libpcre3 \
    libpcre3-dev && \
    pip install --no-cache-dir pip --upgrade && \
    pip install --no-cache-dir uwsgi -I && rm -rf /var/lib/apt/lists/*;

# create unprivileged user
RUN adduser --disabled-password --gecos '' myuser

COPY ./embedding-as-service/requirements.txt /embedding-as-service/requirements.txt
RUN pip install --no-cache-dir -r /embedding-as-service/requirements.txt

ADD ../ /embedding-as-service/