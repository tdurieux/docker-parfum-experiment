# This Dockerfile will be used to build a single step docker image for the argo workflow
# We are doing that because we want to use `emptyDir` storage in order to speed up the workflow (persistent volume
# taking too much time to be created and mounted) and `emptyDir` is deleted after a pod is completed

### Get core dependencies
FROM scratch as core
WORKDIR /app
COPY core/go.mod .
COPY core/go.sum .
COPY core/cmd/app ./cmd
COPY core/internal ./internal
COPY core/pkg ./pkg

### Build kinto-cli
FROM golang:1.13-alpine as kinto-cli
RUN apk update && apk add --no-cache git
WORKDIR /app
COPY builder/images/kinto-cli/go.mod .
COPY builder/images/kinto-cli/go.sum .
COPY builder/images/kinto-cli/main.go .
COPY builder/images/kinto-cli/cmd ./cmd
COPY builder/images/kinto-cli/cmd-dockerfile ./cmd-dockerfile
COPY builder/images/kinto-cli/cmd-release ./cmd-release
COPY builder/images/kinto-cli/cmd-git ./cmd-git
COPY --from=core /app /app/core
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o kinto-cli main.go

### Build kinto-deploy
FROM golang:1.13-alpine as kinto-deploy
RUN apk update && apk add --no-cache git
WORKDIR /app
COPY builder/images/kinto-deploy/go.mod .
COPY builder/images/kinto-deploy/go.sum .
COPY builder/images/kinto-deploy/cmd ./cmd
COPY builder/images/kinto-deploy/internal ./internal
COPY --from=core /app /app/core
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o kinto-deploy cmd/main.go

# Main Image
FROM gcr.io/kaniko-project/executor:latest
## https://github.com/GoogleContainerTools/kaniko/blob/master/deploy/Dockerfile_debug
COPY --from=amd64/busybox:1.31.1 /bin /busybox
# Declare /busybox as a volume to get it automatically in the path to ignore
# kaniko will not delete this volume at the end of the build stage