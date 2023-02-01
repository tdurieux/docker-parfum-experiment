FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-wheel \
    nginx && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /app

COPY . /app
