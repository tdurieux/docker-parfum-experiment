FROM registry.access.redhat.com/ubi8/ubi-minimal:8.0

LABEL vendor="IBM"
LABEL summary="The agent for edge clusters."
LABEL description="The agent in a container that is used solely for the purpose of running the agent in a kubernetes edge cluster."

# yum is not installed, use microdnf instead
# shadow-utils contains groupadd and adduser commands
RUN microdnf update -y --nodocs && microdnf clean all && microdnf install --nodocs -y shadow-utils \
    && microdnf install --nodocs -y openssl ca-certificates \
    && microdnf install -y wget iptables vim-minimal procps tar \
    && wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && chmod +x ./jq \
    && mv jq /usr/bin \
    && mkdir -p /licenses /usr/horizon/bin /usr/horizon/web /var/horizon \
    && mkdir -p /etc/horizon/agbot/policy.d /etc/horizon/policy.d /etc/horizon/trust /etc/docker/certs.d \
    && adduser agentuser -u 1000 -U -f -1 -c "agent user,1,2,3" 

# add license file
COPY LICENSE.txt /licenses

COPY script/* /home/agentuser/
COPY config/* /etc/horizon/

ADD anax /usr/horizon/bin/
ADD hzn /usr/bin/

RUN chown -R agentuser:agentuser /home/agentuser /etc/horizon /etc/docker

USER agentuser
WORKDIR /home/agentuser
RUN mkdir -p /home/agentuser/policy.d

ENTRYPOINT ["/home/agentuser/anax.service", "start"]