FROM nixos/nix

ENV BOOST_INCLUDEDIR=/nix/store/ximwdp6qj23md5dc652r9pnddhi676c7-boost-1.71.0-dev/include/

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
    && nix-channel --update \
    && nix-env --set-flag priority 1 nix \
    && nix-env -iA nixpkgs.gnumake nixpkgs.cmake nixpkgs.boost171