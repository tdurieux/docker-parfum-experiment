FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

# Apt updates
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		build-essential \
		zlib1g-dev \
		git \
		libreadline-gplv2-dev \
		libncursesw5-dev \
		libssl-dev \
		libsqlite3-dev \
		tk-dev \
		libgdbm-dev \
		libc6-dev \
		libbz2-dev \
		tmux \
		wget \
		python3-tk && rm -rf /var/lib/apt/lists/*;

# Install python 3.6
RUN wget https://www.python.org/ftp/python/3.6.7/Python-3.6.7.tar.xz \
	&& tar xvf Python-3.6.7.tar.xz \
	&& cd Python-3.6.7 \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-zlib=/usr/include \
	&& make \
	&& make install \
	&& ln -s /usr/local/bin/python3 /usr/local/bin/python \
	&& ln -s /usr/local/bin/pip3 /usr/local/bin/pip && rm Python-3.6.7.tar.xz

# Install project-specific python libraries
RUN pip install --no-cache-dir tensorflow-gpu==1.12.0 gym matplotlib opencv-python lz4 psutil flake8 ray

# Symlinking for making ray work
RUN rm -r /usr/local/lib/python3.6/site-packages/ray/rllib \
	&& ln -s /ray/python/ray/rllib /usr/local/lib/python3.6/site-packages/ray/rllib \
	&& rm -r /usr/local/lib/python3.6/site-packages/ray/tune \
	&& ln -s /ray/python/ray/tune /usr/local/lib/python3.6/site-packages/ray/tune



WORKDIR /project
