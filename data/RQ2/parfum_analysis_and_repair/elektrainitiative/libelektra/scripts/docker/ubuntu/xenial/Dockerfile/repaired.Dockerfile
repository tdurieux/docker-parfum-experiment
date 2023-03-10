FROM ubuntu:xenial

RUN apt-get update && apt-get -y --no-install-recommends install \
        locales \
        curl \
        build-essential \
        autotools-dev \
        automake \
        cmake \
        pkg-config \
        ruby-dev \
        python-dev \
        python3-dev \
        libpython3-dev \
        liblua5.3-dev \
        tclcl-dev \
        libaugeas-dev \
        libyajl-dev \
        git \
        libgit2-dev \
        libssl-dev \
        libdbus-1-dev \
        libpcre3-dev \
        libpcre++-dev \
        libxerces-c-dev \
        valgrind \
        checkinstall \
        swig \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Build dependency for libelektra-fuse
RUN pip3 install --no-cache-dir wheel

# Google Test
ENV GTEST_ROOT=/opt/gtest
ARG GTEST_VER=release-1.11.0
RUN mkdir -p ${GTEST_ROOT} \
    && cd /tmp \
    && curl -f -o gtest.tar.gz \
      -L https://github.com/google/googletest/archive/${GTEST_VER}.tar.gz \
    && tar -zxvf gtest.tar.gz --strip-components=1 -C ${GTEST_ROOT} \
    && rm gtest.tar.gz

# Create User:Group
# The id is important as jenkins docker agents use the same id that is running
# on the slaves to execute containers
ARG JENKINS_GROUPID
RUN groupadd \
    -g ${JENKINS_GROUPID} \
    jenkins

ARG JENKINS_USERID
RUN useradd \
    --create-home \
    --uid ${JENKINS_USERID} \
    --gid ${JENKINS_GROUPID} \
    --shell "/bin/bash" \
    jenkins

USER ${JENKINS_USERID}
