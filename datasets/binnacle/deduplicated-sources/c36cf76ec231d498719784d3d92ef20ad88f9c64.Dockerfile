ARG docker_namespace=walmartlabs
ARG concord_version=latest

FROM $docker_namespace/concord-base:$concord_version
MAINTAINER "Ivan Bodrov" <ibodrov@walmartlabs.com>

EXPOSE 80
EXPOSE 443
EXPOSE 8080

RUN yum -y install nginx && yum clean all

ADD target/dist/console.tar.gz /opt/concord/console/dist/

COPY src/main/docker/start.sh /opt/concord/console/
COPY src/main/docker/nginx /opt/concord/console/nginx

RUN mkdir -p /opt/concord/logs

CMD ["bash", "/opt/concord/console/start.sh"]

