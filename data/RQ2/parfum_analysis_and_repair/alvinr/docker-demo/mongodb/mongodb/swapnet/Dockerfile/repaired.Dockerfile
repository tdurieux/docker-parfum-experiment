FROM ubuntu:latest

# make sure we have curl
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# add machine
RUN curl -f -L https://github.com/docker/machine/releases/download/v0.4.0-rc1/docker-machine_linux-amd64 > docker-machine
RUN mv docker-machine /usr/bin/docker-machine
RUN chmod +x /usr/bin/docker-machine
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
VOLUME /etc/docker

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]