# Build Debian package using dh-virtualenv
#
# To create a package for Stretch in `dist/`, call:
#
#   ./build.sh debian:stretch

# Build arguments, as provided by 'build.sh'
ARG DIST_ID="debian"
ARG CODENAME="stretch"
ARG PYVERSION="3"
ARG PKGNAME

# Other build arguments (adapt as needed)
ARG NODEREPO="node_12.x"
ARG DEB_POOL="http://ftp.nl.debian.org/debian/pool/main"

## Start package builder image for the chosen platform
FROM ${DIST_ID}:${CODENAME} AS dpkg-build

# Pass build args into image scope
ARG CODENAME
ARG PYVERSION
ARG PKGNAME
ARG NODEREPO
ARG DEB_POOL

# Install build tools and package build deps including nodejs
RUN ( test "${CODENAME}" = "xenial" \
        && echo "deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa/ubuntu ${CODENAME} main" \
            >/etc/apt/sources.list.d/deadsnakes.list || : ) \
    && env LANG=C apt-get update -qq -o Acquire::Languages=none \
    && env LANG=C DEBIAN_FRONTEND=noninteractive apt-get install \
        -yqq --no-install-recommends -o Dpkg::Options::=--force-unsafe-io \
        "" \
        apt-transport-https \
        apt-utils \
        build-essential \
        curl \
        debhelper \
        devscripts \
        equivs \
        gnupg2 \
        gzip \
        libjs-sphinxdoc \
        libparse-debianchangelog-perl \
        lsb-release \
        python${PYVERSION} \
        python${PYVERSION}-venv \
        python${PYVERSION}-tk \
        python${PYVERSION}-dev \
        python3-pkg-resources \
        python3-setuptools \
        python3-venv \
        sphinx-rtd-theme-common \
        tar \
        "" \
        libcurl4-openssl-dev \
        libffi-dev \
        libfontconfig1 \
        libfreetype6-dev \
        libjpeg-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        libz-dev \
        libzmq3-dev \
    && ( curl -f -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
         | env APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true apt-key add -) \
    && echo "deb https://deb.nodesource.com/${NODEREPO} ${CODENAME} main" \
            >/etc/apt/sources.list.d/nodesource.list \
    && apt-get update -qq -o Acquire::Languages=none \
    && env LANG=C DEBIAN_FRONTEND=noninteractive apt-get install \
        -yqq --no-install-recommends -o Dpkg::Options::=--force-unsafe-io nodejs \
    && apt-get clean && rm -rf "/var/lib/apt/lists"/*

# Uncomment and adapt these ENV instructions to use a local PyPI mirror
# (examples for devpi and JFrog Artifactory)
#ENV PIP_TRUSTED_HOST="devpi.local"
#ENV PIP_INDEX_URL="http://${PIP_TRUSTED_HOST}:3141/root/pypi/+simple/"
#ENV PIP_TRUSTED_HOST="artifactory.local"
#ENV PIP_INDEX_URL="https://${PIP_TRUSTED_HOST}/artifactory/api/pypi/pypi.python.org/simple"

# Install updated Python tooling and a current 'dh-virtualenv'
WORKDIR /dpkg-build
ADD "${DEB_POOL}/d/dh-virtualenv/dh-virtualenv_1.1-1_all.deb" ./
RUN dpkg -i --force-unsafe-io \
         --ignore-depends=python:any \
         --ignore-depends=virtualenv \
         --ignore-depends=sphinx-rtd-theme-common \
         *_all.deb \
    && python${PYVERSION} -m easy_install pip \
    && python${PYVERSION} -m pip install -U setuptools wheel

# Build project and show metadata of built package
COPY ./ ./
RUN hr() { printf '\n   %-74s\n' "[$1]" | tr ' ' = ; } \
    && hr Versions && python${PYVERSION} -m pip --version && dh_virtualenv --version \
    && sed -i -r \
           -e "1s/(UNRELEASED|unstable|jessie|stretch|xenial|bionic)/$(lsb_release -cs)/g" \
           debian/changelog \
    && dpkg-buildpackage -us -uc -b && mkdir -p /dpkg && cp -pl /${PKGNAME}[-_]* /dpkg \
    && hr DPKG-Info && dpkg-deb -I /dpkg/${PKGNAME}_*.deb
