FROM registry.ci.openshift.org/openshift/release:golang-1.18 as build
LABEL stage=build

# dos2unix is needed to build CNI plugins
RUN yum install -y dos2unix && rm -rf /var/cache/yum

WORKDIR /build/windows-machine-config-operator/
COPY .git .git

# Build WMCB
WORKDIR /build/windows-machine-config-operator/windows-machine-config-bootstrapper/
COPY windows-machine-config-bootstrapper/ .
RUN make build

# Build hybrid-overlay
WORKDIR /build/windows-machine-config-operator/ovn-kubernetes/
COPY ovn-kubernetes/ .
WORKDIR /build/windows-machine-config-operator/ovn-kubernetes/go-controller/
RUN make windows

# Build promu utility tool, needed to build the windows_exporter.exe metrics binary
WORKDIR /build/windows-machine-config-operator/promu/
COPY promu/ .
# Explicitly set the $GOBIN path for promu installation
RUN GOBIN=/build/windows-machine-config-operator/windows_exporter/ go install .

# Build windows_exporter
WORKDIR /build/windows-machine-config-operator/windows_exporter/
COPY windows_exporter/ .
RUN GOOS=windows ./promu build -v

# Build containerd
WORKDIR /build/windows-machine-config-operator/containerd/
COPY containerd/ .
RUN GOOS=windows make

# Build containerd shim
WORKDIR /build/windows-machine-config-operator/hcsshim/
COPY hcsshim/ .
RUN GOOS=windows go build ./cmd/containerd-shim-runhcs-v1

# Build kubelet
WORKDIR /build/windows-machine-config-operator/kubelet/
COPY kubelet/ .
ENV KUBE_BUILD_PLATFORMS windows/amd64
RUN make WHAT=cmd/kubelet

# Build kube-proxy
WORKDIR /build/windows-machine-config-operator/kube-proxy/
COPY kube-proxy/ .
ENV KUBE_BUILD_PLATFORMS windows/amd64
RUN make WHAT=cmd/kube-proxy

# Build azure-cloud-node-manager
WORKDIR /build/windows-machine-config-operator/cloud-provider-azure/
COPY cloud-provider-azure/ .
RUN GOOS=windows go build -o azure-cloud-node-manager.exe ./cmd/cloud-node-manager

# Build CNI plugins
WORKDIR /build/windows-machine-config-operator/containernetworking-plugins/
COPY containernetworking-plugins/ .
ENV CGO_ENABLED=0
RUN ./build_windows.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
LABEL stage=base

# Copy wmcb.exe
WORKDIR /payload/
COPY --from=build /build/windows-machine-config-operator/windows-machine-config-bootstrapper/wmcb.exe .

# Copy hybrid-overlay-node.exe
COPY --from=build /build/windows-machine-config-operator/ovn-kubernetes/go-controller/_output/go/bin/windows/hybrid-overlay-node.exe .

# Copy windows_exporter.exe
COPY --from=build /build/windows-machine-config-operator/windows_exporter/windows_exporter.exe .

# Copy azure-cloud-node-manager.exe
COPY --from=build /build/windows-machine-config-operator/cloud-provider-azure/azure-cloud-node-manager.exe .

# Copy containerd.exe, containerd-shim-runhcs-v1.exe and containerd config containerd_conf.toml
WORKDIR /payload/containerd/
COPY --from=build /build/windows-machine-config-operator/containerd/bin/containerd.exe .
COPY --from=build /build/windows-machine-config-operator/hcsshim/containerd-shim-runhcs-v1.exe .
COPY pkg/internal/containerd_conf.toml .

# Copy kubelet.exe and kube-proxy.exe
WORKDIR /payload/kube-node/
COPY --from=build /build/windows-machine-config-operator/kubelet/_output/local/bin/windows/amd64/kubelet.exe .
COPY --from=build /build/windows-machine-config-operator/kube-proxy/_output/local/bin/windows/amd64/kube-proxy.exe .

# Copy CNI plugin binaries and CNI config template cni-conf-template.json
WORKDIR /payload/cni/
COPY --from=build /build/windows-machine-config-operator/containernetworking-plugins/bin/host-local.exe .
COPY --from=build /build/windows-machine-config-operator/containernetworking-plugins/bin/win-bridge.exe .
COPY --from=build /build/windows-machine-config-operator/containernetworking-plugins/bin/win-overlay.exe .
COPY pkg/internal/cni-conf-template.json .
