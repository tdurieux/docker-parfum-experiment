# A base image to build the fuse sidecar (debian based).
#
# This image is updated every week by CI
FROM debian

# NOTE: an equivalent of tini is now available natively with docker, but cannot be used by kubernetes