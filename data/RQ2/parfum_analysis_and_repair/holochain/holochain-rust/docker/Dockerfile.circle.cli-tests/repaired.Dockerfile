ARG DOCKER_BRANCH=develop
FROM holochain/holochain-rust:latest.${DOCKER_BRANCH}

# warm unit tests for hc
RUN nix-shell --run 'cargo test -p hc --target-dir "$CARGO_TARGET_DIR"/cli-test'

# warm the things that the cli tests will use without running all the tests
# actually running all the tests seems to be flakey/hang inside a docker build
ENV app_name=my_first_app
ENV zome_name=my_zome
RUN nix-shell --run hc-cli-install
RUN nix-shell --run 'hc init "$TMP/$app_name" \
 && cd "$TMP/$app_name" \
 && hc generate "zomes/$zome_name" \
 && export CARGO_TARGET_DIR="$CARGO_TARGET_DIR/cli/hc-test" \
 && hc package \
 && cd test \
 && npm install'