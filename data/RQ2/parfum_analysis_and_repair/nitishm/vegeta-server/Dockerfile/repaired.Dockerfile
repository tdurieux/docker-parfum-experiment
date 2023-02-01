# Build stage
FROM golang:1.12 as build-env
ENV ROOT=/vegeta-server
ADD . $ROOT
WORKDIR $ROOT
RUN make build

# Final stage