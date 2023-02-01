FROM ubuntu:20.04

# Global dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:inkscape.dev/stable &&\
    apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip inkscape=1.0.2+r75+1~ubuntu20.04.1 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip setuptools wheel

WORKDIR /elsie

# Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
RUN pip3 install --no-cache-dir .[cairo]

WORKDIR /slides
