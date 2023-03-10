ARG DOCKER_BRANCH=develop
FROM holochain/holochain-rust:latest.${DOCKER_BRANCH}

RUN nix-shell --run hc-test-fmt
RUN nix-shell --run hn-rust-clippy