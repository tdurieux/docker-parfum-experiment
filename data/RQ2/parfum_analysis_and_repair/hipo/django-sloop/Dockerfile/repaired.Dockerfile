FROM ubuntu:18.04

# Needed to be able to install python versions.
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install --no-install-recommends -y \
	python3.5 \
	python3.6 \
	python3.7 \
	libpq-dev \
	gdal-bin \
	python3-distutils \
	python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY requirements.txt .
COPY requirements_dev.txt .

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir tox
RUN pip3 install --no-cache-dir -r requirements_dev.txt