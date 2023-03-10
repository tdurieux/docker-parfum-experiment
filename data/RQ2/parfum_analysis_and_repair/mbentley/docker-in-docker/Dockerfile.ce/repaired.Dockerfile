# rebased/repackaged base image that only updates existing packages
FROM mbentley/ubuntu:18.04
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG DOCKER_VER
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl gnupg iproute2 module-init-tools net-tools socat && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y docker-ce && \
  apt-get purge -y docker-ce-rootless-extras docker-scan-plugin && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/docker","/var/lib/containerd"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["dockerd","-s","overlay2","-H","unix:///var/run/docker.sock"]
