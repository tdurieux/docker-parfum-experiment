FROM python:3.10.5-slim-bullseye

RUN apt-get update -y
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir pwntools solana base58
RUN mkdir -p /tmp/solver

WORKDIR /tmp/solver
COPY . .

WORKDIR /tmp/solver
