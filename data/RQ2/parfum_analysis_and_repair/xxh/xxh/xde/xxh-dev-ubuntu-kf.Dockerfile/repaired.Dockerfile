FROM xxh/xxh-dev-ubuntu-k
# https://github.com/rastasheep/ubuntu-sshd

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y fuse rsync && rm -rf /var/lib/apt/lists/*;

