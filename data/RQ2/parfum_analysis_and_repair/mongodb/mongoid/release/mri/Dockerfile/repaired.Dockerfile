FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y --no-install-recommends install git ruby-bundler make gcc ruby-dev \
    libxml2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . .
