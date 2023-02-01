FROM debian:11

RUN apt-get update && \
  apt-get install --no-install-recommends -y qemu-system-aarch64 qemu-efi-aarch64 lbzip2 sudo dnsmasq gnupg2 git curl iptables && rm -rf /var/lib/apt/lists/*;
