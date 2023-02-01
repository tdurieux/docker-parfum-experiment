FROM buildpack-deps:20.04

ENV PYSTON_VERSION='2.3.4'
ENV UBUNTU_VERSION='20.04'

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends wget; \
    wget https://github.com/pyston/pyston/releases/download/pyston_${PYSTON_VERSION}/pyston_${PYSTON_VERSION}_${UBUNTU_VERSION}_`dpkg --print-architecture`.deb; \
    apt-get install -y ./pyston_*; \
    rm pyston_*; \
    apt-get remove -y wget; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    ln -sf /usr/bin/pyston /usr/bin/python3.8; \
    ln -sf /usr/bin/pyston /usr/bin/python3; \
    ln -sf /usr/bin/pyston /usr/bin/python; \
    ln -sf /usr/bin/pip-pyston /usr/bin/pip

CMD ["python3.8"]
