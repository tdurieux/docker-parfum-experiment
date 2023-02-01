FROM golang:1.12-stretch

RUN apt-get update && apt-get install --no-install-recommends -y upx && rm -rf /var/lib/apt/lists/*
