FROM IMAGE_URL_ARCH
ARG git_repo_lib
ENV git_repo_lib=${git_repo_lib:-GIT_REPO_LIB}
ARG git_repo_client
ENV git_repo_client=${git_repo_client:-GIT_REPO_CLIENT}
ARG git_branch
ENV git_branch=${git_branch:-GIT_BRANCH}

ARG pkgname
ENV pkgname=${pkgname:-linux-cli}
RUN pacman -Syu --noconfirm \
    sudo \
    git \
    pacman-contrib \
    base-devel \
    networkmanager \
    networkmanager-openvpn \
    openvpn \
    make \
    python \
    python-pip \
    bash \
    vim \
    nano \
    namcap \
    dbus \
    libnm \
    gnome-keyring \
    libsecret \
    python-pyxdg \
    python-keyring \
    python-distro \
    python-jinja \
    python-gobject \
    python-pytest \
    python-pytest-cov \
    python-requests \
    python-pyopenssl \
    python-bcrypt \
    python-gnupg \
    python-systemd \
    && python3 -m pip install --upgrade sentry-sdk==0.10.2 \
    && useradd -ms /bin/bash user \
    && usermod -a -G wheel user \
    && usermod -a -G network user \
    && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone --single-branch --branch $git_branch $git_repo_client \
    && cd proton-python-client && pip3 install --no-cache-dir -e . \
    && rm -rf .git \
    && cd .. \
    && git clone --single-branch --branch $git_branch $git_repo_lib \
    && cd protonvpn-nm-lib && pip3 install --no-cache-dir -e . \
    && rm -rf .git && cd ..

COPY docker_entry_arch.sh /usr/local/bin
COPY . /home/user/$pkgname

RUN chown -R user:user /home/user/
WORKDIR /home/user/$pkgname

USER user

ENTRYPOINT ["/usr/local/bin/docker_entry_arch.sh"]
