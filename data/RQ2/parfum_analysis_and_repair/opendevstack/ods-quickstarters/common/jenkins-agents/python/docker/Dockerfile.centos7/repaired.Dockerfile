FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG nexusHost
ARG nexusAuth

# Python 3.8
ARG PYTHON_VERSION=38

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    PATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/local/bin:/opt/rh/rh-python${PYTHON_VERSION}/root/usr/bin:/home/jenkins/.local/bin/:$PATH \
    LD_LIBRARY_PATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/lib64 \
    MANPATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/share/man: \
    PKG_CONFIG_PATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/lib64/pkgconfig \
    XDG_DATA_DIRS=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/share:/usr/local/share:/usr/share

RUN INSTALL_PKGS="rh-python${PYTHON_VERSION} rh-python${PYTHON_VERSION}-python-devel \
        rh-python${PYTHON_VERSION}-python-setuptools rh-python${PYTHON_VERSION}-python-pip \
        openssl-devel zlib-devel sqlite-devel postgresql-devel" && \
    yum install -y yum-utils && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --disable rhel-7-server-htb-rpms && \
    yum makecache && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS @development && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

RUN if [ ! -z ${nexusHost} ] && [ ! -z ${nexusAuth} ]; \
    then pip config set global.index-url https://${nexusAuth}@${nexusHost}/repository/pypi-all/simple \
        && pip config set global.trusted-host ${nexusHost} \
        && pip config set global.extra-index-url https://pypi.org/simple; \
    fi; \
    pip config set global.cert /etc/ssl/certs/ca-bundle.crt && \
    pip install --no-cache-dir --upgrade pip --user && \
    pip install --no-cache-dir virtualenv==20.4.6 setuptools==56.1.0 Cython==0.29.23 pypandoc==1.5

# Enables default user to access $HOME folder
RUN chown -R 1001:0 $HOME && \
    chmod -R a+rw $HOME

USER 1001
