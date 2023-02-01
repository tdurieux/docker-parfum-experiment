FROM quay.io/skopeo/stable:v1.1.1

# Add jq
RUN yum -y update && yum -y install jq && yum -y clean all && rm -rf /var/cache/dnf/* /var/log/dnf* /var/log/yum* && rm -rf /var/cache/yum

# Add docker cli
COPY --from=docker.io/library/docker:19.03.12 /usr/local/bin/docker /usr/local/bin/

# Add buildx plugin from github
RUN mkdir -p /root/.docker/cli-plugins/ && curl -f -sLo /root/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64 && chmod a+x /root/.docker/cli-plugins/*

# Add scripts
COPY image-mirror.sh entrypoint.sh /
ENV DAPPER_ENV DEST_ORG_OVERRIDE DOCKER_REGISTRY DOCKER_USERNAME DOCKER_PASSWORD

ENTRYPOINT ["/entrypoint.sh"]
