FROM golang:1.15.15-buster as builder

ARG cmd
ARG branch
ARG commit
ARG release=development
ENV bin=/usr/local/bin/$cmd
ENV GOOS=linux

WORKDIR /usr/src
COPY . ./

# build the executable
RUN go build -tags 'osusergo netgo' -o ${bin} \
-ldflags "-X purelb.io/internal/logging.release=${release} -X purelb.io/internal/logging.commit=${commit} -X purelb.io/internal/logging.branch=${branch}" \
./cmd/${cmd}/

FROM registry.access.redhat.com/ubi8-minimal:8.5 as runtime
ARG cmd
ARG branch
ARG commit
ENV bin=/usr/local/bin/$cmd

LABEL branch=${branch}
LABEL commit=${commit}
LABEL command=${cmd}

COPY --from=builder ${bin} ${bin}

# The softlink is because variable interpolation happens at run-time
# so if you have variables in the entrypoint string they won't get
# resolved to their values.  This lets us have a hard-coded entrypoint
# string that links to the image-specific command.
RUN ln -s ${bin} /usr/local/bin/cmd
ENTRYPOINT ["/usr/local/bin/cmd"]