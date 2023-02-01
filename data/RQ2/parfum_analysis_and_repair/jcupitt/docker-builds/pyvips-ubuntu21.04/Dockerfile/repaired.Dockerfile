FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
	libvips-dev \
	python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pyvips


