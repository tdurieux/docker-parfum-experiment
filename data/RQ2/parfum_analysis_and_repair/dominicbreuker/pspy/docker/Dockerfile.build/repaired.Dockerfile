FROM golang:1.18-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y upx && rm -rf /var/lib/apt/lists/*
