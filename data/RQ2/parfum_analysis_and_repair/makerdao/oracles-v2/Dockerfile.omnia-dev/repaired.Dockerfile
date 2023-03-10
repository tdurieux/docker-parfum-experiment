FROM nixos/nix@sha256:909992c623023c15950f088185326b80012584127fbaef6366980d26a91c73d5

# Install dependencies
RUN apk add --no-cache bash git jq

# Setup Nix cache
RUN nix run -f https://cachix.org/api/v1/install cachix -c cachix use maker \
  && nix run -f https://cachix.org/api/v1/install cachix -c cachix use dapp \
  && nix-collect-garbage -d

WORKDIR /src

CMD [ "bash", "-c", "nix-env -i -f /src/nix/docker.nix --verbose && /nix/var/nix/profiles/default/bin/runner" ]