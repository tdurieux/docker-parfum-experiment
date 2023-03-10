FROM caicloud/cyclone-base-openjdk:v1.0.0-arm64v8

LABEL maintainer="zhujian@caicloud.io"

ENV WORKDIR /workspace
WORKDIR $WORKDIR

COPY ./build/cicd/sonarqube/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]