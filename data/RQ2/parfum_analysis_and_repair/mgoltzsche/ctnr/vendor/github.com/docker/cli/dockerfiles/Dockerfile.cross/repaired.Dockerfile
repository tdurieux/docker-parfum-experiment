FROM    dockercore/golang-cross:1.10.3@sha256:7671b4ed357fda50124e5679d36c4c3206ded4d43f1d2e0ff3d120a1e2bf94d7
ENV     DISABLE_WARN_OUTSIDE_CONTAINER=1
WORKDIR /go/src/github.com/docker/cli