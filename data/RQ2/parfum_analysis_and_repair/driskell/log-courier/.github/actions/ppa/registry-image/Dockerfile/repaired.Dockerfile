FROM ubuntu:focal
RUN apt -qy update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qy install git devscripts debhelper sbuild ubuntu-dev-tools golang ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
