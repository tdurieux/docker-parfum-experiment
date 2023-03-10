FROM nanocurrency/nano-env:base

RUN apt update -qq && apt-get install --no-install-recommends -yqq git && rm -rf /var/lib/apt/lists/*;

ENV BOOST_ROOT=/tmp/boost

ADD util/build_prep/fetch_boost.sh fetch_boost.sh

RUN COMPILER=gcc ./fetch_boost.sh
ARG REPOSITORY=nanocurrency/nano-node
LABEL org.opencontainers.image.source https://github.com/$REPOSITORY
