# Build container;
FROM openfalcon/makegcc-golang:1.15-alpine
LABEL maintainer laiwei.ustc@gmail.com
USER root

ENV FALCON_DIR=/open-falcon PROJ_PATH=${GOPATH}/src/github.com/open-falcon/falcon-plus

RUN mkdir -p $FALCON_DIR && \
    apk add --no-cache ca-certificates git

COPY . ${PROJ_PATH}

WORKDIR ${PROJ_PATH}

ARG MODULE

RUN make $MODULE \
    && make pack4docker CMD=$MODULE \
    && tar -zxf open-falcon-v*.tar.gz -C ${FALCON_DIR} \
    && rm -rf ${PROJ_PATH} && rm open-falcon-v*.tar.gz

# Final container;
FROM alpine:3.13
LABEL maintainer laiwei.ustc@gmail.com
USER root

ENV FALCON_DIR=/open-falcon

RUN mkdir -p $FALCON_DIR/logs && \
    apk update && \
    apk add --no-cache ca-certificates bash git iproute2

COPY --from=0 ${FALCON_DIR} ${FALCON_DIR}

EXPOSE 8433 8080
WORKDIR ${FALCON_DIR}
