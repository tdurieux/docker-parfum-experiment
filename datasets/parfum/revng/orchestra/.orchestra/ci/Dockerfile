FROM ubuntu:20.04

COPY install-dependencies.sh /install-dependencies.sh
COPY install-system-dependencies.sh /install-system-dependencies.sh
COPY install-python-dependencies.sh /install-python-dependencies.sh

RUN /install-dependencies.sh \
    && apt-get autoremove --yes --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -G sudo -m user && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user
WORKDIR /home/user
