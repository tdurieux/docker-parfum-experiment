# ------------------------------------------------------------------------------
# COVERAGE STAGE
# ------------------------------------------------------------------------------
FROM ragnaroek/kcov:v33

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -yq \
    bc \
    curl \
    dnsutils \
    git \
    shellcheck \
    sudo \
    tree \
  && curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
  && sudo apt-get install --no-install-recommends --no-install-suggests -yq \
    nodejs \
    build-essential \
  && rm -rf /var/lib/apt/lists/* \
  && npm i -g --unsafe \
    semver \
  && npm cache clean --force -g -f \
  && cd /usr/src \
  && git clone https://github.com/bats-core/bats-core.git \
  && cd bats-core \
  && ./install.sh /usr/local \
  && mkdir -p /usr/src/app \
  && mkdir -p /usr/src/app/coverage \
  && ls -al /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN ls -al \
  && kcov --include-path=/usr/src/app/scripts,/usr/src/app/tests /usr/src/app/coverage bats -r /usr/src/app/tests \
  # && tar -czvf coverage.$(date +%Y%m%d-%H%M%S).tgz coverage \
  && tar -czvf coverage.tgz coverage \
  && ls -al \
  && echo "KCOV complete." && rm coverage.tgz

# CMD "bash <(curl -s https://codecov.io/bash)"
