# This dockerfile creates a nix build environment for developing mayastor.
# It is also used in CI/CD pipeline because it comes with all mayastor
# dependencies downloaded and prebuilt. All what is needed is to checkout
# the sources and enter the nix shell.

FROM nixos/nix
ARG NIX_EXPR_DIR=/tmp/nix-expr

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update
RUN nix-env -i bash git nano sudo procps

# Copy all nix files from the repo so that we can use them to install
# mayastor dependencies