# Build and Install Heimdall in a stock Go builder container
FROM golang:1.16-alpine

# Install packages we need
RUN apk add --no-cache make gcc musl-dev linux-headers git

# create go src directory and clone heimdall
RUN mkdir -p /root/heimdall

# Grab UPSTREAM_VERSION from Build Args
ARG UPSTREAM_VERSION

# Clone hemidall release into folder
RUN git clone --branch ${UPSTREAM_VERSION} https://github.com/maticnetwork/heimdall.git /root/heimdall

# change work directory
WORKDIR /root/heimdall

# GOBIN required for go install
ENV GOBIN $GOPATH/bin

# Make and Install Heimdall
RUN make install

# Set entrypoint