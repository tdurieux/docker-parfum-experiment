FROM mbentley/docker-in-docker:ce-systemd
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y openssh-server && \
  rm -rf /var/lib/apt/lists/* && \
  rm -v /etc/ssh/ssh_host_*
