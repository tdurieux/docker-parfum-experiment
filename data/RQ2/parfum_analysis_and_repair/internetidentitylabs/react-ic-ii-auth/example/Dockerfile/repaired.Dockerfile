FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        git \
        unzip \
        sudo \
        build-essential \
        cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

ADD ./scripts /scripts

RUN cp /scripts/dfxctl.sh /usr/bin/dfxctl \
    && chmod +x /usr/bin/dfxctl

RUN /scripts/provision-linux.sh

RUN git clone https://github.com/dfinity/internet-identity.git

ENV DFX_PROJECTS_DIR=/Projects

WORKDIR internet-identity

RUN npm install && npm cache clean --force;

CMD /scripts/dfx_run.sh


