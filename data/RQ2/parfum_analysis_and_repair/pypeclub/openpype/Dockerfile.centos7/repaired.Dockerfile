# Build Pype docker image
FROM centos:7 AS builder
ARG OPENPYPE_PYTHON_VERSION=3.7.12

LABEL org.opencontainers.image.name="pypeclub/openpype"
LABEL org.opencontainers.image.title="OpenPype Docker Image"
LABEL org.opencontainers.image.url="https://openpype.io/"
LABEL org.opencontainers.image.source="https://github.com/pypeclub/pype"
LABEL org.opencontainers.image.documentation="https://openpype.io/docs/system_introduction"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.version=$VERSION


USER root

# update base
RUN yum -y install deltarpm \
    && yum -y update \
    && yum clean all && rm -rf /var/cache/yum

# add tools we need
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install centos-release-scl \
    && yum -y install \
        bash \
        which \
        git \
        make \
        devtoolset-7 \
        cmake \
        curl \
        wget \
        gcc \
        zlib-devel \
        bzip2 \
        bzip2-devel \
        readline-devel \
        sqlite sqlite-devel \
        openssl-devel \
        openssl-libs \
        tk-devel libffi-devel \
        patchelf \
        automake \
        autoconf \
        patch \
        ncurses \
	    ncurses-devel \
        qt5-qtbase-devel \
        xcb-util-wm \
        xcb-util-renderutil \
    && yum clean all && rm -rf /var/cache/yum

# we need to build our own patchelf
WORKDIR /temp-patchelf
RUN git clone https://github.com/NixOS/patchelf.git . \
    && source scl_source enable devtoolset-7 \
    && ./bootstrap.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install

RUN mkdir /opt/openpype
# RUN useradd -m pype
# RUN chown pype /opt/openpype
# USER pype

RUN curl -f https://pyenv.run | bash
# ENV PYTHON_CONFIGURE_OPTS --enable-shared

RUN echo 'export PATH="$HOME/.pyenv/bin:$PATH"'>> $HOME/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc
RUN source $HOME/.bashrc && pyenv install ${OPENPYPE_PYTHON_VERSION}

COPY . /opt/openpype/
RUN rm -rf /openpype/.poetry || echo "No Poetry installed yet."
# USER root
# RUN chown -R pype /opt/openpype
RUN chmod +x /opt/openpype/tools/create_env.sh && chmod +x /opt/openpype/tools/build.sh

# USER pype

WORKDIR /opt/openpype

RUN cd /opt/openpype \
    && source $HOME/.bashrc \
    && pyenv local ${OPENPYPE_PYTHON_VERSION}

RUN source $HOME/.bashrc \
    && ./tools/create_env.sh

RUN source $HOME/.bashrc \
    && ./tools/fetch_thirdparty_libs.sh

RUN source $HOME/.bashrc \
    && bash ./tools/build.sh

RUN cp /usr/lib64/libffi* ./build/exe.linux-x86_64-3.7/lib \
    && cp /usr/lib64/libssl* ./build/exe.linux-x86_64-3.7/lib \
    && cp /usr/lib64/libcrypto* ./build/exe.linux-x86_64-3.7/lib \
    && cp /root/.pyenv/versions/${OPENPYPE_PYTHON_VERSION}/lib/libpython* ./build/exe.linux-x86_64-3.7/lib \
    && cp /usr/lib64/libxcb* ./build/exe.linux-x86_64-3.7/vendor/python/PySide2/Qt/lib

RUN cd /opt/openpype \
    rm -rf ./vendor/bin
