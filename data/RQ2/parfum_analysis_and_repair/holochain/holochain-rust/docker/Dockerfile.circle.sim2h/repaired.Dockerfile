ARG DOCKER_BRANCH=develop
FROM holochain/holochain-rust:latest.${DOCKER_BRANCH}

RUN nix-shell --run hc-sim2h-server-install
RUN nix-shell --run hc-cli-install
RUN nix-shell --run hc-conductor-install
RUN nix-shell --run 'HC_APP_SPEC_BUILD_RUN=1 hc-test-app-spec app_spec sim2h'