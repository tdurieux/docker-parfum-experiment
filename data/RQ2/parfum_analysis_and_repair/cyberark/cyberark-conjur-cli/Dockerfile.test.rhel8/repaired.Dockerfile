FROM registry.access.redhat.com/ubi8/ubi:8.3

ENV INSTALL_DIR=/opt/cyberark-conjur-cli

RUN yum --disableplugin=subscription-manager -y \
                                install -y  bash \
                                            binutils \
                                            yum-utils \
                                            gcc gcc-c++ make \
                                            git \
                                            jq \
                                            libffi-devel \
                                            openssl-devel \
                                            python3-devel \
                                            procps \
                                            zlib-devel \
         && yum --disableplugin=subscription-manager clean all && rm -rf /var/cache/yum

# Copy public keys for repo GPG check
RUN curl -f -L https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official > /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS

# Import gpg key
RUN gpg --batch --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS

# Copy below repo file to enable installation of gnome-keyring and dbus-x11
COPY ./test/CentOS-Linux-AppStream.repo \
     /etc/yum.repos.d/

RUN yum --disableplugin=subscription-manager -y \
                                install -y  dbus-x11 \  
                                            gnome-keyring \
         && yum --disableplugin=subscription-manager clean all && rm -rf /var/cache/yum

RUN mkdir -p $INSTALL_DIR
WORKDIR $INSTALL_DIR

# Generate unique machne-id file required by dbus-11
RUN dbus-uuidgen > /var/lib/dbus/machine-id

# Install Python 3.10.1 using pyenv, wheel and required libs
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

COPY ./requirements.txt $INSTALL_DIR/
RUN curl -f -L -s https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && eval "$(pyenv init --path)" \
    && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.10.1 \
    && pyenv global 3.10.1 \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir -r requirements.txt

COPY ./bin/build_integrations_tests_runner ./test/configure_test_executor.sh /
COPY . $INSTALL_DIR

ENTRYPOINT ["./test/configure_test_executor.sh"]
