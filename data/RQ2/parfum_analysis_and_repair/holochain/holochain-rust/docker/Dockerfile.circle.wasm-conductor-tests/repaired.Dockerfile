ARG DOCKER_BRANCH=develop
FROM holochain/holochain-rust:latest.${DOCKER_BRANCH}

RUN nix-shell --run hc-conductor-wasm-test