FROM registry.access.redhat.com/ubi8/ubi-minimal:8.0

LABEL vendor="IBM"
LABEL summary="The agent in a general purpose container."
LABEL description="A container which holds the edge node agent, to be used in environments where there is no operating system package that can install the agent natively."

ARG DOCKER_VER=19.03.8

# yum is not installed, use microdnf instead
RUN microdnf update -y --nodocs && microdnf clean all

# add EPEL repo with jq pkg and all deps
#COPY EPEL.repo /etc/yum.repos.d

# shadow-utils contains groupadd and adduser commands
# install docker cli
# create required directories
RUN microdnf install --nodocs -y shadow-utils \
    && microdnf install --nodocs -y openssl ca-certificates \
    && microdnf install -y wget iptables vim-minimal procps tar gzip \
    && microdnf update -y --nodocs --nobest && microdnf clean all \
    && microdnf install -y jq \
    && curl -fsSLO https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKER_VER}.tgz \
  	&& tar xzvf docker-${DOCKER_VER}.tgz --strip 1 -C /usr/bin docker/docker \
  	&& rm docker-${DOCKER_VER}.tgz \
    && mkdir -p /licenses && mkdir -p /usr/horizon/bin /usr/horizon/web /var/horizon \
    && mkdir -p /etc/horizon/agbot/policy.d /etc/horizon/policy.d /etc/horizon/trust

# add license file 
COPY LICENSE.txt /licenses

# copy the horizon configurations
COPY config/anax.json /etc/horizon/
COPY config/hzn.json /etc/horizon/

# copy anax and hzn binaries
ADD anax /usr/horizon/bin/
ADD hzn /usr/bin/

WORKDIR /root
COPY script/anax.service /root/

# You can add a 2nd arg to this on the docker run cmd or the CMD statement in another dockerfile, to configure a specific environment
ENTRYPOINT ["/root/anax.service", "start"]