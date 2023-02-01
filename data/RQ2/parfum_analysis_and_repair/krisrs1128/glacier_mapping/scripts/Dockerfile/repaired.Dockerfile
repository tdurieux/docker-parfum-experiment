#!/usr/bin/env bash
FROM ubuntu:18.04

RUN apt-get update
RUN apt -y upgrade

RUN apt -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install build-essential libssl-dev libffi-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install vim ipython3 git && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt -y --no-install-recommends install gdal-bin libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir git+https://github.com/krisrs1128/glacier_mapping.git
