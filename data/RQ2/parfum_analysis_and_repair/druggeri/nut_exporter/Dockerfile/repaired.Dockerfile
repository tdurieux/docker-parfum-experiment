### STAGE 1: Build ###

FROM golang:1-bullseye as builder

WORKDIR /app
COPY . /app
RUN go install

### STAGE 2: Setup ###