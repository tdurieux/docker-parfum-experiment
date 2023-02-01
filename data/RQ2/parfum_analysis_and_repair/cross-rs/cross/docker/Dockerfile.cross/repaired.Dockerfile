FROM ubuntu:20.04 as rust
ARG DEBIAN_FRONTEND=noninteractive
COPY docker/lib.sh docker/cross.sh /
COPY ./ /project
RUN /cross.sh /project

# we build our images in 2 steps, to ensure we have a compact
# image, since we want to add our current subdirectory
FROM ubuntu:20.04
COPY --from=rust /root/.cargo /root/.cargo
COPY --from=rust /root/.rustup /root/.rustup

# need some basic devtools, and requirements for docker
RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
    ca-certificates \
    curl \
    git && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://get.docker.com | sh

ENV CROSS_CONTAINER_IN_CONTAINER=1 \
    PATH=/root/.cargo/bin:$PATH
