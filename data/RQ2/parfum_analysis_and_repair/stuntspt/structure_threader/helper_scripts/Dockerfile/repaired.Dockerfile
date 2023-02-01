FROM ubuntu:20.04

# apt stuff
RUN apt update && apt install --no-install-recommends -y python3-pip parallel zip && rm -rf /var/lib/apt/lists/*;

# Pypi stuff
RUN pip install --no-cache-dir structure_threader

RUN mkdir /analysis
WORKDIR /analysis
