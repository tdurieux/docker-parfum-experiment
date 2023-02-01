######################################
# Prepare go_builder
######################################
FROM golang:1.16 as go_builder
WORKDIR /go/src/github.com/checkr/flagr
ADD . .
RUN make build

######################################
# Copy from builder to alpine image
######################################