FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ruby ruby-dev rubygems build-essential rpm \
    && gem install fpm \
    && fpm --version && rm -rf /var/lib/apt/lists/*;

CMD /usr/local/bin/fpm