FROM mutadev/muta-build-env:v0.3.0

LABEL maintainer="yejiayu.fe@gmail.com"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
    curl -sL https://deb.nodesource.com/setup_12.x | bash -; \
    apt-get install --no-install-recommends -y nodejs; \
    rm -rf /var/lib/apt/lists/*

RUN npm i yarn -g; npm cache clean --force;
