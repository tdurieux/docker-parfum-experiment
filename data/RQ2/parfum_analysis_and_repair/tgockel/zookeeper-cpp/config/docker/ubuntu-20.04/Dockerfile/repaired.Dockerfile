FROM ubuntu:20.04
LABEL maintainer="Travis Gockel <travis@gockelhut.com>"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install --yes \
    cmake \
    g++ \
    grep \
    googletest \
    ivy \
    lcov \
    libgtest-dev \
    libzookeeper-mt-dev \
    ninja-build && rm -rf /var/lib/apt/lists/*;

CMD ["/root/zookeeper-cpp/config/run-tests"]
