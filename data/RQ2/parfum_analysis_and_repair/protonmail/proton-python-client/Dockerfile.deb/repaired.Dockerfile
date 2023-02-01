FROM IMAGE_URL_DEB
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;

# Install a few useful packages

RUN apt-get install --no-install-recommends -y \
    net-tools \
    apt-utils \
    iproute2 \
    python3 \
    network-manager \
    network-manager-openvpn \
    sudo \
    vim \
    pkg-config \
    iputils-ping \
    openvpn \
    libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    dbus-x11 \
    libsecret-tools \
    gnome-keyring && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    python3-bcrypt \
    python3-gnupg \
    python3-openssl \
    python3-dnspython \
    python3-requests >= 2.16.0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    python3-pytest \
    python3-pytest-cov && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash user
RUN usermod -a -G sudo user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY docker_entry.sh /usr/local/bin
COPY . /home/user/proton-python-client

RUN chown -R user:user /home/user/proton-python-client
WORKDIR /home/user/proton-python-client

ENTRYPOINT ["/usr/local/bin/docker_entry.sh"]
