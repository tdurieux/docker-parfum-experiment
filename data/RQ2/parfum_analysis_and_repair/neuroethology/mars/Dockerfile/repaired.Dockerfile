FROM tensorflow/tensorflow:1.15.0-gpu-py3

ENV SHELL /bin/bash

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends -y install python3-opencv && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r docker_requirements.txt

WORKDIR /app/mars_v1_8
