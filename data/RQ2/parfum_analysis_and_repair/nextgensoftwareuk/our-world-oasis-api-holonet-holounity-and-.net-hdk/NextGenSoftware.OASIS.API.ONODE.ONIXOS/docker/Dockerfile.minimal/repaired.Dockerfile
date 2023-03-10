FROM nixorg/nix:circleci

ARG DOCKER_BRANCH=master

RUN mkdir /holonix

WORKDIR /holonix

# need $USER to be set for CI, cargo, etc.
# it isn't set by default
USER root
ENV USER root

ENV shellfile ./default.nix

# keep this matching nix-shell!
ENV NIXPKGS_URL https://github.com/NixOs/nixpkgs-channels/archive/36aa728f2cd2038923bb6d4a6e1cbdb9c0dcbca7.tar.gz
ENV NIX_PATH nixpkgs=$NIXPKGS_URL

RUN nix-channel --add $NIXPKGS_URL nixpkgs
RUN nix-channel --update

# get latest develop
ADD https://github.com/holochain/holonix/archive/$DOCKER_BRANCH.tar.gz $DOCKER_BRANCH.tar.gz
RUN tar --strip-components=1 -zxvf $DOCKER_BRANCH.tar.gz && rm $DOCKER_BRANCH.tar.gz
RUN rm $DOCKER_BRANCH.tar.gz
