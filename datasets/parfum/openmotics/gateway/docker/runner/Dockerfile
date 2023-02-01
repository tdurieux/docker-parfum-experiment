FROM ubuntu:20.04

# setting installer to non interactive
ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone
RUN apt update && apt install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update -y
RUN apt-get install -y \
	sudo \
	curl \
	wget \
	bash \
	git \
	vim \
	build-essential \
	openvpn \
	python3 \
	python3-pip \
	iputils-ping \
	net-tools

# cleanup apt cache files
RUN rm -rf /var/lib/apt/lists/*

# install requirements
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Adding develop user
RUN useradd --create-home --shell /bin/bash "developer"
RUN adduser developer sudo
RUN echo "developer:dev" | chpasswd
RUN echo "ALL ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers
# USER developer

# Default command is to run bash terminal
CMD bash
