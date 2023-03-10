FROM alpine AS build
ARG TARGETPLATFORM
WORKDIR build
COPY dist/ dist/
RUN apk --no-cache add ca-certificates && \
    TARGETPLATFORM="${TARGETPLATFORM//\//_}" && \
    TARGETPLATFORM="${TARGETPLATFORM//v/}" && \
    mkdir /prod && \
    mv "dist/docker-lock_${TARGETPLATFORM}/docker-lock" /prod/ && \
    rm -rf /build
WORKDIR /run
ENTRYPOINT ["/prod/docker-lock"]