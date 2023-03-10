FROM golang:1.18-alpine

# This Dockerfile sets up an image for repeated integration testing.
# This assumes the build context, i.e., CWD is vuln/

# ---- Step 0: Setup shared build tools. ----
RUN apk update && apk add --no-cache bash git gcc musl-dev linux-headers

# ---- Step 1: Build govulncheck ----
COPY . /go/src/golang.org/x/vuln
WORKDIR /go/src/golang.org/x/vuln/cmd/govulncheck/integration
RUN go install golang.org/x/vuln/cmd/govulncheck

# ---- Step 2: Build other test binaries ----
RUN go install golang.org/x/vuln/cmd/govulncheck/integration/k8s
