FROM registry.ci.openshift.org/origin/4.12:machine-config-operator as mcd
FROM registry.ci.openshift.org/origin/4.12:artifacts as artifacts

FROM quay.io/coreos-assembler/coreos-assembler:latest AS build
USER 1000
WORKDIR /src
COPY . .
COPY --from=mcd /usr/bin/machine-config-daemon /src/overlay.d/99okd/usr/libexec/machine-config-daemon
COPY --from=artifacts /srv/repo/*.rpm /srv/okd-repo/
USER 0
ENTRYPOINT ["/src/entrypoint.sh"]