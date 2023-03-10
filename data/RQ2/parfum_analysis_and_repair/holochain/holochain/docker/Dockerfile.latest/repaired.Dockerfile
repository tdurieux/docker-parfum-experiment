FROM nixos/nix:latest

WORKDIR /holochain/build
ENV NIX_ENV_PREFIX /holochain/build
ENV NIXPKGS_ALLOW_UNFREE 1

ARG DOCKER_BRANCH=develop
ARG CACHIX_NAME=holochain-ci
ARG NIX_CONFIG="extra-experimental-features = nix-command"

ENV CACHIX_NAME=$CACHIX_NAME
ENV NIX_CONFIG=$NIX_CONFIG

ADD https://github.com/holochain/holochain/archive/$DOCKER_BRANCH.tar.gz /holochain/build/$DOCKER_BRANCH.tar.gz
RUN tar --strip-components=1 -zxvf $DOCKER_BRANCH.tar.gz && rm $DOCKER_BRANCH.tar.gz

# warm things
RUN `nix-build . --no-link -A pkgs.ci.ciSetupNixConf`/bin/hc-ci-setup-nix-conf.sh
RUN nix-shell --run echo
