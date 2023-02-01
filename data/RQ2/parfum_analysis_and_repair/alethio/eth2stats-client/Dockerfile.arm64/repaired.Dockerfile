# build for arm64
FROM arm64v8/ubuntu AS build
COPY qemu-aarch64-static /usr/bin

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git golang make && rm -rf /var/lib/apt/lists/*

ENV ROOT "/tmp/eth2stats-client"

WORKDIR $ROOT

ADD go.mod go.mod
ADD go.sum go.sum

ADD . .

RUN make build

# create application container for arm64
FROM arm64v8/ubuntu
COPY qemu-aarch64-static /usr/bin

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY --from=build /tmp/eth2stats-client/eth2stats-client .

ENTRYPOINT ["/eth2stats-client"]