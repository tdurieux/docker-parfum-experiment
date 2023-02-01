FROM --platform=linux/amd64 quay.io/centos/centos:stream8 AS build

ARG TARGETARCH

RUN mkdir /workdir

COPY go.mod /workdir
WORKDIR /workdir

RUN dnf install -y golang-$(sed -En 's/^go +(.*+)$/\1/p' go.mod).*

COPY . .

RUN GOOS=linux GOARCH=${TARGETARCH} go build -o /manager ./cmd/operator

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=build /manager /usr/local/bin/manager

COPY deploy/crds/nmstate.io_nodenetwork*.yaml /bindata/kubernetes-nmstate/crds/
COPY deploy/handler/namespace.yaml /bindata/kubernetes-nmstate/namespace/
COPY deploy/handler/operator.yaml /bindata/kubernetes-nmstate/handler/handler.yaml
COPY deploy/handler/service_account.yaml /bindata/kubernetes-nmstate/rbac/
COPY deploy/handler/role.yaml /bindata/kubernetes-nmstate/rbac/
COPY deploy/handler/role_binding.yaml /bindata/kubernetes-nmstate/rbac/
COPY deploy/handler/cluster_role.yaml /bindata/kubernetes-nmstate/rbac/

USER 1000

ENTRYPOINT ["manager"]