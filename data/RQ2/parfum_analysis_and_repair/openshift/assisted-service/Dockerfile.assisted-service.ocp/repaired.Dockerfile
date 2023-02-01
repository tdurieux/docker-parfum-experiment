# Build binaries
FROM registry.ci.openshift.org/openshift/release:golang-1.17 as builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=1 GOFLAGS="" GO111MODULE=on go build -o /build/assisted-service cmd/main.go
RUN CGO_ENABLED=0 GOFLAGS="" GO111MODULE=on go build -o /build/assisted-service-operator cmd/operator/main.go
RUN CGO_ENABLED=0 GOFLAGS="" GO111MODULE=on go build -o /build/assisted-service-admission cmd/webadmission/main.go
RUN CGO_ENABLED=0 GOFLAGS="" GO111MODULE=on go build -o /build/agent-installer-client cmd/agentbasedinstaller/client/main.go


FROM registry.ci.openshift.org/ocp/4.11:cli AS oc-image
# Create final image
FROM registry.ci.openshift.org/ocp/4.11:base

LABEL io.openshift.release.operator=true

# ToDo: Replace postgres with SQLite DB 
# https://issues.redhat.com/browse/AGENT-223