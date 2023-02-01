FROM ubuntu:latest

# Needed to be able to install python versions.
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
	python3.7 \
	python3.8 \
	python3.9 \
	python3.10 \
	gdal-bin \
	python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir tox
