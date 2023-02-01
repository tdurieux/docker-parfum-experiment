# This Dockerfile creates an fedora image with avocado framework installed
# from source
#
# VERSION 0.1
################
## Usage example:
## Checkout avocado source
# git clone github.com/avocado-framework/avocado.git avocado.git
# cd avocado.git
## Make some changes
# patch -p1 < MY_PATCH
## Finally build a docker image
# docker build --force-rm -t fedora-avocado-custom -f contrib/docker/Dockerfile.fedora .
## Run test inside the docker image
# avocado run --docker fedora-avocado-custom passtest.py
#
FROM fedora

MAINTAINER Dmitry Monakhov dmonakhov@openvz.org

COPY . /devel/avocado-framework/avocado

# Install and clean in one step to decrease image size