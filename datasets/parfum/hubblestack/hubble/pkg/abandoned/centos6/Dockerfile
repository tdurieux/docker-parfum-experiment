# This Dockerfile aims to make building Hubble v4 packages easier.
# Starting with version 4 building osquery is removed from individual Dockerfiles to its own.
# osquery needs to be built once. Resulting tar file can be used in hubblev4 Dockerfiles.
# Before building hubble, build osquery using a Dockerfile in pkg/osquery/ directory.
# To build this image: 1. copy previously built osquery_4hubble.tar to directory with this Dockerfile
#                      2. docker build -t <image_name> --build-arg HUBBLE_CHECKOUT=<tag or commit> --build-arg HUBBLE_VERSION=<Hubble Version> .
# The resulting image is ready to build and run pyinstaller on container start that should 
# create hubble<version>-centos6.tar.gz in the /data directory inside the container.
# Mount /data volume into a directory on the host to access the package.
# To run the container:  docker run -it --rm -v `pwd`:/data <image_name>

FROM centos:6

RUN yum makecache fast && yum -y update

#paths that hubble or hubble parts need in the package
RUN mkdir -p /etc/hubble/hubble.d /opt/hubble /opt/osquery /var/log/hubble_osquery/backuplogs

#install packages that should be needed for ligbit2 compilation and successful pyinstaller run
RUN yum -y install git \
    libffi-devel openssl-devel libxml2-devel libxslt-devel libffi \
    libssh2-devel autoconf automake libtool libjpeg-devel zlib-devel \
    make cmake gcc wget openssl \
    && yum clean all \
    && rm -rf /var/cache/yum
    
#libcurl install start
#install libcurl to avoid depending on host version
#requires autoconf libtool libssh2-devel zlib-devel autoconf
ENV LIBCURL_SRC_URL=https://github.com/curl/curl.git
ENV LIBCURL_SRC_VERSION=curl-7_64_1
ENV LIBCURL_TEMP=/tmp/libcurl
ENV PATH=/opt/hubble/bin/:/opt/hubble/include:/opt/hubble/lib:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p "$LIBCURL_TEMP" \
 && cd "$LIBCURL_TEMP" \
 && git clone "$LIBCURL_SRC_URL" \
 && cd curl \
 && git checkout "$LIBCURL_SRC_VERSION" \
 && ./buildconf \
 && ./configure --prefix=/opt/hubble --disable-ldap --without-nss --disable-manual --disable-gopher --disable-smtp --disable-smb --disable-imap --disable-pop3 --disable-tftp --disable-telnet --disable-dict --disable-ldaps --disable-ldap --disable-rtsp --with-libssh2 \
 && make \
 && make install \
 && rm -rf "$LIBCURL_TEMP"

#git install start
#install git so that git package won't be a package dependency
#requires make git libcurl-devel autoconf zlib-devel gcc
ENV GIT_SRC_URL=https://github.com/git/git.git
ENV GIT_SRC_VERSION=v2.21.0
ENV GITTEMP=/tmp/gittemp
RUN mkdir -p "$GITTEMP" \
 && cd "$GITTEMP" \
 && git clone "$GIT_SRC_URL" \
 && cd git \
 && git checkout "$GIT_SRC_VERSION" \
 && make configure \
 && ./configure --prefix=/opt/hubble --with-tcltk=no --with-expat=no --with-python=no  --with-curl=/opt/hubble \
 && echo "NO_TCLTK=YesPlease" >> config.mak.autogen \
 && echo "NO_PERL=YesPlease" >> config.mak.autogen \
 && sed -i '0,/^NO_GETTEXT/s/^NO_GETTEXT.*/NO_GETTEXT=YesPlease/' config.mak.autogen \
 && make \
 && make install \
 && rm -rf "$GITTEMP"

#clean up of /opt/hubble
RUN rm /opt/hubble/bin/curl* \
 && rm -rf /opt/hubble/include /opt/hubble/share

