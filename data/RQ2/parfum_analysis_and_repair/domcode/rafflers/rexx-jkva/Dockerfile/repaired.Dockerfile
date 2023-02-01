FROM debian:stable

MAINTAINER job@jobva.nl

ENV LANG C.UTF-8

# Update deps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y regina-rexx && rm -rf /var/lib/apt/lists/*;

# Create working dir
RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

# Run raffler
CMD ["/var/app/raffler.rexx", "/var/names.txt"]
