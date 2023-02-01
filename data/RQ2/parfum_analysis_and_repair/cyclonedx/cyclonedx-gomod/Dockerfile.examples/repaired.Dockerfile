# This Dockerfile is meant for generating example SBOMs in a way
# that is reproducible for everyone.
FROM golang:1.18.4-alpine3.16@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df AS build
WORKDIR /usr/src/app
RUN apk --no-cache add git make
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY . .
RUN make install

FROM golang:1.18.4-alpine3.16@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df
VOLUME /examples

# Install prerequisites
RUN apk --no-cache add git icu-dev && \
    git config --system advice.detachedHead false

# Install CycloneDX CLI
RUN if [ "$(uname -m)" == "aarch64" ]; then CLI_ARCH="arm64"; else CLI_ARCH="musl-x64"; fi && \
    wget -q -O /usr/local/bin/cyclonedx "https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.24.0/cyclonedx-linux-${CLI_ARCH}" && \
    chmod +x /usr/local/bin/cyclonedx

# Install cyclonedx-gomod
COPY --from=build /go/bin/cyclonedx-gomod /usr/local/bin/

# Create example SBOM generation script.
# The script clones a specific Minikube version and downloads a corresponding prebuilt Minikube binary.
# It then generates SBOMs for Minikube in multiple flavors and checks their validity using the CycloneDX CLI.