#libgit2 install start
#must precede pyinstaller requirements
ENV LIBGIT2_SRC_URL=https://github.com/libgit2/libgit2/archive/v0.26.5.tar.gz
#it turns out github provided release files can change. so even though the code hopefully hasn't changed, the hash has.
ENV LIBGIT2_SRC_SHA256=52e28a5166564bc4365a2e4112f5e5c6e334708dbf13596241b2fd34efc1b0a9
ENV LIBGIT2_SRC_VERSION=0.26.5
ENV LIBGIT2TEMP=/tmp/libgit2temp
RUN mkdir -p "$LIBGIT2TEMP" \
 && cd "$LIBGIT2TEMP" \
 && wget -q "$LIBGIT2_SRC_URL" -O libgit2.tar.gz \
 && echo "$LIBGIT2_SRC_SHA256  libgit2.tar.gz" | sha256sum -c - \
 && tar xzf libgit2.tar.gz \
 && cd libgit2-"$LIBGIT2_SRC_VERSION"/ \
 && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/ \
 && make \
 && make install \
 && rm -rf "$LIBGIT2TEMP"

#fpm package making requirements start
RUN yum install -y centos-release-scl scl-utils \
 && yum clean all \
 && rm -rf /var/cache/yum
RUN yum install -y rpmbuild rpm-build gcc make rh-ruby23 rh-ruby23-ruby-devel \
 && yum clean all \
 && rm -rf /var/cache/yum
RUN scl enable rh-ruby23 "gem install --no-ri --no-rdoc fpm"

# things we may need to build a python
RUN yum install -y bzip2-devel sqlite-devel \
 && yum clean all \
 && rm -rf /var/cache/yum

# use pyenv
ARG PYENV_VERSION=3.7.9
ENV PYENV_INSTALLER_URL=https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer
ENV PYENV_ROOT=/opt/hubble/pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH
ENV PYTHON_CONFIGURE_OPTS="--enable-shared"
RUN umask 022 \
 && curl -s -S -L "$PYENV_INSTALLER_URL" -o /usr/bin/pyenv-installer \
 && chmod 0755 /usr/bin/pyenv-installer \
 && /usr/bin/pyenv-installer \
 && eval "$(pyenv init -)" \
 && pyenv install $PYENV_VERSION \
 && pyenv global $PYENV_VERSION

RUN eval "$(pyenv init -)" \
 && pip -v install --upgrade pip

#extract osquery files. optionally pass in osquery filename with OSQUERY_TAR_FILENAME build-arg
ARG OSQUERY_TAR_FILENAME=osquery_4hubble.tar
ADD ${OSQUERY_TAR_FILENAME} /opt/osquery/
RUN /opt/osquery/osqueryi --version

#pyinstaller start
#commands specified for ENTRYPOINT and CMD are executed when the container is run, not when the image is built
#use the following variables to choose the version of hubble
ARG HUBBLE_CHECKOUT=v4.0.0
ARG HUBBLE_VERSION=4.5.0
ENV HUBBLE_ITERATION=1
ENV HUBBLE_URL=https://github.com/hubblestack/hubble
ENV HUBBLE_DESCRIPTION="Hubble is a modular, open-source, security & compliance auditing framework which is built in python, using SaltStack as a library."
ENV HUBBLE_SUMMARY="Profile based on-demand auditing and monitoring tool"
ARG HUBBLE_GIT_URL=https://github.com/hubblestack/hubble.git
ENV HUBBLE_SRC_PATH=/hubble_src
ENV _HOOK_DIR="./pkg/"
ENV _BINARY_LOG_LEVEL="INFO"
ENV _INCLUDE_PATH=""
ENV LD_LIBRARY_PATH=/opt/hubble/lib:/lib:/lib64:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64

RUN mkdir /data
VOLUME /data

WORKDIR /hubble_build

COPY entrypoint.sh /entrypoint.sh
ENV HUBBLE_CHECKOUT_ENV=$HUBBLE_CHECKOUT
ENV HUBBLE_VERSION_ENV=$HUBBLE_VERSION
ENV HUBBLE_GIT_URL_ENV=$HUBBLE_GIT_URL
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
