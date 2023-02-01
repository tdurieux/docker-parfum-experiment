FROM ubuntu:14.04

RUN apt-get update && \
    apt-get autoclean

RUN apt-get install --no-install-recommends -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install \
    -y --no-install-recommends python3.6 && rm -rf /var/lib/apt/lists/*;

RUN python3.6 --version

# https://pip.pypa.io/en/stable/installing/
RUN apt-get update && apt-get install \
    -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.6 get-pip.py

RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install pyqt5==5.9.2

RUN apt-get update && apt-get install \
    -y --no-install-recommends \
    '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install \
    -y --no-install-recommends \
    libfontconfig1 && rm -rf /var/lib/apt/lists/*;

RUN python3.6 -c "from PyQt5 import QtCore, QtWidgets"

COPY main.py main.py
