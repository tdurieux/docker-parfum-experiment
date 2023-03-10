################################
# STEP 1 build executable binary
################################

FROM golang:1.17-alpine AS build-stage

ARG GITHUB_USER
ARG GITHUB_TOKEN

ENV RELEASE_VERSION=v0.0.2
ENV ARTIFACT_NAME=sandbox-${RELEASE_VERSION}.zip
ENV REPO_URL=https://github.com/saferwall/saferwall-sandbox

# Install git + SSL ca certificates.
# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
RUN apk update && apk add --no-cache git ca-certificates tzdata \
	&& update-ca-certificates 2>/dev/null || true

# Set the Current Working Directory inside the container.
WORKDIR $GOPATH/src/saferwall/sandbox/

# Allow using private github repos that have private go modules.
RUN go env -w GOPRIVATE=github.com/saferwall/* \
	&& git config --global url."https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com".insteadOf "https://github.com"

# Copy go mod and sum files.
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod
# and go.sum files are not changed.
RUN go mod download

# Copy our go files.
COPY . .

# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
	go build -a -installsuffix cgo -ldflags '-extldflags "-static"' \
	-o /go/bin/sandbox-svc cmd/services/sandbox/main.go

# Download fetch.
ADD https://github.com/gruntwork-io/fetch/releases/download/v0.4.2/fetch_linux_amd64 fetch
RUN chmod +x fetch

# Download the sandbox components files.
RUN GITHUB_OAUTH_TOKEN="${GITHUB_TOKEN}" ./fetch \
	--repo="${REPO_URL}" \
	--tag="${RELEASE_VERSION}" \
	--release-asset="${ARTIFACT_NAME}" .

############################
# STEP 2 build a small image
############################

FROM alpine:latest
LABEL maintainer="https://github.com/saferwall"
LABEL version="0.0.3"
LABEL description="Sandbox scan service"

ENV USER saferwall
ENV GROUP saferwall

# Set the Current Working Directory inside the container.
WORKDIR /saferwall

# Copy our static executable.
COPY --from=build-stage /go/bin/sandbox-svc .

# Copy the config files.
COPY configs/services/sandbox/ conf/

# Create an app user so our program doesn't run as root.
RUN addgroup -g 102 -S $GROUP \
	&& adduser -u 101 -S $USER -G $GROUP \
	&& chown -R $USER:$GROUP /saferwall

# Switch to our user.