# A dockerfile which builds a docker image for building a debian package for
# synapse. The distro to build for is passed as a docker build var.
#
# The default entrypoint expects the synapse source to be mounted as a
# (read-only) volume at /synapse/source, and an output directory at /debs.
#
# A pair of environment variables (TARGET_USERID and TARGET_GROUPID) can be
# passed to the docker container; if these are set, the build script will chown
# the build products accordingly, to avoid ending up with things owned by root
# in the host filesystem.

# Get the distro we want to pull from as a dynamic build variable
ARG distro=""

###
### Stage 0: build a dh-virtualenv
###
FROM ${distro} as builder

RUN apt-get update -qq -o Acquire::Languages=none
RUN env DEBIAN_FRONTEND=noninteractive apt-get install \
        -yqq --no-install-recommends \
        build-essential \
        ca-certificates \
        devscripts \
        equivs \
        wget

# fetch and unpack the package
RUN wget -q -O /dh-virtuenv-1.1.tar.gz https://github.com/spotify/dh-virtualenv/archive/1.1.tar.gz
RUN tar xvf /dh-virtuenv-1.1.tar.gz

# install its build deps
RUN cd dh-virtualenv-1.1/ \
    && env DEBIAN_FRONTEND=noninteractive mk-build-deps -ri -t "apt-get -yqq --no-install-recommends"

# build it
RUN cd dh-virtualenv-1.1 && dpkg-buildpackage -us -uc -b

###
### Stage 1
###
FROM ${distro}

# Install the build dependencies
RUN apt-get update -qq -o Acquire::Languages=none \
    && env DEBIAN_FRONTEND=noninteractive apt-get install \
        -yqq --no-install-recommends -o Dpkg::Options::=--force-unsafe-io \
        build-essential \
        debhelper \
        devscripts \
        dh-systemd \
        libsystemd-dev \
        lsb-release \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-venv \
        sqlite3 \
        libpq-dev

COPY --from=builder /dh-virtualenv_1.1-1_all.deb /

# install dhvirtualenv. Update the apt cache again first, in case we got a
# cached cache from docker the first time.
RUN apt-get update -qq -o Acquire::Languages=none \
    && apt-get install -yq /dh-virtualenv_1.1-1_all.deb

WORKDIR /synapse/source
ENTRYPOINT ["bash","/synapse/source/docker/build_debian.sh"]
