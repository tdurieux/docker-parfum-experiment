## NOTE: This image uses goreleaser to build image
# if building manually please run go build ./cmd/operator-builder first and then build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container