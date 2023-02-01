#
# Dockerfile for generating an official image
# (see Dockerfile.local if you want something
# faster for development)
#

FROM opensuse/leap:15.0 as builder

ARG BUILD_DIR="/go/src/github.com/kubic-project/registries-operator"

# Copy stuff to the image...
# (check the .dockerignore file for exclusions)
ADD . $BUILD_DIR

WORKDIR $BUILD_DIR
RUN zypper ar https://download.opensuse.org/repositories/devel:/languages:/go/openSUSE_Leap_15.0/devel:languages:go.repo
RUN zypper --non-interactive --no-gpg-checks ref
RUN zypper in -y make git go
RUN go version

ENV GOPATH="/go"
ENV GOBIN="/go/bin"
ENV PATH="/usr/bin:/bin:/usr/local/bin:/go/bin"

RUN mkdir -p $GOBIN
RUN make -C $BUILD_DIR clean
RUN make -C $BUILD_DIR all

####################
# final stage
####################
FROM opensuse/leap:15.0

ARG BUILD_DIR="/go/src/github.com/kubic-project/registries-operator"
ARG BUILT_EXE="cmd/registries-operator/registries-operator"

COPY --from=builder $BUILD_DIR/$BUILT_EXE /usr/local/bin/registries-operator
RUN                 chmod 755 /usr/local/bin/registries-operator

CMD ["/usr/local/bin/registries-operator"]
