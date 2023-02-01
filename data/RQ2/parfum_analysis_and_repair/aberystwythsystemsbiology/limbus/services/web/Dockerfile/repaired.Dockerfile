FROM ubuntu:20.04

LABEL authors="Keiron O'Shea <keo7@aber.ac.uk>, Chuan Lu <cul@aber.ac.uk>"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3 python3-pip python3-wheel python3-setuptools \
    gv libffi-dev libcairo2-dev libpango1.0-dev libgirepository1.0-dev && rm -rf /var/lib/apt/lists/*;



RUN npm install yarn -g && npm cache clean --force;

WORKDIR /limbus
ADD . /limbus

RUN pip3 install --no-cache-dir -r requirements.txt