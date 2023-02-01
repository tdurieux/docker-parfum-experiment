FROM alpine:latest as build
RUN apk add --no-cache -U curl ca-certificates
RUN curl -f -sSL https://download.docker.com/linux/static/nightly/x86_64/docker-0.0.0-20180807170338-5f75afe.tgz -o /var/tmp/docker.tgz && \
    cd /var/tmp && tar zxf docker.tgz && rm docker.tgz

FROM scratch
COPY --from=build /var/tmp/docker/* /bin/
