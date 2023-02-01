FROM ubuntu:18.04

WORKDIR /modestpy

# System
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y libgfortran3 gcc g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjpeg8-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Modestpy
WORKDIR /modestpy
COPY . .
RUN python3 -m pip install -U pip
RUN python3 -m pip install .
RUN python3 -m pip install -r requirements.txt
ENTRYPOINT ["/bin/bash"]
