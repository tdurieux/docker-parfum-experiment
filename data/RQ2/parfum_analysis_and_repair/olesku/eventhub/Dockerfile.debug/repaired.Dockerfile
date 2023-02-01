FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -qq -y --no-install-recommends install gcc g++ cmake git openssl libssl-dev libhiredis-dev gdb bash vim psmisc procps htop curl sudo \
    libspdlog-dev libfmt-dev ninja-build && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/redis-plus-plus && cd /usr/src/redis-plus-plus && \
    git clone https://github.com/sewenew/redis-plus-plus.git . && \
    git checkout tags/1.1.1 && \
    mkdir compile && cd compile && cmake -GNinja -DCMAKE_BUILD_TYPE=Debug .. && \
    ninja && ninja install && rm -rf /usr/src/redis-plus-plus

RUN mkdir -p /usr/src/eventhub && rm -rf /usr/src/eventhub
WORKDIR /usr/src/eventhub

COPY . .

RUN mkdir -p build && cd build && \
    sed -i 's/clang++/g++/' ../CMakeLists.txt && \
    sed -i 's/clang/gcc/' ../CMakeLists.txt && \
    cmake -GNinja -DSKIP_TESTS=1 -DCMAKE_BUILD_TYPE=Debug .. && \
    ninja -j0 && \
    cp -a eventhub /usr/bin/eventhub

WORKDIR /tmp

RUN addgroup --system eventhub && \
    adduser --system --ingroup eventhub --no-create-home --home /tmp --shell /bin/false eventhub && \
    echo "eventhub ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /tmp/coredumps; chown -R eventhub:eventhub /tmp/coredumps

USER eventhub

ENTRYPOINT [ "/usr/bin/eventhub" ]