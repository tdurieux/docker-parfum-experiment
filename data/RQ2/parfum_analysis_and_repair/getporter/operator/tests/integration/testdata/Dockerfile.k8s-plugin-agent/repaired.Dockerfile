ARG PORTER_VERSION
ARG REGISTRY
FROM $REGISTRY/porter-agent:$PORTER_VERSION
COPY --chown=65532:65532 bin/plugins/kubernetes/runtimes/kubernetes-runtime /app/.porter/plugins/kubernetes/kubernetes