FROM nixos/nix@sha256:909992c623023c15950f088185326b80012584127fbaef6366980d26a91c73d5

# Install dependencies
RUN apk add --no-cache bash git

# Setup Nix cache
RUN nix run -f https://cachix.org/api/v1/install cachix -c cachix use maker \
  && nix run -f https://cachix.org/api/v1/install cachix -c cachix use dapp \
  && nix-collect-garbage -d

# Copy testnet source code inside the container
COPY testchain /src/

# Install Omnia runner and dependencies
RUN nix-env -i -f /src/default.nix --verbose \
  && nix-collect-garbage -d

# Deploy medianizer contract and save their addresses to the /src/contracts.json
RUN median-deployer /src/contracts.json

CMD [ "bash", "-c", "cat /src/contracts.json; testchain-runner" ]