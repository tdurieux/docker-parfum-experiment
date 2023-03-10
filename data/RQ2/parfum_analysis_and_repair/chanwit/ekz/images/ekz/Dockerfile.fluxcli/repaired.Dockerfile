FROM alpine:3.13 as builder

RUN apk add --no-cache ca-certificates curl

ARG ARCH=linux/amd64
ARG KUBECTL_VER=1.20.4
ARG FLUXCLI_VER=0.10.0

RUN curl -f -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/${ARCH}/kubectl \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && \
    kubectl version --client=true

RUN curl -f -sL https://github.com/fluxcd/flux2/releases/download/v${FLUXCLI_VER}/flux_${FLUXCLI_VER}_linux_amd64.tar.gz | tar xzvf -

FROM alpine:3.13

# Create minimal nsswitch.conf file to prioritize the usage of /etc/hosts over DNS queries.
# https://github.com/gliderlabs/docker-alpine/issues/367#issuecomment-354316460
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

RUN apk add --no-cache ca-certificates

COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/
COPY --from=builder /flux /usr/local/bin/

ENTRYPOINT [ "flux" ]