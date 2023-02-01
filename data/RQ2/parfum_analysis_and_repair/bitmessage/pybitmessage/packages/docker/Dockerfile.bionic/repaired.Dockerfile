FROM ubuntu:bionic AS base

ENV DEBIAN_FRONTEND noninteractive
ENV TRAVIS_SKIP_APT_UPDATE 1

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update

RUN apt-get install -yq --no-install-suggests --no-install-recommends \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN dpkg --add-architecture i386

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -yq --no-install-suggests --no-install-recommends \

    python-setuptools libssl-dev python-prctl \
    python-dev python-virtualenv python-pip virtualenv \

    python-minimal python-all python openssl libssl-dev \
    dh-apparmor debhelper dh-python python-msgpack python-qt4 git python-stdeb \
    python-all-dev python-crypto python-psutil \
    fakeroot python-pytest python3-wheel \
    libglib2.0-dev \

    pylint python-pycodestyle python3-pycodestyle pycodestyle python-flake8 \
    python3-flake8 flake8 python-pyflakes python3-pyflakes pyflakes pyflakes3 \
    curl \

    python python-pip wget wine-stable winetricks mingw-w64 wine32 wine64 xvfb \

    python3-dev libffi-dev python3-setuptools \
    python3-pip \

    python3.7 python3.7-dev \

    build-essential libcap-dev tor \
    language-pack-en && rm -rf /var/lib/apt/lists/*;


# cleanup
RUN rm -rf /var/lib/apt/lists/*

#####################################################################################################

FROM base AS travis

# travis2bash
RUN wget -O /usr/local/bin/travis2bash.sh https://git.bitmessage.org/Bitmessage/buildbot-scripts/raw/branch/master/travis2bash.sh
RUN chmod +x /usr/local/bin/travis2bash.sh

RUN useradd -m -U builder
RUN echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# copy sources
COPY . /home/builder/src
RUN chown -R builder.builder /home/builder/src

USER builder

WORKDIR /home/builder/src

ENTRYPOINT /usr/local/bin/travis2bash.sh

#####################################################################################################

FROM base AS buildbot

# travis2bash
RUN wget -O /usr/local/bin/travis2bash.sh https://git.bitmessage.org/Bitmessage/buildbot-scripts/raw/branch/master/travis2bash.sh
RUN chmod +x /usr/local/bin/travis2bash.sh

# copy entrypoint
COPY packages/docker/buildbot-entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

RUN useradd -m -U buildbot
RUN echo 'buildbot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER buildbot

ENTRYPOINT /entrypoint.sh "$BUILDMASTER" "$WORKERNAME" "$WORKERPASS"

#################################################################################################

FROM base AS appimage

COPY . /home/builder/src

WORKDIR /home/builder/src

RUN VERSION=$(python setup.py -V) \
   && python setup.py sdist \
   && python setup.py --command-packages=stdeb.command bdist_deb \
   && dpkg-deb -I deb_dist/pybitmessage_${VERSION}-1_amd64.deb

RUN buildscripts/appimage.sh
RUN VERSION=$(python setup.py -V) \
   && out/PyBitmessage-${VERSION}.glibc2.15-x86_64.AppImage --appimage-extract-and-run -t

FROM base AS appandroid

COPY . /home/builder/src

WORKDIR /home/builder/src

RUN chmod +x buildscripts/androiddev.sh

RUN buildscripts/androiddev.sh
