FROM ubuntu:xenial

run apt-get update && apt-get install --no-install-recommends build-essential gcc-multilib xinetd -y && rm -rf /var/lib/apt/lists/*;
run apt-get clean

# Add files to container
WORKDIR /opt/
ADD flag /
ADD nodes.service /etc/xinetd.d/nodes
ADD nodes /opt/nodes

# Make and run
run echo "nodes 4321/tcp" >> /etc/services
EXPOSE 4321

CMD ["xinetd", "-dontfork"]
