FROM ubuntu:18.04
# use bash as default shell

SHELL ["/bin/bash", "--login", "-c"]


# set user as root for running commands
USER root

RUN apt update && apt install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;

# install clang
RUN apt update && apt -y --no-install-recommends install clang-10 && rm -rf /var/lib/apt/lists/*;

# install wget for CMake
# RUN apt update && apt -y install wget


#install git for gtest
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt update
RUN add-apt-repository -y ppa:git-core/ppa
RUN apt update
RUN apt install --no-install-recommends -y git libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

ENV INSTALL_DIR=/install
ENV UTBOT_CMAKE_BINARY=cmake

RUN git config --global http.sslVerify "false"

#install gtest

RUN git clone --single-branch -b release-1.10.0 https://github.com/google/googletest.git /gtest
RUN cd /gtest && mkdir build && cd build && \
    $UTBOT_CMAKE_BINARY -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR .. && \
    $UTBOT_CMAKE_BINARY --build . --target install && \
    cd /
