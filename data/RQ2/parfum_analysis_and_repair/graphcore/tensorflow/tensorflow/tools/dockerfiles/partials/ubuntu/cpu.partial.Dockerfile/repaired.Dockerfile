FROM ubuntu:${UBUNTU_VERSION} as base

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
