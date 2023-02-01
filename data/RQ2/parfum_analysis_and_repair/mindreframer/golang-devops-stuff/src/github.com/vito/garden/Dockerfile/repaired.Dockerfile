FROM mischief/docker-golang
RUN apt-get -y --no-install-recommends install iptables quota rsync net-tools && rm -rf /var/lib/apt/lists/*;
ADD http://cfstacks.s3.amazonaws.com/lucid64.dev.tgz /opt/warden/rootfs
