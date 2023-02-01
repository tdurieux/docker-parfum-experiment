FROM registry.suse.com/bci/golang:1.17

ARG DAPPER_HOST_ARCH
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH}
ENV CATTLE_HELM_VERSION v2.16.8-rancher2
ENV CATTLE_MACHINE_VERSION v0.15.0-rancher90
ENV CATTLE_K3S_VERSION v1.24.2+k3s1
# version used by helm plugin install script
ENV CATTLE_HELM_UNITTEST_VERSION v0.1.7-rancher4
# helm 3 version
ENV HELM_VERSION v3.9.0
ENV KUSTOMIZE_VERSION v4.4.1

# kontainer-driver-metadata branch to be set for specific branch other than dev/master, logic at rancher/rancher/pkg/settings/setting.go
ENV CATTLE_KDM_BRANCH=dev-v2.6

RUN zypper -n install gcc binutils glibc-devel-static ca-certificates git-core wget curl unzip tar vim less file xz gzip sed gawk iproute2 iptables jq
# use containerd from k3s image, not from bci
RUN zypper install -y -f docker && rpm -e --nodeps --noscripts containerd

RUN curl -sLf https://github.com/rancher/machine/releases/download/${CATTLE_MACHINE_VERSION}/rancher-machine-${ARCH}.tar.gz | tar xvzf - -C /usr/bin

RUN zypper -n in go1.17

RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.44.0; \
        curl -f -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/fossas/spectrometer/master/install.sh | sh; \
    fi

ENV HELM_URL_V2_amd64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-helm \
    HELM_URL_V2_arm64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-helm-arm64 \
    HELM_URL_V2_s390x=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-helm-s390x \
    HELM_URL_V2=HELM_URL_V2_${ARCH} \
    HELM_URL_V3=https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz \
    TILLER_URL_amd64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-tiller \
    TILLER_URL_arm64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-tiller-arm64 \
    TILLER_URL_s390x=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/rancher-tiller-s390x \
    TILLER_URL=TILLER_URL_${ARCH} \
    KUSTOMIZE_URL=https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz

RUN curl -sLf ${KUSTOMIZE_URL} | tar -xzf - -C /usr/bin

# set up helm 2
RUN curl -sLf ${!HELM_URL_V2} -o /usr/bin/rancher-helm && \
    curl -sLf ${!TILLER_URL} -o /usr/bin/rancher-tiller && \
    chmod +x /usr/bin/rancher-helm /usr/bin/rancher-tiller && \
    ln -s /usr/bin/rancher-helm /usr/bin/helm && \
    ln -s /usr/bin/rancher-tiller /usr/bin/tiller && \
    helm init -c --stable-repo-url https://charts.helm.sh/stable/ && \
    helm plugin install https://github.com/rancher/helm-unittest

# set up helm 3
RUN mkdir /usr/tmp && \
    curl -f ${HELM_URL_V3} | tar xvzf - --strip-components=1 -C /usr/tmp/ && \
    mv /usr/tmp/helm /usr/bin/helm_v3 && \
    chmod +x /usr/bin/kustomize

# Set up K3s: copy the necessary binaries from the K3s image.
COPY --from=rancher/k3s:v1.24.2-k3s1 \
    /bin/blkid \
    /bin/charon \
    /bin/cni \
    /bin/conntrack \
    /bin/containerd \
    /bin/containerd-shim-runc-v2 \
    /bin/ethtool \
    /bin/ip \
    /bin/ipset \
    /bin/k3s \
    /bin/losetup \
    /bin/pigz \
    /bin/runc \
    /bin/swanctl \
    /bin/which \
    /bin/aux/xtables-legacy-multi \
/usr/bin/

RUN mkdir -p /go/src/github.com/rancher/rancher/.kube

RUN ln -s /usr/bin/cni /usr/bin/bridge && \
    ln -s /usr/bin/cni /usr/bin/flannel && \
    ln -s /usr/bin/cni /usr/bin/host-local && \
    ln -s /usr/bin/cni /usr/bin/loopback && \
    ln -s /usr/bin/cni /usr/bin/portmap && \
    ln -s /usr/bin/k3s /usr/bin/crictl && \
    ln -s /usr/bin/k3s /usr/bin/ctr && \
    ln -s /usr/bin/k3s /usr/bin/k3s-agent && \
    ln -s /usr/bin/k3s /usr/bin/k3s-etcd-snapshot && \
    ln -s /usr/bin/k3s /usr/bin/k3s-server && \
    ln -s /usr/bin/k3s /usr/bin/kubectl && \
    ln -s /usr/bin/pigz /usr/bin/unpigz && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/iptables && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/iptables-save && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/iptables-restore && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/iptables-translate && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/ip6tables && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/ip6tables-save && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/ip6tables-restore && \
    ln -s /usr/bin/xtables-legacy-multi /usr/bin/ip6tables-translate && \
    ln -s /etc/rancher/k3s/k3s.yaml /go/src/github.com/rancher/rancher/.kube/k3s.yaml


RUN curl -sLf https://github.com/rancher/k3s/releases/download/${CATTLE_K3S_VERSION}/k3s-images.txt -o /usr/tmp/k3s-images.txt

ENV YQ_URL=https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_${ARCH}
RUN curl -sLf ${YQ_URL} -o /usr/bin/yq && chmod +x /usr/bin/yq


RUN zypper install -y python3-tox python3-base python3 libffi-devel libopenssl-devel

ENV HELM_HOME /root/.helm
ENV DAPPER_ENV REPO TAG DRONE_TAG DRONE_COMMIT DRONE_BRANCH SYSTEM_CHART_DEFAULT_BRANCH FOSSA_API_KEY GOGET_MODULE GOGET_VERSION RELEASE_ACTION
ENV DAPPER_SOURCE /go/src/github.com/rancher/rancher/
ENV DAPPER_OUTPUT ./bin ./dist ./go.mod ./go.sum ./pkg/apis/go.mod ./pkg/apis/go.sum ./pkg/client/go.mod ./pkg/client/go.sum ./scripts/package ./pkg/settings/setting.go ./package/Dockerfile ./Dockerfile.dapper
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_RUN_ARGS "-v rancher2-go16-pkg-1:/go/pkg -v rancher2-go16-cache-1:/root/.cache/go-build --privileged"
ENV GOCACHE /root/.cache/go-build
ENV HOME ${DAPPER_SOURCE}
VOLUME /var/lib/rancher
VOLUME /var/lib/kubelet
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
