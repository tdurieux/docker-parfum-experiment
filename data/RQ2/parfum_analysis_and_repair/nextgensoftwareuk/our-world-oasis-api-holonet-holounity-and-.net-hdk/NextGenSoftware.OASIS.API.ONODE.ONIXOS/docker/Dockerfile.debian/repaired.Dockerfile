# keep this in sync with Dockerfile.ubuntu
FROM debian:buster

# @see
# https://github.com/TerrorJack/pixie/blob/master/.circleci/debian.Dockerfile
# https://github.com/NixOS/nix/issues/971#issuecomment-489398535

# linux docker does not ship with much
RUN apt-get update && apt-get install --no-install-recommends -y sudo xz-utils curl && rm -rf /var/lib/apt/lists/*;

# nix does not work under root
# add a docker user that can sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# nix expects the nixbld group
RUN addgroup --system nixbld
RUN adduser docker nixbld

# keep this matching nix-shell!
ENV NIX_PATH nixpkgs=channel:nixos-19.09

# sandbox doesn't play nice with ubuntu (at least in docker)
RUN mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

# use the docker user
USER docker
ENV USER docker
WORKDIR /home/docker

# https://nixos.wiki/wiki/Nix_Installation_Guide#Single-user_install
RUN sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
RUN curl -f -L https://nixos.org/nix/install | sh

# warm nix and avoid warnings about missing channels
# https://github.com/NixOS/nixpkgs/issues/40165
RUN . /home/docker/.nix-profile/etc/profile.d/nix.sh; nix-channel --update; nix-shell https://holochain.love --run echo;
