FROM debian:testing
MAINTAINER joseph@cauldrondevelopment.com

# Install prerequisites
RUN apt-get update && \
  apt-get install -y --no-install-recommends less debian-keyring \
    debian-archive-keyring ca-certificates nodejs nodejs-legacy npm \
    build-essential git && rm -rf /var/lib/apt/lists/*;

# LaserWeb
RUN git clone --depth=1 https://github.com/openhardwarecoza/LaserWeb.git
RUN cd LaserWeb && npm install && npm cache clean --force;

# Container config
EXPOSE 8000
WORKDIR /LaserWeb
ENTRYPOINT nodejs server.js
