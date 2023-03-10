FROM ubuntu:18.04

ENV SINGULARITY_VERSION=2.5.1
# singularity, then other dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
        python \
        python-pip \
        python-setuptools \
        libarchive-dev \
        squashfs-tools \
        curl \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        gnupg \
        vim \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Build and install singularity
WORKDIR /root/singularity-build
RUN curl -f -SLO https://github.com/singularityware/singularity/releases/download/$SINGULARITY_VERSION/singularity-$SINGULARITY_VERSION.tar.gz \
    && tar xvf singularity-$SINGULARITY_VERSION.tar.gz \
    && cd singularity-$SINGULARITY_VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
    && make \
    && make install \
    && singularity --version && rm singularity-$SINGULARITY_VERSION.tar.gz

COPY singularity/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /root/build
CMD ['/bin/bash']