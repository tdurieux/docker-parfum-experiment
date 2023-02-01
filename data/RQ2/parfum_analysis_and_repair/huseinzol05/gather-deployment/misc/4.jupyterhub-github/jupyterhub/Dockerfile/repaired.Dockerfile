FROM ubuntu:18.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    git \
    python3 \
    python3-pip \
    portaudio19-dev \
    libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir tornado==5.1.1

RUN npm install -g configurable-http-proxy && npm cache clean --force;

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app

COPY . /app
