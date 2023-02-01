# This docker image specifies how to get started with `hotsub` CLI.
FROM debian:stretch-slim

# 0) Packages
RUN apt-get update -qq && apt-get install --no-install-recommends -y curl wget python-pip sudo groff vim && rm -rf /var/lib/apt/lists/*;

# 1) docker-machine
# See https://docs.docker.com/machine/install-machine/#install-machine-directly
RUN base=https://github.com/docker/machine/releases/download/v0.14.0 \
  && curl -f -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
  && sudo install /tmp/docker-machine /usr/local/bin/docker-machine

# 2) aws cli
RUN pip install --no-cache-dir awscli

ARG HOTSUB_VERSION=v0.5.0
# 3) hotsub itself
RUN wget -q https://github.com/otiai10/hotsub/releases/download/${HOTSUB_VERSION}/hotsub.linux_amd64.tar.gz
RUN tar -xzvf hotsub.linux_amd64.tar.gz && mv ./hotsub /usr/local/bin && rm hotsub.linux_amd64.tar.gz

# Usage of this image:
#
#     docker run -it hotsub/proxy
#
# Then you can use aws, docker-machine and hotsub commands available