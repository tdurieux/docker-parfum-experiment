# This Dockerfile is used to test metadata pulling (issue #651). It includes
# all the instructions that seemed like they ought to create metadata, even if
# unsupported by ch-image.
#
# Scope is "skip" because we pull the image to test it; see
# test/build/50_pull.bats.
#
# To build and push:
#
#   $ VERSION=$(date +%Y-%m-%d)             # or other date as appropriate
#   $ sudo docker login                     # if needed
#   $ sudo docker build -t charliecloud/metadata:$VERSION \
#                       -f Dockerfile.metadata .
#   $ sudo docker images | fgrep metadata
#   $ sudo docker push charliecloud/metadata:$VERSION
#
# ch-test-scope: skip