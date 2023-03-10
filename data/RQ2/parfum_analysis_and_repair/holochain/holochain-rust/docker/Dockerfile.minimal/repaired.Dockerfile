FROM nixorg/nix:circleci

ARG DOCKER_BRANCH=develop

RUN mkdir /holochain

WORKDIR /holochain
ENV CARGO_HOME /holochain/.cargo
ENV PATH "${CARGO_HOME}/bin:${PATH}"

# need $USER to be set for CI, cargo, etc.
# it isn't set by default
USER root
ENV USER root

ENV shellfile ./docker/minimal.default.nix

# keep this matching nix-shell!
ENV NIXPKGS_URL https://github.com/NixOs/nixpkgs-channels/archive/8634c3b619909db7fc747faf8c03592986626e21.tar.gz
ENV NIX_PATH nixpkgs=$NIXPKGS_URL
ENV HC_TARGET_PREFIX /tmp/holochain

RUN nix-channel --add $NIXPKGS_URL nixpkgs
RUN nix-channel --update

# get latest develop
ADD https://github.com/holochain/holochain-rust/archive/$DOCKER_BRANCH.tar.gz $DOCKER_BRANCH.tar.gz
RUN tar --strip-components=1 -zxvf $DOCKER_BRANCH.tar.gz && rm $DOCKER_BRANCH.tar.gz
RUN rm $DOCKER_BRANCH.tar.gz
