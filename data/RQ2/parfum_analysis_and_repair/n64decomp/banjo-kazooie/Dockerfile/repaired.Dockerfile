FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

COPY packages.txt /
RUN apt-get update && apt-get install --no-install-recommends -y $(cat packages.txt) && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /
RUN python3 -m pip install -r requirements.txt

RUN mkdir /banjo
WORKDIR /banjo
