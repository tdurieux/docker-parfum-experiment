FROM python:3.7-slim-buster

ARG DEBIAN_FRONTEND=noninteractive

COPY ./ ./TenSEAL
WORKDIR /TenSEAL

RUN .github/workflows/scripts/install_req_docker.sh

ENV CC=clang \
    CXX=clang++

RUN pip3 install --no-cache-dir .

ENTRYPOINT [ "/bin/bash" ]
