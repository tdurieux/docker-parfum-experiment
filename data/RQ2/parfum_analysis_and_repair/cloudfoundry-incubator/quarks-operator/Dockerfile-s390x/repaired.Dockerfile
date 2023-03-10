ARG quarkz_base_version="0.0.6"
ARG BASE_IMAGE=quarkz/cf-operator-base:$quarkz_base_version

FROM s390x/alpine AS dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_s390x /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

FROM s390x/golang:1.13.3 AS build
ARG GO111MODULE="on"
ENV GO111MODULE $GO111MODULE

WORKDIR /go/src/code.cloudfoundry.org/quarks-operator
# First, download dependencies so we can cache this layer
COPY go.mod .
COPY go.sum .
RUN if [ "${GO111MODULE}" = "on" ]; then go mod download; fi

# Copy the rest of the source code and build
COPY . .
RUN make build && \
    cp -p binaries/quarks-operator /usr/local/bin/quarks-operator

FROM $BASE_IMAGE
RUN groupadd -g 1000 vcap && \
    useradd -r -u 1000 -g vcap vcap
USER vcap
COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build /usr/local/bin/quarks-operator /usr/local/bin/quarks-operator
ENTRYPOINT ["/usr/bin/dumb-init", "--", "quarks-operator"]