FROM fedora:latest

RUN yum update -y && \
    yum install -y python3 python3-pip && \
    python3 -m pip install -U setuptools pip && \
    useradd -m -s /bin/bash stegoveritas && \
    mkdir -p /opt && rm -rf /var/cache/yum

COPY --chown=stegoveritas:stegoveritas . /opt/stegoveritas/

RUN cd /opt/stegoveritas && pip3 install --no-cache-dir -e .[dev] && \
    stegoveritas_install_deps

WORKDIR /home/stegoveritas
USER stegoveritas
