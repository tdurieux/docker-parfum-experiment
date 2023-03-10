FROM python:3.8

ENV PROJECT_PATH=/chirpstack-api

RUN git clone https://github.com/protocolbuffers/protobuf.git /protobuf
RUN git clone https://github.com/googleapis/googleapis.git /googleapis

RUN mkdir -p PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH