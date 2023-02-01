FROM node:buster-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y -q \
    python2 python3 perl git clang lldb lld \
    build-essential software-properties-common \
    libssl-dev libfontconfig-dev \
    ninja-build && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository "deb http://deb.debian.org/debian buster-backports main" && \
    apt-get update && apt-get install --no-install-recommends -t buster-backports -y -q \
    curl && rm -rf /var/lib/apt/lists/*;

ENV SKIA_NINJA_COMMAND="/usr/bin/ninja"
