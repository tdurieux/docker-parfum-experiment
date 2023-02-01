# docker build -t docker:simple -f Dockerfile.simple .
# docker run --rm docker:simple hack/make.sh dynbinary
# docker run --rm --privileged docker:simple hack/dind hack/make.sh test-unit
# docker run --rm --privileged -v /var/lib/docker docker:simple hack/dind hack/make.sh dynbinary test-integration-cli

# This represents the bare minimum required to build and test Docker.

FROM debian:jessie

# compile and runtime deps
# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#build-dependencies
# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies