ARG BUILDER_IMAGE=quay.io/geonet/golang:1.15-alpine
ARG RUNNER_IMAGE=quay.io/geonet/go-scratch:latest
ARG RUN_USER=nobody
# Only support image based on AlpineLinux
FROM ${BUILDER_IMAGE} as builder

# Obtain ca-cert and tzdata, which we will add to the container
RUN apk add --no-cache --update ca-certificates tzdata gcc make musl-dev

# Project to build
ARG BUILD

# Git commit SHA
ARG GIT_COMMIT_SHA

COPY ./ /repo

WORKDIR /repo

# Set a bunch of go env flags
ENV GOBIN /repo/gobin
ENV GOPATH /usr/src/go
ENV GOFLAGS -mod=vendor
ENV GOOS linux
ENV GOARCH amd64

RUN echo 'nobody:x:65534:65534:Nobody:/:\' > /passwd
RUN CGO_ENABLED=0 go install -a -ldflags "-X main.Prefix=${BUILD}/${GIT_COMMIT_SHA} -extldflags -static" /repo/cmd/${BUILD}

FROM ${RUNNER_IMAGE}
# Export a port, default to 8080
ARG EXPOSE_PORT=8080
EXPOSE $EXPOSE_PORT

# Add common resource for ssl and timezones from the build container
# Create a nobody user
COPY --from=builder /passwd /etc/passwd
# Same ARG as before
ARG BUILD
# Need to make this an env for it to be interpolated by the shell
ENV TZ Pacific/Auckland
ENV BUILD_BIN=${BUILD}
# We have to make our binary have a fixed name, otherwise, we cannot run it without a shell
COPY --from=builder /repo/gobin/${BUILD} /${BUILD}
# Copy the assets
ARG ASSET_DIR
COPY ${ASSET_DIR} /assets
ARG RUN_USER=nobody
USER ${RUN_USER}
# Requires a CMD ["/${BUILD}"] appended by build.sh
