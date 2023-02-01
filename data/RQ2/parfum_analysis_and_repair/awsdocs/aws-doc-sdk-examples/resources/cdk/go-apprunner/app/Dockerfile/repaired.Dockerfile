# This dockerfile is a two-stage build.
#In the first, we build our actual application using go build.
FROM golang AS builder
WORKDIR /go/src
COPY ./* .
RUN echo "Building application in builder image"
# Build the actual application:
# We need to disable CGO in order to remove any dependencies on
# external libraries. We also pass some flags to the linker
# to reduce the size of our application:
#  -w disables Dwarf debugging (for linux)
#  -s disables symbol table creation
# In a production envrionment, these are generally not useful to have.
RUN GOPROXY=direct CGO_ENABLED=0 \
    go build -ldflags="-w -s" \
    -o /go/bin/app

# In the second stage, the deployed stage, we copy the built
# application over, plus some files from the builder that Go reads
# and needs. 