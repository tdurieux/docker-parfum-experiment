FROM python:3.8.0-slim

RUN useradd -ms /bin/bash serenata_de_amor
WORKDIR /home/serenata_de_amor/toolbox

RUN apt-get update && \
    apt-get install -y && \
    apt-get install --no-install-recommends -y gcc gfortran python-dev libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN python setup.py develop
