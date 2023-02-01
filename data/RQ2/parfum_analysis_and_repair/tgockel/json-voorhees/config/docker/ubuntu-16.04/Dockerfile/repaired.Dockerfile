FROM ubuntu:16.04
LABEL maintainer="Travis Gockel <travis@gockelhut.com>"

RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
    cmake \
    grep \
    g++ \
    lcov \
    libboost-all-dev \
    ninja-build && rm -rf /var/lib/apt/lists/*;

CMD ["/root/jsonv/config/run-tests"]
