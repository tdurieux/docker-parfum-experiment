# Build from repo root dir: docker build -f request-manager/Dockerfile . -t spin-rm
# Run one container:        docker run -p 32308:32308 spin-rm

FROM golang:1.13.6-alpine3.11

# Install mysql cli so entrypoint script can init db
RUN apk add --no-cache \
    mysql-client

# Copy source code and copy dev jobs over open-source stub jobs
COPY .          /go/src/github.com/square/spincycle/
COPY dev/jobs/  /go/src/github.com/square/spincycle/jobs/

# Build request-manager bin
WORKDIR /app/spin-rm/bin
RUN go build -o request-manager github.com/square/spincycle/request-manager/bin/

# Change to root of workdir and copy static files from source code