# This will build the latest master
#
# we use an intermediate image to build this image. it will make the resulting
# image a bit smaller.
#
# you can build the image with:
#
#   docker build . -t raiden

FROM python:3.9 as builder

# use --build-arg RAIDENVERSION=v0.0.3 to build a specific (tagged) version
ARG REPO=raiden-network/raiden
ARG RAIDENVERSION=develop

# This is a "hack" to automatically invalidate the cache in case there are new commits
ADD https://api.github.com/repos/${REPO}/commits/${RAIDENVERSION} /dev/null

# clone raiden repo + install dependencies