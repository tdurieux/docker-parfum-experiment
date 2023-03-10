FROM obspy/base-images:debian_10_buster_armhf

MAINTAINER Tobias Megies

# Set the env variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_PRIORITY=critical
ENV DEBCONF_NOWARNINGS=yes

# Fix potentially wrong repo address and fetch public key for signed repo
RUN sed 's#deb[ ]\+[^ ]\+ \(.*\)#deb http://archive.raspbian.org/raspbian/ \1#' /etc/apt/sources.list --in-place

# On our Debian stretch Raspbian armhf image, we're currently suffering from this bug:
# https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1577926
# The workaround described here works:
# https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1577926/comments/10
# To me looks like this is no security breach, just internally not using _apt
# user but root for package look ups. Can't see how this could breach security
# of checking the repository/package signatures.
RUN echo '' >> /etc/apt/apt.conf && echo 'APT::Sandbox::User "root";' >> /etc/apt/apt.conf

# make sure public key for Raspbian archive is set up in keyring
# this usually wasn't needed but during building 1.1.1-2 somehow the keyring
# was not properly added to the docker image filesystem it seems see #2530
# gpg and wget are not added by debootstrap by default, so need to explicitly
# specify them as well during building the base image
RUN wget https://archive.raspbian.org/raspbian.public.key -O - | gpg --batch --import -

# install packages to install obspy and build deb packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get -y --no-install-recommends install \
    debhelper \
    devscripts \
    equivs \
    fakeroot \
    gcc \
    git \
    help2man \
    lintian \
    locales \
    lsb-release \
    python \
    python-cryptography \
    python-decorator \
    python-dev \
    python-flake8 \
    python-future \
    python-geographiclib \
    python-jsonschema \
    python-lxml \
    python-m2crypto \
    python-matplotlib \
    python-mock \
    python-mpltoolkits.basemap \
    python-mpltoolkits.basemap-data \
    python-nose \
    python-numpy \
    python-pil \
    python-pip \
    python-pyproj \
    python-pyshp \
    python-requests \
    python-scipy \
    python-setuptools \
    python-sqlalchemy \
    python-tornado \
    python-wheel \
    python3 \
    python3-cryptography \
    python3-decorator \
    python3-dev \
    python3-flake8 \
    python3-future \
    python3-geographiclib \
    python3-jsonschema \
    python3-lxml \
    python3-matplotlib \
    python3-mock \
    python3-mpltoolkits.basemap \
    python3-nose \
    python3-numpy \
    python3-pil \
    python3-pip \
    python3-pyproj \
    python3-pyshp \
    python3-requests \
    python3-scipy \
    python3-setuptools \
    python3-sqlalchemy \
    python3-tornado \
    python3-wheel \
    quilt \
    ttf-bitstream-vera \
    vim \
    && rm -rf /var/lib/apt/lists/*
# install some additional packages via pip
RUN pip install --no-cache-dir https://github.com/Damgaard/PyImgur/archive/9ebd8bed9b3d0ae2797950876f5c1e64a560f7d8.zip; \
    pip3 install --no-cache-dir https://github.com/Damgaard/PyImgur/archive/9ebd8bed9b3d0ae2797950876f5c1e64a560f7d8.zip
# make sure locale we use in tests is present
RUN locale-gen en_US.UTF-8
