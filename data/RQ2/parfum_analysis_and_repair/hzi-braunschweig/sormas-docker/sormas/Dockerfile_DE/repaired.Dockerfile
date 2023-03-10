ARG SORMAS_DOCKER_VERSION=${SORMAS_DOCKER_VERSION}
FROM hzibraunschweig/sormas-application:${SORMAS_DOCKER_VERSION}

ARG DEMIS_VERSION=1.7.1
ENV DEMIS_VERSION=$DEMIS_VERSION

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_DE.UTF-8 && \
    export LANG=de_DE.UTF-8

ENV LANG de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8
ENV DEBUGINFO_ENABLED false

COPY start-server.sh /start-server.sh
RUN chmod +x /start-server.sh

COPY additional_wars/* /opt/domains/sormas/deployments