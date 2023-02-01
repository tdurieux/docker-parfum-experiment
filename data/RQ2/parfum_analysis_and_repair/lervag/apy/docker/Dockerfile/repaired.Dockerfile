FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --no-install-recommends -y python3-pyqt5.qtwebengine python3-pyqt5.qtmultimedia && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir aqt==2.1.53
RUN pip install --no-cache-dir git+https://github.com/lervag/apy.git#egg=apy

ENV SHELL=bash

WORKDIR /home/apy

CMD bash
