# The dockerfile of the env for testing Facerec

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --no-install-recommends -y \
    python3-pip \
    python3-opencv \
    cmake \
    libatlas-base-dev \
    build-essential \
    python3-setuptools \
    python-execnet && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y wget sudo nano && rm -rf /var/lib/apt/lists/*;

RUN sudo -H pip3 --no-cache-dir install face_recognition terminaltables
