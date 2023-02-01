FROM golang:1.18.0-bullseye as build
COPY . /src/agent
WORKDIR /src/agent
ARG RELEASE_BUILD=false
ARG IMAGE_TAG

# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -t bullseye-backports -qy libsystemd-dev && rm -rf /var/lib/apt/lists/*;

# Add support for bcc bindings required to compile the eBPF integration
RUN apt-get update && apt-get install --no-install-recommends -qy libbpfcc-dev && rm -rf /var/lib/apt/lists/*;

RUN make clean && make IMAGE_TAG=${IMAGE_TAG} RELEASE_BUILD=${RELEASE_BUILD} BUILD_IN_CONTAINER=false agentctl

FROM debian:bullseye-slim

# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
# plus the libbpfcc library for running the eBPF integration.
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -t bullseye-backports -qy libsystemd-dev && \
  apt-get install --no-install-recommends -qy tzdata ca-certificates && \
  if [ `uname -m` = "x86_64" ]; then \
  apt-get install --no-install-recommends -qy libbpfcc; fi && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /src/agent/cmd/agentctl/agentctl /bin/agentctl

ENTRYPOINT ["/bin/agentctl"]
