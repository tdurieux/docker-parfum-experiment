# `Dockerfile` is generated from `Dockerfile.tmpl` via `docker.sh`
#
# To make build changes and have it reflect via the `Dockerfile`, you
# would make any build changes to `Dockerfile.tmpl`. `docker.sh build`
# takes this, adds the version from `package.json` and pulls a package
# from npm to do the the actual versioned build

# base image
FROM ubuntu:18.04

# Run package updates
RUN apt-get update && \
  apt-get install --no-install-recommends -y curl gcc g++ gnupg make python git && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# env variable works around gyp install (secp256k1) with root permissions
RUN NPM_CONFIG_USER=root npm install -g @polkadot/api-cli@VERSION @polkadot/json-serve@VERSION @polkadot/metadata-cmp@VERSION @polkadot/monitor-rpc@VERSION @polkadot/signer-cli@VERSION @polkadot/vanitygen@VERSION && npm cache clean --force;

# copy the cli wrapper to this container
COPY cli.sh .

# run the cli wrapper with options as passed
ENTRYPOINT ["./cli.sh"]
