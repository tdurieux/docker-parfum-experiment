FROM fedora:34

RUN dnf install -y initscripts \
    iputils \
    ethtool \
    python3.9 \
    python-pip \
    gcc \
    python-devel \
    libxml2-devel \
    libxslt-devel \
    libvirt \
    libvirt-devel \
    libnl3 \
    git \
    perf \
    libnl3-devel && \
    curl -f -sSL https://install.python-poetry.org | \
    python3 - --version 1.1.13

COPY . /lnst
RUN cd /lnst/container_files && chmod +x install.sh && sh install.sh

CMD cd /lnst/.bin && ./lnst-agent
