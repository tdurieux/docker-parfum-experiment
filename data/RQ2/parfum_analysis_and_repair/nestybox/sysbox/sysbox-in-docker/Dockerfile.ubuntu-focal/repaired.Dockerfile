#
# Sysbox-In-Docker Container Dockerfile (Ubuntu-Focal image)
#
# This Dockerfile creates the sysbox-in-docker container image, which holds
# all Sysbox binaries and its dependencies. The goal is to allow users to run
# an entire Sysbox sandbox within a container.
#
# NOTE: Sysbox is a container runtime and thus needs host root privileges. As a
# result, this image must be run as a privileged container, and a few resources
# must be bind-mounted to meet Sysbox requirements as well as those of system-level
# apps running in inner containers. Notice that within the privileged container,
# inner containers launched with Docker + Sysbox will be strongly isolated from the
# host by Sysbox (e.g., via the Linux user-namespace).
#
# Instructions:
#
# * Image creation:
#
#   $ make sysbox-in-docker ubuntu-focal
#
# * Container creation:
#
# docker run -d --privileged --rm --hostname sysbox-in-docker --name sysbox-in-docker \
#                -v /var/tmp/sysbox-var-lib-docker:/var/lib/docker \
#                -v /var/tmp/sysbox-var-lib-sysbox:/var/lib/sysbox \
#                -v /lib/modules/$(uname -r):/lib/modules/$(uname -r):ro \
#                -v /usr/src/linux-headers-$(uname -r):/usr/src/linux-headers-$(uname -r):ro \
#                -v /usr/src/linux-headers-$(uname -r | cut -d"-" -f 1,2):/usr/src/linux-headers-$(uname -r | cut -d"-" -f 1,2):ro \
#                nestybox/sysbox-in-docker:ubuntu-focal
#

FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       apt-utils \
       ca-certificates \
       wget \
       curl \
       iproute2 \
       jq \
       fuse \
       rsync \
       dialog \
       kmod \
       bash-completion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo ". /etc/bash_completion" >> /etc/bash.bashrc

# Install Docker.
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
ADD https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker /etc/bash_completion.d/docker.sh

# S6 process-supervisor installation.
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

ENV \
    # Pass envvar variables to agents
    S6_KEEP_ENV=1 \
    # Direct all agent logs to stdout.
    S6_LOGGING=0 \
    # Exit container if entrypoint fails.
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY s6-services /etc/services.d/
COPY sysbox /etc/cont-init.d/

# Copy Sysbox artifacts.