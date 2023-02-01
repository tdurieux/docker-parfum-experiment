FROM eclipse-temurin:18

VOLUME ["/server"]
WORKDIR /server

COPY /plugins/ /server/plugins/
COPY /velocity.toml /server/

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    sudo \
    curl \
    unzip \
    nano \
    && apt-get clean

ARG MC_HELPER_VERSION=1.16.11
ARG MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v${MC_HELPER_VERSION}
RUN curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz \
    | tar -C /usr/share -zxf - \
    && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin

ENV SERVER_PORT=25577 MEMORY=512m
EXPOSE $SERVER_PORT

CMD ["/usr/bin/run-proxy.sh"]

COPY *.sh /usr/bin/
