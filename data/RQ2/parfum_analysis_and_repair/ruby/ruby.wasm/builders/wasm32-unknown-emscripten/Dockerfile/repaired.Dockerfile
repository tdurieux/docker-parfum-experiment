FROM emscripten/emsdk:2.0.13

RUN set -eux; \
  apt-get update; \
  apt-get install --no-install-recommends ruby bison make autoconf git curl build-essential libyaml-dev zlib1g-dev -y; \
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash -; \
  apt-get install --no-install-recommends nodejs -y; \
  apt-get clean; \
  rm -r /var/lib/apt/lists/*
