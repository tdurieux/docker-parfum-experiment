FROM golang:latest AS gobuilder

# protobuf executables:

RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

ENV PROTOC_VERSION 3.20.1

# add protoc - pb release naming scheme is annoying
ENV ARCH="$(uname -m | sed 's/aarch64/aarch_64/g')"

RUN echo "Detected arch ${ARCH}"
RUN echo "Fetching from URL: https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-$(eval echo ${ARCH}).zip"
RUN curl -f -L -o /tmp/protobuf.zip https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-$(eval echo ${ARCH}).zip
WORKDIR /tmp/
RUN unzip protobuf.zip && cp /tmp/bin/protoc /opt && mv /tmp/include /opt

# Install protoc-gen-go
RUN go install github.com/golang/protobuf/protoc-gen-go@latest \
    && go install github.com/twitchtv/twirp/protoc-gen-twirp@latest

# migrate:

ENV MIGRATE_VERSION v4.15.2
ENV MIGRATE_ARCH="$(case ${ARCH} in \"aarch_64\") echo \"arm64\" ;; \"x86_64\") echo \"amd64\";; *) echo \"invalid architecture\" ;; esac;)"

RUN echo "Fetching from URL: https://github.com/golang-migrate/migrate/releases/download/${MIGRATE_VERSION}/migrate.linux-$(eval echo ${MIGRATE_ARCH}).tar.gz"

RUN curl -f -L https://github.com/golang-migrate/migrate/releases/download/${MIGRATE_VERSION}/migrate.linux-$(eval echo ${MIGRATE_ARCH}).tar.gz | tar xvz

RUN mv /tmp/migrate /opt

FROM node:latest

WORKDIR /opt
RUN npm install ts-protoc-gen && npm cache clean --force;

COPY --from=gobuilder /go/bin/protoc-gen-go /opt
COPY --from=gobuilder /go/bin/protoc-gen-twirp /opt
COPY --from=gobuilder /opt/protoc /opt
COPY --from=gobuilder /opt/include /opt/include
COPY --from=gobuilder /opt/migrate /opt

ENV PATH /opt:$PATH
ENV CODE_DIR /opt/code
WORKDIR /opt/code/liwords