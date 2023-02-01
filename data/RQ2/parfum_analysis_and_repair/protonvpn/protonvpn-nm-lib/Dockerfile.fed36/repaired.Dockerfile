FROM IMAGE_URL_FED36
ARG git_repo
ENV git_repo=${git_repo:-GIT_REPO}
ARG git_branch
ENV git_branch=${git_branch:-GIT_BRANCH}

RUN dnf update -y

# Install a few useful packages

RUN dnf install -y net-tools \
    gcc \
    sudo \
    git \
    rpm-build \
    rpm-devel \
    rpmlint \
    rpmdevtools \
    rpm-sign \
    python3 \
    python3-pip \
    NetworkManager \
    NetworkManager-openvpn \
    sudo \
    vim \
    nano \
    pkg-config \
    openvpn \
    openssl-devel \
    openssl-libs \
    dbus-x11 \
    gnome-keyring \
    libsecret \
    gtk3 \
    polkit

RUN dnf install -y \
    python3-pyxdg \
    python3-dbus \
    python3-keyring \
    python3-distro \
    python3-gobject \
    python3-jinja2 \
    python3-systemd

RUN dnf install -y \
    python3-pytest \
    python3-pytest-cov

RUN dnf install -y \
    python3-requests \
    python3-pyOpenSSL \
    python3-bcrypt \
    python3-gnupg

RUN python3 -m pip install --upgrade sentry-sdk==0.10.2

RUN git clone --single-branch --branch $git_branch $git_repo
RUN cd proton-python-client && pip3 install --no-cache-dir -e .
RUN cd ..

RUN useradd -ms /bin/bash user
RUN usermod -a -G wheel user
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY docker_entry_rpm.sh /usr/local/bin
COPY . /home/user/protonvpn-nm-lib

RUN chown -R user:user /home/user/protonvpn-nm-lib
WORKDIR /home/user/protonvpn-nm-lib

USER user

ENTRYPOINT ["/usr/local/bin/docker_entry_rpm.sh"]
