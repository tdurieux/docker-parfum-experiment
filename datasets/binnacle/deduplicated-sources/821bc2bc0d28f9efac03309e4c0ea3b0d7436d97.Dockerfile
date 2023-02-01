FROM ubuntu:artful

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update -q && apt-get install -y xz-utils fontconfig ca-certificates

# add url2img binary
WORKDIR /
ADD https://github.com/gen2brain/url2img/releases/download/1.3/url2img-1.3.tar.xz /
RUN tar xf url2img-1.3.tar.xz

# add entrypoint
ADD docker-entrypoint.sh /

# start daemon
CMD ["/docker-entrypoint.sh"]
