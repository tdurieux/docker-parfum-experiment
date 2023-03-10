FROM alpine:3.16.0 as otelcol
COPY otelcol-sumo /
# This shouldn't be necessary but sometimes we end up with execution bit not set.
# ref: https://github.com/open-telemetry/opentelemetry-collector/issues/1317
RUN chmod 755 /otelcol-sumo

FROM alpine:3.16.0 as certs
RUN apk --update --no-cache add ca-certificates

FROM alpine:3.16.0 as directories
RUN mkdir /etc/otel/

FROM debian:11.4 as systemd
RUN apt update && apt install --no-install-recommends -y systemd && rm -rf /var/lib/apt/lists/*;
# prepare package with journald and it's dependencies keeping original paths
# h stands for dereference of symbolic links
RUN tar czhf journalctl.tar.gz /bin/journalctl $(ldd /bin/journalctl | grep -oP "\/.*? ")

FROM alpine:3.16.0
RUN apk update && apk add --no-cache curl tar
RUN curl -f -LJ "https://go-boringcrypto.storage.googleapis.com/go1.18.2b7.linux-amd64.tar.gz" -o go.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.linux-amd64.tar.gz \
    && rm go.linux-amd64.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/local/bin

ARG BUILD_TAG=latest
ENV TAG $BUILD_TAG
ARG USER_UID=10001
USER ${USER_UID}
ENV HOME /etc/otel/

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=otelcol /otelcol-sumo /otelcol-sumo
COPY --from=directories --chown=${USER_UID}:${USER_UID} /etc/otel/ /etc/otel/

# copy and extract journald with dependencies
COPY --from=systemd --chown=${USER_UID}:${USER_UID} /journalctl.tar.gz /journalctl.tar.gz
USER root
RUN tar xf /journalctl.tar.gz --directory / && rm /journalctl.tar.gz
USER ${USER_UID}

ENTRYPOINT ["/otelcol-sumo"]
CMD ["--config", "/etc/otel/config.yaml"]
