FROM holochain/holonix:latest

WORKDIR /holochain-rust/build
ENV NIX_ENV_PREFIX /holochain-rust/build

ARG DOCKER_BRANCH=develop

ADD https://github.com/holochain/holochain-rust/archive/$DOCKER_BRANCH.tar.gz /holochain-rust/build/$DOCKER_BRANCH.tar.gz
RUN tar --strip-components=1 -zxvf $DOCKER_BRANCH.tar.gz && rm $DOCKER_BRANCH.tar.gz

# warm things
RUN nix-shell --run echo
