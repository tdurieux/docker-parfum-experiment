FROM ubuntu:disco

RUN apt-get update && apt-get -y --no-install-recommends install \
        antlr4 \
        bison \
        build-essential \
        clang-8 \
        cmake \
        curl \
        ed \
        flex \
        git \
        googletest \
        libantlr4-runtime-dev \
        libyajl-dev \
        libyaml-cpp-dev \
        llvm \
        locales \
        moreutils \
        ninja-build \
        perl \
        pkg-config \
        python3-dev \
        ruby-dev \
        valgrind \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Build dependency for libelektra-fuse
RUN pip3 install --no-cache-dir wheel

# Google Test
ENV GTEST_ROOT=/usr/src/googletest

# Update cache for shared libraries
RUN ldconfig

# hyperfine
ARG HYPERFINE_VERSION=1.5.0
RUN cd /tmp \
    && curl -f -o hyperfine.deb \
       -L https://github.com/sharkdp/hyperfine/releases/download/v${HYPERFINE_VERSION}/hyperfine_${HYPERFINE_VERSION}_amd64.deb \
    && dpkg -i hyperfine.deb \
    && rm hyperfine.deb

# Create User:Group
# The id is important as jenkins docker agents use the same id that is running
# on the slaves to execute containers
ARG JENKINS_GROUPID
RUN groupadd \
    -g ${JENKINS_GROUPID} \
    -f \
    jenkins

ARG JENKINS_USERID
RUN useradd \
    --create-home \
    --uid ${JENKINS_USERID} \
    --gid ${JENKINS_GROUPID} \
    --shell "/bin/bash" \
    jenkins

USER ${JENKINS_USERID}

# flamegraph.pl
ARG FLAME_GRAPH_PATH=/home/jenkins/bin
ENV PATH="${FLAME_GRAPH_PATH}:${PATH}"
RUN mkdir -p "${FLAME_GRAPH_PATH}" \
    && curl -f -L "https://raw.githubusercontent.com/brendangregg/FlameGraph/master/flamegraph.pl" -o "${FLAME_GRAPH_PATH}/flamegraph" \
    && chmod a+x "${FLAME_GRAPH_PATH}/flamegraph"
