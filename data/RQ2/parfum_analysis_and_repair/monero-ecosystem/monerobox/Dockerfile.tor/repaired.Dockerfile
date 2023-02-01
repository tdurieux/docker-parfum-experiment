# specify the base image
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install --no-install-recommends -y tor && rm -rf /var/lib/apt/lists/*;

# Create app directory
WORKDIR /usr/src/app

ENTRYPOINT ["tor", "-f", "/settings/tor.conf"]
