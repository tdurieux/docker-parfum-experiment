FROM IMAGE_URL_DEB
ARG git_repo_lib
ENV git_repo_lib=${git_repo_lib:-GIT_REPO_LIB}
ARG git_repo_client
ENV git_repo_client=${git_repo_client:-GIT_REPO_CLIENT}
ARG git_branch
ENV git_branch=${git_branch:-GIT_BRANCH}

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install \
    tzdata \
    net-tools \
    apt-utils \
    iproute2 && rm -rf /var/lib/apt/lists/*;

ARG pkgname
ENV pkgname=${pkgname:-linux-cli}

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install \
    git \
    python3 \
    python3-pip \
    network-manager \
    network-manager-openvpn \
    sudo \
    vim \
    pkg-config \
    iputils-ping \
    openvpn \
    libsecret-tools \
    dbus-x11 \
    gnome-keyring \
    libgirepository1.0-dev \
    gir1.2-nm-1.0 \
    libcairo2-dev \
    python3-xdg \
    python3-keyring \
    python3-distro \
    python3-jinja2 \
    python3-pytest \
    python3-pytest-cov \
    python3-bcrypt \
    python3-gnupg \
    python3-systemd \
    python3-openssl \
    python3-requests >= 2.16.0 \
    && python3 -m pip install --upgrade sentry-sdk==0.10.2 \
    && useradd -ms /bin/bash user \
    && usermod -a -G sudo user \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && rm -rf /var/lib/apt/lists/*;

RUN git clone --single-branch --branch $git_branch $git_repo_client \
    && cd proton-python-client && pip3 install --no-cache-dir -e . \
    && rm -rf .git \
    && cd .. \
    && git clone --single-branch --branch $git_branch $git_repo_lib \
    && cd protonvpn-nm-lib && pip3 install --no-cache-dir -e . \
    && rm -rf .git && cd ..

COPY docker_entry_deb.sh /usr/local/bin
COPY . /home/user/$pkgname

RUN chown -R user:user /home/user/$pkgname
WORKDIR /home/user/$pkgname

USER user

ENTRYPOINT ["/usr/local/bin/docker_entry_deb.sh"]
