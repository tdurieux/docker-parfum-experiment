FROM i386/debian:stretch

RUN apt-get update
RUN apt-get install --no-install-recommends --quiet --yes \
    build-essential \
    curl \
    pkg-config \
    clang \
    python \
    libsecret-1-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENV CC clang
ENV CXX clang++
ENV npm_config_clang 1
