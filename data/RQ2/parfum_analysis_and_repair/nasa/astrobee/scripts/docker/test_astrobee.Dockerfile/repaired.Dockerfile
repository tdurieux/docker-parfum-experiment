# This will test an Astrobee bionic docker container.
# You must set the docker context to be the repository root directory

ARG UBUNTU_VERSION=16.04
ARG REMOTE=astrobee
FROM ${REMOTE}/astrobee:latest-ubuntu${UBUNTU_VERSION}

# Run tests. See also ../run_tests.sh for explanation.