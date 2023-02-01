# This is the resoto base container. It includes CPython and pypy and is used
# as the common base for all the other containers. The main size contributor
# is the resoto-venv-python3 and resoto-venv-pypy3 virtual environments which
# are required for all resoto packages. That's why size wise it made sense to
# use the same base package for all containers.
ARG UI_IMAGE_TAG=latest
FROM ghcr.io/someengineering/resoto-ui:${UI_IMAGE_TAG} as resoto-ui-env
FROM docker.io/arangodb/arangodb:3.9.1-noavx as arangodb-amd64-env
FROM docker.io/programmador/arangodb:3.9.0-devel as arangodb-arm64-env

FROM ubuntu:20.04 as build-env
ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TESTS
ARG SOURCE_COMMIT
ARG PYTHON_VERSION=3.10.4
ARG PYPY_VERSION=7.3.9

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN echo "I am running on ${BUILDPLATFORM}, building for ${TARGETPLATFORM}"
COPY --from=resoto-ui-env /usr/local/resoto/ui /usr/local/resoto/ui
# Install Build dependencies
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install \
        build-essential \
        git \
        curl \
        unzip \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libgdbm-compat-dev \
        libnss3-dev \
        libreadline-dev \
        libsqlite3-dev \
        tk-dev \
        lzma \
        lzma-dev \
        liblzma-dev \
        uuid-dev \
        libbz2-dev \
        rustc \
        shellcheck \
        findutils \
        libtool \
        automake \
        autoconf \
        libffi-dev \
        libssl-dev \
        cargo \
        linux-headers-generic && rm -rf /var/lib/apt/lists/*;


# Download and install PyPy
WORKDIR /build
RUN mkdir -p /build/pypy
RUN if [ ${TARGETPLATFORM} = "linux/amd64" ]; then \
        export PYPY_ARCH=linux64; \
    elif [ ${TARGETPLATFORM} = "linux/arm64" ]; then \
        export PYPY_ARCH=aarch64; \
    else \
        export PYPY_ARCH=linux64; \
    fi; \
    curl -f -L -o /tmp/pypy.tar.bz2 https://downloads.python.org/pypy/pypy3.9-v${PYPY_VERSION}-${PYPY_ARCH}.tar.bz2
RUN tar xjvf /tmp/pypy.tar.bz2 --strip-components=1 -C /build/pypy && rm /tmp/pypy.tar.bz2
RUN mv /build/pypy /usr/local/pypy
RUN /usr/local/pypy/bin/pypy3 -m ensurepip


# Download and install CPython
WORKDIR /build/python
RUN curl -f -L -o /tmp/python.tar.gz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar xzvf /tmp/python.tar.gz --strip-components=1 -C /build/python && rm /tmp/python.tar.gz
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations --prefix /usr/local/python
RUN make -j 12
RUN make install
RUN /usr/local/python/bin/python3 -m ensurepip

WORKDIR /usr/local
RUN /usr/local/python/bin/python3 -m venv resoto-venv-python3
RUN /usr/local/pypy/bin/pypy3 -m venv resoto-venv-pypy3

# Download and install ArangoDB client on x86 builds (there are no official ArangoDB binaries for arm64)
WORKDIR /tmp/arangodb
RUN mkdir -p /tmp/arangodb/amd64 /tmp/arangodb/arm64
COPY --from=arangodb-amd64-env /usr/bin/arangodump /tmp/arangodb/amd64/
COPY --from=arangodb-amd64-env /usr/bin/arangorestore /tmp/arangodb/amd64/
COPY --from=arangodb-arm64-env /usr/bin/arangodump /tmp/arangodb/arm64/
COPY --from=arangodb-arm64-env /usr/bin/arangorestore /tmp/arangodb/arm64/
RUN if [ ${TARGETPLATFORM} = "linux/amd64" ]; then \
        cp /tmp/arangodb/amd64/* /usr/local/bin/; \
    elif [ ${TARGETPLATFORM} = "linux/arm64" ]; then \
        cp /tmp/arangodb/arm64/* /usr/local/bin/; \
    else \
        echo "Building for unknown platform - not copying ArangoDB client binaries"; \
    fi

# Prepare PyPy whl build env
RUN mkdir -p /build-python
RUN mkdir -p /build-pypy

# Download and install Python test tools
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip install -U pip wheel tox flake8
RUN . /usr/local/resoto-venv-pypy3/bin/activate && pypy3 -m pip install -U pip wheel

# Build resotolib
COPY resotolib /usr/src/resotolib
WORKDIR /usr/src/resotolib
RUN if [ "X${TESTS:-false}" = Xtrue ]; then . /usr/local/resoto-venv-python3/bin/activate && tox; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip wheel -w /build-python -f /build-python .
RUN . /usr/local/resoto-venv-pypy3/bin/activate && pypy3 -m pip wheel -w /build-pypy -f /build-pypy .

# Build resotocore
COPY resotocore /usr/src/resotocore
WORKDIR /usr/src/resotocore
#RUN if [ "X${TESTS:-false}" = Xtrue ]; then nohup bash -c "/usr/local/db/bin/arangod --database.directory /tmp --server.endpoint tcp://127.0.0.1:8529 --database.password root &"; sleep 5; tox; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip wheel -w /build-python -f /build-python .
RUN . /usr/local/resoto-venv-pypy3/bin/activate && pypy3 -m pip wheel -w /build-pypy -f /build-pypy .

# Build resotoworker
COPY resotoworker /usr/src/resotoworker
WORKDIR /usr/src/resotoworker
RUN if [ "X${TESTS:-false}" = Xtrue ]; then . /usr/local/resoto-venv-python3/bin/activate && tox; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip wheel -w /build-python -f /build-python .

# Build resotometrics
COPY resotometrics /usr/src/resotometrics
WORKDIR /usr/src/resotometrics
RUN if [ "X${TESTS:-false}" = Xtrue ]; then . /usr/local/resoto-venv-python3/bin/activate && tox; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip wheel -w /build-python -f /build-python .

# Build resotoshell
COPY resotoshell /usr/src/resotoshell
WORKDIR /usr/src/resotoshell
RUN if [ "X${TESTS:-false}" = Xtrue ]; then . /usr/local/resoto-venv-python3/bin/activate && tox; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip wheel -w /build-python -f /build-python .

# Build resoto plugins
COPY plugins /usr/src/plugins
WORKDIR /usr/src
RUN if [ "X${TESTS:-false}" = Xtrue ]; then . /usr/local/resoto-venv-python3/bin/activate && find plugins/ -name tox.ini | while read toxini; do cd $(dirname "$toxini") && tox && cd - || exit 1; done; fi
RUN . /usr/local/resoto-venv-python3/bin/activate && find plugins/ -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 python -m pip wheel -w /build-python -f /build-python

# Workaround until cattrs 22.2.0 is released
RUN rm -f /build-python/cattrs-22.2.0.dev0-py3-none-any.whl /build-pypy/cattrs-22.2.0.dev0-py3-none-any.whl

# Install all wheels
RUN . /usr/local/resoto-venv-python3/bin/activate && python -m pip install -f /build-python /build-python/*.whl
RUN . /usr/local/resoto-venv-pypy3/bin/activate && pypy3 -m pip install -f /build-pypy /build-pypy/*.whl

# Copy image config and startup files
WORKDIR /usr/src/resoto
COPY dockerV2/defaults /usr/local/etc/resoto/defaults
COPY dockerV2/common /usr/local/etc/resoto/common
COPY dockerV2/bootstrap /usr/local/sbin/bootstrap
COPY dockerV2/postflight /usr/local/sbin/postflight
COPY dockerV2/resh-shim /usr/local/bin/resh-shim
COPY dockerV2/resh-wait /usr/local/bin/resh-wait
COPY dockerV2/resotocore-shim /usr/local/bin/resotocore-shim
COPY dockerV2/resotoworker-shim /usr/local/bin/resotoworker-shim
COPY dockerV2/resotometrics-shim /usr/local/bin/resotometrics-shim
RUN chmod 755 \
    /usr/local/sbin/bootstrap \
    /usr/local/sbin/postflight \
    /usr/local/bin/resh-shim \
    /usr/local/bin/resotocore-shim \
    /usr/local/bin/resotoworker-shim \
    /usr/local/bin/resotometrics-shim
RUN if [ "${TESTS:-false}" = true ]; then \
        shellcheck -a -x -s bash -e SC2034 \
            /usr/local/sbin/bootstrap \
        ; \
    fi
COPY dockerV2/dnsmasq.conf /usr/local/etc/dnsmasq.conf
RUN echo "${SOURCE_COMMIT:-unknown}" > /usr/local/etc/git-commit.HEAD


# Setup main image
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="en_US.UTF-8"
ENV TERM="xterm-256color"
ENV EDITOR="nano"
COPY --from=build-env /usr/local /usr/local
ENV PATH=/usr/local/python/bin:/usr/local/pypy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /
RUN groupadd -g "${PGID:-0}" -o resoto \
    && useradd -g "${PGID:-0}" -u "${PUID:-0}" -o --create-home resoto \
    && apt-get update \
    && apt-get -y --no-install-recommends install apt-utils \
    && apt-get -y dist-upgrade \
    && apt-get -y --no-install-recommends install \
        dumb-init \
        iproute2 \
        dnsmasq \
        libffi7 \
        openssl \
        procps \
        dateutils \
        curl \
        jq \
        cron \
        ca-certificates \
        openssh-client \
        locales \
        unzip \
        nano \
        nvi \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && mkdir -p /var/run/resoto \
    && rm -f /bin/sh \
    && ln -s /bin/bash /bin/sh \
    && locale-gen \
    && /usr/local/sbin/postflight \
    && ln -s /usr/local/bin/resh-shim /usr/bin/resh \
    && ln -s /usr/local/bin/resotocore-shim /usr/bin/resotocore \
    && ln -s /usr/local/bin/resotoworker-shim /usr/bin/resotoworker \
    && ln -s /usr/local/bin/resotometrics-shim /usr/bin/resotometrics \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/bin/dumb-init", "--", "/usr/local/sbin/bootstrap"]
CMD ["/bin/bash"]
