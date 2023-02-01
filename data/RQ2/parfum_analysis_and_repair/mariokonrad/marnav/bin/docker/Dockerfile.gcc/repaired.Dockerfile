ARG compiler_version=11.3.0
ARG base_image=gcc:${compiler_version}

FROM ${base_image}
LABEL maintainer="Mario Konrad <mario.konrad@gmx.net>"

ARG cmake_version=3.22.0
ARG boost_version=1.78.0

USER root
RUN apt-get update \
 && apt-get install --no-install-recommends -y apt-utils curl git-core ninja-build libqt5serialport5-dev \
 && rm -fr /var/lib/apt/lists/*
RUN mkdir -p /opt

# install cmake
COPY install-cmake.sh /tmp/
RUN /tmp/install-cmake.sh "${cmake_version}"
ENV PATH /opt/local/cmake/bin:$PATH

# install boost
COPY install-boost.sh /tmp/
RUN /tmp/install-boost.sh "${boost_version}" "gcc"
ENV BOOST_ROOT=/opt/local

# add user
RUN useradd --groups users -M --uid 1000 user
USER user
