FROM ubuntu:20.04

# argument required by tzdata installation from software-properties-common
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update; \
	apt install --no-install-recommends -y graphviz \
			git \
			wget \
			curl; rm -rf /var/lib/apt/lists/*; \
	# clean install Python3.9
	apt install --no-install-recommends -y build-essential \
		zlib1g-dev \
		libncurses5-dev \
		libgdbm-dev \
		libnss3-dev \
		libssl-dev \
		libreadline-dev \
		libffi-dev \
		libsqlite3-dev \
		libbz2-dev; \
	wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz; \
	tar -xf Python-3.9.7.tgz; \
	( cd Python-3.9.7 || exit; \
		./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations; \
		make -j 12; \
		make altinstall;) \

	rm -rf Python-3.9.7.tgz Python-3.9.7; \
	# install pip for Python3.9
	curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
	python3.9 get-pip.py; \
	rm -rf get-pip.py; \
	# install flake8
	pip install --no-cache-dir flake8; \
	# add dev non-root user
	useradd --shell /bin/bash --create-home devcontainer;

USER devcontainer

# Built with ❤ by [Pipeline Foundation](https://pipeline.foundation)
