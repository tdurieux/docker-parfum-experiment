FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y locales python3 python3-pip && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt