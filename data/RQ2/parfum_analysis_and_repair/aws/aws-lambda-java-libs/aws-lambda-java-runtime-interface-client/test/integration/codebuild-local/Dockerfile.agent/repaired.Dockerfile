FROM public.ecr.aws/amazoncorretto/amazoncorretto:8

ARG ARCHITECTURE="amd64"

ENV DOCKER_CLI_PLUGIN_DIR="/root/.docker/cli-plugins"

RUN amazon-linux-extras enable docker && \
    yum clean metadata && \
    yum install -y docker tar maven unzip file wget && rm -rf /var/cache/yum
RUN mkdir -p "${DOCKER_CLI_PLUGIN_DIR}"
RUN wget \
    "$( curl -f https://api.github.com/repos/docker/buildx/releases/latest | grep browser_download_url | grep "linux-${ARCHITECTURE}" | cut -d '"' -f 4)" \
     -O "${DOCKER_CLI_PLUGIN_DIR}"/docker-buildx
RUN chmod +x "${DOCKER_CLI_PLUGIN_DIR}"/docker-buildx
