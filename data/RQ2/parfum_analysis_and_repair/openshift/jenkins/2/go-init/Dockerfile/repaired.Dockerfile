###########################################
# Stage 1: Build go-init
###########################################

FROM openshift/origin-release:golang-1.12 AS builder
COPY ./ /go/src/go-init 
RUN go install go-init

###########################################
# Stage 2: ubi-minimal image with go-init
###########################################