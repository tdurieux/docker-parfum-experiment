FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils ca-certificates gnupg wget && \
    wget -qO - https://repo.vkpartner.ru/GPG-KEY.pub | apt-key add - && \
    echo "deb https://repo.vkpartner.ru/kphp-focal/ focal main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      git cmake make clang g++ g++-10 gperf netcat \
      python3-minimal python3-dev libpython3-dev python3-jsonschema python3-setuptools python3-pip && \
    pip3 install --no-cache-dir wheel && \
    apt-get install -y --no-install-recommends curl-kphp-vk kphp-timelib libuber-h3-dev libfmt-dev libgtest-dev libgmock-dev libre2-dev libpcre3-dev \
      libzstd-dev libyaml-cpp-dev libnghttp2-dev zlib1g-dev php7.4-dev mysql-server libmysqlclient-dev libnuma-dev composer unzip && \
    pip3 install --no-cache-dir portalocker psutil requests-toolbelt pytest pytest-xdist pytest-mysql zstandard && \
    rm -rf /var/lib/apt/lists/*

ENV ASAN_OPTIONS=detect_leaks=0
ENV UBSAN_OPTIONS=print_stacktrace=1:allow_addr2line=1

RUN useradd -ms /bin/bash kitten
