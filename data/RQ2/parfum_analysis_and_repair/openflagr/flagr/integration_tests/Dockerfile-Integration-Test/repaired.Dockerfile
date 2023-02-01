######################################
# Prepare go_builder
######################################
FROM golang:1.17 as go_builder
WORKDIR /go/src/github.com/openflagr/flagr
ADD . .
RUN make build

######################################
# Copy from builder to alpine image
######################################