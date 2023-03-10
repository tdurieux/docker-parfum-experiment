# Build stage
ARG goversion
FROM golang:${goversion}-alpine as builder
RUN apk add --no-cache build-base git mercurial ca-certificates
RUN apk add --no-cache --update gcc musl-dev
ADD go.mod /spire/go.mod
RUN cd /spire && go mod download
ADD . /spire
WORKDIR /spire
RUN make build-static

# SPIRE Server
FROM scratch AS spire-server-scratch
COPY --from=builder /spire/bin/spire-server-static /opt/spire/bin/spire-server
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /opt/spire
ENTRYPOINT ["/opt/spire/bin/spire-server", "run"]
CMD []

FROM scratch  AS spire-agent-scratch
COPY --from=builder /spire/bin/spire-agent-static /opt/spire/bin/spire-agent
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /opt/spire
EXPOSE 8080 8443
ENTRYPOINT ["/opt/spire/bin/spire-agent", "run"]
CMD []

# K8S Workload Registrar
FROM scratch AS k8s-workload-registrar-scratch
COPY --from=builder /spire/bin/k8s-workload-registrar-static /opt/spire/bin/k8s-workload-registrar
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /opt/spire
ENTRYPOINT ["/opt/spire/bin/k8s-workload-registrar"]
CMD []

# OIDC Discovery Provider
FROM scratch AS oidc-discovery-provider-scratch
COPY --from=builder /spire/bin/oidc-discovery-provider-static /opt/spire/bin/oidc-discovery-provider
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /opt/spire
ENTRYPOINT ["/opt/spire/bin/oidc-discovery-provider"]
CMD []
