# Test how ARG and ENV variables flow around. This does not address syntax
# quirks; for that see test 'Dockerfile: syntax quirks' in
# build/50_dockerfile.bats. Results are checked in both test 'Dockerfile: ARG
# and ENV values' in build/50_dockerfile.bats and multiple tests in
# run/ch-run_misc.bats. The latter is why this is a separate Dockerfile
# instead of embedded in a .bats file.

# ch-test-scope: standard