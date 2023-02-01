ARG RANCHER_TAG=dev
ARG RANCHER_REPO=rancher
FROM ${RANCHER_REPO}/rancher:${RANCHER_TAG} as rancher

FROM registry.suse.com/bci/bci-base:15.3
ARG ARCH=amd64

ENV KUBECTL_VERSION v1.23.6
RUN zypper -n install --no-recommends curl ca-certificates jq git-core hostname iproute2 vim-small less \
	bash-completion acl openssh-clients tar gzip xz gawk sysstat && \
    zypper -n clean -a && rm -rf /tmp/* /var/tmp/* /usr/share/doc/packages/* && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

ENV LOGLEVEL_VERSION v0.1.5

RUN curl -sLf https://github.com/rancher/loglevel/releases/download/${LOGLEVEL_VERSION}/loglevel-${ARCH}-${LOGLEVEL_VERSION}.tar.gz | tar xvzf - -C /usr/bin

ARG VERSION=dev
LABEL io.cattle.agent true
ENV AGENT_IMAGE rancher/rancher-agent:${VERSION}
ENV SSL_CERT_DIR /etc/kubernetes/ssl/certs
COPY --from=rancher /var/lib/rancher-data /var/lib/rancher-data
COPY --from=rancher /usr/bin/tini /usr/bin/
COPY agent run.sh kubectl-shell.sh shell-setup.sh /usr/bin/
WORKDIR /var/lib/rancher
ENTRYPOINT ["run.sh"]