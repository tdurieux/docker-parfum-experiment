###########################################################################
# Example Dockerfile for smuggler concourse resource.

#
# Build concourse smuggler
#
FROM golang:1.9-alpine

ARG SMUGGLER_GIT_URL=https://github.com/redfactorlabs/concourse-smuggler-resource
ARG SMUGGLER_GIT_BRANCH=master

RUN apk add -U git bash && rm -rf /var/cache/apk/*

# Clone the right repo and branch
RUN mkdir -p /go/src/github.com/redfactorlabs/concourse-smuggler-resource && \
    git clone ${SMUGGLER_GIT_URL} /go/src/github.com/redfactorlabs/concourse-smuggler-resource && \
    cd /go/src/github.com/redfactorlabs/concourse-smuggler-resource && \
    git checkout $SMUGGLER_GIT_BRANCH

RUN cd /go/src/github.com/redfactorlabs/concourse-smuggler-resource && \
    go test $(go list ./... | grep -v vendor) -v && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
        go build -o /go/bin/concourse-smuggler-resource \
        github.com/redfactorlabs/concourse-smuggler-resource

#
# Build the resource image
#

# Use your favorite base image
FROM alpine:3.6

# Add some stuff to your container
# Our base container will have some handy tooling
ARG INSTALLED_PACKAGES="\
    bash                \
    zip                 \
    curl                \
    wget                \
    openssl             \
    ca-certificates     \
    jq                  \
    git                 \
    openssh-client      \
"
RUN apk add --update ${INSTALLED_PACKAGES} \
    && rm -rf /var/cache/apk/*

# Add the smuggler binary compiled previously
COPY --from=0 /go/bin/concourse-smuggler-resource /opt/resource/smuggler

# Link it to the /opt/resource{check,in,out} commands
RUN ln /opt/resource/smuggler /opt/resource/check \
    && ln /opt/resource/smuggler /opt/resource/in \
    && ln /opt/resource/smuggler /opt/resource/out

# Add a example default configuration of the commands
ADD example-smuggler.yml /opt/resource/smuggler.yml
