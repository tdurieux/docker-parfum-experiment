# Pbench CI image Template
#
# We maintain this image with all the necessary user-space setup required to
# run the various unit tests and functional tests in CI environment.
#
# The image is published to https://quay.io/pbench/pbench-ci-fedora and "tagged"
# using the branch name in which it was built: `main`, `b0.70`, `b0.71`, etc.
#
# You can use this image to run our CI environment from a command line, e.g.:
#
#  $ podman run -it --rm pbench-ci-fedora:<branch name> /bin/bash
#
# which will allow you to run a Fedora-based pbench CI environment.
#
# Also note that the pbench sources are not built into the image.  Instead
# they should be mounted as a local directory, e.g., /src/pbench, using an
# external directory [1] containing the source tree.
#
# Build the image using (see jenkins/Makefile):
#
#   $ buildah bud -f ci.fedora.Dockerfile -t pbench-ci-fedora:<branch name>
#
# Run tests using (see jenkins/run and jenkins/Pipeline.gy):
#
#   $ podman run -it --userns=keep-id --volume $(pwd):/src/pbench:z \
#     --rm localhost/pbench-ci-fedora:<branch name> tox
#
# [1] See https://www.redhat.com/sysadmin/user-flag-rootless-containers