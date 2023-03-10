FROM arm32v6/golang:1.14-alpine AS build

RUN apk add --no-cache git build-base && \
  git clone --branch v0.70.0 https://github.com/gohugoio/hugo.git && \
  cd hugo/ && \
  CGO_ENABLED=0 go build -ldflags "-s -w -X github.com/gohugoio/hugo/common/hugo.buildDate=$(date +%Y-%m-%dT%H:%M:%SZ) -X github.com/gohugoio/hugo/common/hugo.commitHash=$(git rev-parse --short HEAD)" -o /tmp/hugo . && \
  CGO_ENABLED=1 go build -tags extended -ldflags "-s -w -X github.com/gohugoio/hugo/common/hugo.buildDate=$(date +%Y-%m-%dT%H:%M:%SZ) -X github.com/gohugoio/hugo/common/hugo.commitHash=$(git rev-parse --short HEAD)" -o /tmp/hugo-extended

FROM plugins/base:linux-arm

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" \
  org.label-schema.name="Drone Hugo" \
  org.label-schema.vendor="Drone.IO Community" \
  org.label-schema.schema-version="1.0"

RUN apk --no-cache add git libc6-compat libstdc++

ENV PLUGIN_HUGO_ARCH=arm
ENV PLUGIN_HUGO_SHIPPED_VERSION=0.70.0

COPY --from=build /tmp/hugo /bin/hugo
COPY --from=build /tmp/hugo-extended /bin/hugo-extended

ADD release/linux/arm/drone-hugo /bin/
ENTRYPOINT ["/bin/drone-hugo"]