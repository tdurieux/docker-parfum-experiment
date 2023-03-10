ARG VERSION=latest

FROM alpine/helm:${VERSION}

RUN apk add --no-cache bash git

COPY deployments/k8s/helm/signalfx-agent/ /opt/signalfx-agent

ENTRYPOINT tail -f /dev/null
