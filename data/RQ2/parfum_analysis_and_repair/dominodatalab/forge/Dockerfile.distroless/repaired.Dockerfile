# TODO: try to make this work with the distroless container

# Build the manager binary
FROM golang:1.14 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY pkg/ pkg/

# Build
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
# FROM gcr.io/distroless/static:nonroot
# WORKDIR /
# COPY --from=builder /workspace/manager .
# USER nonroot:nonroot

# ENTRYPOINT ["/manager"]

# FROM alpine
# RUN apk add --no-cache autoconf automake build-base byacc gettext gettext-dev gcc git libcap-dev libtool libxslt
# RUN git clone https://github.com/shadow-maint/shadow.git /shadow
# WORKDIR /shadow
# RUN git checkout 59c2dabb264ef7b3137f5edb52c0b31d5af0cf76
# RUN ./autogen.sh --disable-nls --disable-man --without-audit --without-selinux --without-acl --without-attr --without-tcb --without-nscd \
#   && make \
#   && cp src/newuidmap src/newgidmap /usr/bin
# RUN apk add --no-cache runc
# WORKDIR /
# COPY --from=builder /workspace/manager .
# ENTRYPOINT ["/manager"]

FROM golang:1.14 as idmap
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential autoconf automake autopoint byacc libtool gettext && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/shadow-maint/shadow.git /shadow
WORKDIR /shadow
RUN git checkout 59c2dabb264ef7b3137f5edb52c0b31d5af0cf76
RUN ./autogen.sh --disable-nls --disable-man --without-audit --without-selinux --without-acl --without-attr --without-tcb --without-nscd \
  && make \
  && cp src/newuidmap src/newgidmap /usr/bin

FROM golang:1.14
RUN apt-get update && apt-get install --no-install-recommends -y runc && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY --from=builder /workspace/manager .
COPY --from=idmap /usr/bin/newuidmap /usr/bin/newuidmap
COPY --from=idmap /usr/bin/newgidmap /usr/bin/newgidmap
RUN chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap
USER nobody
ENV USER nobody
ENTRYPOINT ["/manager"]
