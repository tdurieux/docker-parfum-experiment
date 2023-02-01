ARG docker_namespace=walmartlabs
ARG concord_version=latest

FROM $docker_namespace/concord-ansible:$concord_version
MAINTAINER "Ivan Bodrov" <ibodrov@walmartlabs.com>

ENV DOCKER_HOST tcp://dind:2375
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt

USER root

RUN yum -y install docker-client && yum clean all

COPY --chown=concord:concord target/deps/ /home/concord/.m2/repository
ADD --chown=concord:concord target/dist/agent.tar.gz /opt/concord/agent/

USER concord
CMD ["bash", "/opt/concord/agent/start.sh"]
