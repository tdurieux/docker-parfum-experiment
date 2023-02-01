FROM ubuntu:latest

ENV TZ=Europe/London

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential libgtest-dev cmake gdb binutils clang-format && \
    cd /usr/src/gtest && \
    cmake CMakeLists.txt && \
    make && \
    cp lib/*.a /usr/lib && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ENTRYPOINT bash
