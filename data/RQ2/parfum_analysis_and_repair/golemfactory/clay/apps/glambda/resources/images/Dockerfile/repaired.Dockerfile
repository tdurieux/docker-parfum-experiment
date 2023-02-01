# Dockerfile for a base image for computing tasks in Golem.
# Installs python and sets up directories for Golem tasks.

FROM ubuntu:18.04 as builder

ENV RASPA_DIR=/opt/RASPA

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget curl pkg-config libopenbabel-dev swig \
    && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
        apt-utils \
		curl \
		bzip2 \
        git \
        libtool \
        automake \
        make \
		libglu1-mesa \
		libgomp1 && \
    apt-get upgrade -y && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/numat/RASPA2.git && \
    cd RASPA2 && \
    git checkout 256c44ea04fd79eefda67e394e4ea49346032bde && \
    mkdir m4 && \
    aclocal && \
    autoreconf -i && \
    automake --add-missing && \
    autoconf && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${RASPA_DIR} && \
    make  -j8 && \
    make install && \
    chmod -R 757 ${RASPA_DIR}/

FROM golemfactory/base:1.8
ENV RASPA_DIR=/opt/RASPA

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget curl pkg-config libopenbabel-dev swig \
    && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

 RUN set -x \
    && pip3 install --no-cache-dir cloudpickle==0.6.1 RASPA2 openbabel

WORKDIR /
COPY --from=builder /opt/RASPA /opt
RUN mkdir -p /golem/scripts
COPY glambda/resources/scripts/job.py /golem/scripts/job.py
