# DOCKERFILE for trifusion-cli https://github.com/ODiogoSilva/TriFusion
FROM ubuntu:16.04
MAINTAINER Diogo N. Silva, diogosilva@medicina.ulisboa.pt

RUN apt-get update && apt-get -y --no-install-recommends install \
	python-all-dev \
	python-setuptools \
	python-configparser \
	python-matplotlib \
	python-numpy \
	python-psutil \
	python-scipy \
	python-seaborn \
	python-pandas \
	python-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/user

RUN pip install --no-cache-dir trifusion

RUN bash
