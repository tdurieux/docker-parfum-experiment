FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt dist-upgrade -y && \
    apt install --no-install-recommends -y python3 python3-pip python3-venv && \
    python3 -m pip install -U setuptools pip && \
    useradd -m -s /bin/bash stegoveritas && \
    mkdir -p /opt && rm -rf /var/lib/apt/lists/*;

COPY --chown=stegoveritas:stegoveritas . /opt/stegoveritas/

RUN cd /opt/stegoveritas && pip3 install --no-cache-dir -e .[dev] && \
    stegoveritas_install_deps

WORKDIR /home/stegoveritas
USER stegoveritas
