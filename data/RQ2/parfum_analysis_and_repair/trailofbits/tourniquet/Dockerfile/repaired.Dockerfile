FROM ubuntu:18.04 as base

MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>

RUN apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y \
	clang-9 \
	git \
	build-essential \
	python3.7-dev \
	python3-pip \
	llvm-9-dev \
	libclang-9-dev \
	apt-transport-https \
	ca-certificates \
	gnupg \
	software-properties-common \
	wget && rm -rf /var/lib/apt/lists/*;

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
		| gpg --batch --dearmor - \
		| tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
	apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
	apt-get update && \
	apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

RUN python3.7 -m pip install --upgrade pip

WORKDIR /
COPY . /tourniquet

WORKDIR /tourniquet

RUN pip3 install --no-cache-dir -e .[dev]
