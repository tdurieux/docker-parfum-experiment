ARG registry
FROM $registry/labtainer.network
LABEL description="This is base Docker image for Labtainer network components with mysql"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
# modified to create new instance
RUN systemd-machine-id-setup

