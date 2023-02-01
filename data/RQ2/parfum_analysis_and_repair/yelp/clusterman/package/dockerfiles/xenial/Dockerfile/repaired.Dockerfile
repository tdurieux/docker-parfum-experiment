ARG DOCKER_REGISTRY
ARG IMAGE_NAME
FROM ${DOCKER_REGISTRY}/${IMAGE_NAME}

RUN apt-get -yq update && apt-get install -yq --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq update && apt-get install -yq --no-install-recommends \
            debhelper \
            dpkg-dev \
            gcc \
            gdebi-core \
            libfreetype6 \
            libatlas-base-dev \
            libyaml-dev \
            python3.7-dev \
            python-pip \
            wget && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && \
        wget https://mirrors.kernel.org/ubuntu/pool/universe/d/dh-virtualenv/dh-virtualenv_1.0-1_all.deb && \
        gdebi -n dh-virtualenv*.deb && \
        rm dh-virtualenv_*.deb
WORKDIR /work
