# Dockerfile.test.rhel
#
# Dockerfile for running tests on RHEL 7. Python3.10.1 on RHEL 7
# Python3.10.1 is installed using pyenv.
# The Centos repo files enables access to RPMs required by pip and PyInstaller
# that are not available on the RHEL7 built-in repos (e.g devtools7).

# Base image is RHEL7
FROM registry.access.redhat.com/ubi7/ubi

# Set the install dir env param
ENV INSTALL_DIR=/opt/cyberark-conjur-cli

# Copy below repo files to yum repo dir to make rpms available
COPY ./test/CentOS-SCLo-scl-rh.repo \
     ./test/CentOS-7-Linux-AppStream.repo \
     /etc/yum.repos.d/

# Copy public keys for repo GPG check
RUN curl -f https://raw.githubusercontent.com/sclorg/centos-release-scl/master/centos-release-scl/RPM-GPG-KEY-CentOS-SIG-SCLo \
  > /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo \
  && curl -f -L https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7 > /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
  # Import public keys for repo GPG check
  && gpg --batch --import \
            /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
            /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo

# Enable yum repos
RUN yum-config-manager --enable \
                         ubi-server-rhscl-7-rpms \
                         ubi-7-server-optional-rpms

RUN yum update -y \
    && yum --disableplugin=subscription-manager \
    install -y  bash \
      wget \
      binutils \
      yum-utils \
      gcc gcc-c++ make \
      curl \
      jq \
      libffi-devel \
      gnome-keyring \
      procps \
      zlib-devel \
      bzip2 \
      wget \
      bzip2-devel \
      dbus-x11 \
      git \
      rh-python38-python-devel \
      centos-release-scl \
      devtoolset-7 \
      && yum --disableplugin=subscription-manager clean all && rm -rf /var/cache/yum

# Download, compile and install openssl 1.1.1k since rhel 7 doesn't have an official package for it
RUN wget https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz \
    && tar -xzf openssl-1.1.1k.tar.gz \
    && cd openssl-1.1.1k \
    && ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic \
    && make \
    && make install && rm openssl-1.1.1k.tar.gz
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

# Generate unique machne-id file required by dbus-11
RUN dbus-uuidgen > /var/lib/dbus/machine-id

RUN mkdir -p $INSTALL_DIR
WORKDIR $INSTALL_DIR

# Copy project's requirements file
COPY ./requirements.txt $INSTALL_DIR/

# Install Python 3.10.1 using pyenv, wheel and required libs
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

RUN curl -f -L -s https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && eval "$(pyenv init --path)" \
    && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.10.1 \
    && pyenv global 3.10.1 \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy script files
COPY ./bin/build_integrations_tests_runner ./test/configure_test_executor.sh /
COPY . $INSTALL_DIR

# Required by PyInstaller
RUN scl enable devtoolset-7 bash
RUN ldconfig /usr/local/lib

ENTRYPOINT ["./test/configure_test_executor.sh"]
