# Pbench development image Template
#
# We maintain this image with all the necessary user-space setup required to
# run the various unit tests and functional tests in a common development
# environment.  However, in certain instances, the tests require specific
# versions of software packages (Black and Flake8 being notable examples), and
# these cannot always be satisfied by the RPMs available from the
# distribution.  In these cases, we expect the packages to be installed at
# run-time.  Nevertheless, in order to avoid run-time installations where
# possible, we install indirect dependencies of the run-time installations
# below, as well.
#
# The image is published to https://quay.io/pbench/pbench-devel-<distro> (see
# jenkins/Makefile for the <distro> options) and "tagged" using the branch name
# in which it was built (e.g. `main`, `b0.70`, `b0.71`, etc.).
#
# NOTE WELL: The Fedora based image has no entry point, but the UBI based
# image inherits its entry point from the UBI base image -- /sbin/init --
# which allows systemctl-enabled daemons to run automatically.
#
# WARNING: Do not publish images layered on top of UBI images.
#
# You can use this image to run our development environment from a command
# line, e.g.:
#
#  $ podman run -it --rm pbench-devel-<distro>:<branch name> /bin/bash
#
# which will allow you to run a Fedora- or UBI-based pbench development
# environment. Or you can use this image as a base image, and build another
# image on top of it to run your own end-points.
#
# Also note that the pbench sources are not built into the image.  Instead
# they should be mounted as a local directory, e.g., /src/pbench, using an
# external directory [1] containing the source tree.
#
# Build the image using (see jenkins/Makefile):
#
#   $ buildah bud -f development.Dockerfile -t pbench-devel-<distro>:<branch name>
#
# Run tests using (see jenkins/run and jenkins/Pipeline.gy):
#
#   $ podman run -it --userns=keep-id --volume $(pwd):/src/pbench:z \
#     --rm localhost/pbench-devel-<distro>:<branch name> tox
#
# [1] See https://www.redhat.com/sysadmin/user-flag-rootless-containers