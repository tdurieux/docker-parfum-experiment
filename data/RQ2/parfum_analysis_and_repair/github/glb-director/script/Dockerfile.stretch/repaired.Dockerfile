FROM debian:stretch

RUN echo 'deb http://ftp.debian.org/debian stretch-backports main' >>/etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install curl git && rm -rf /var/lib/apt/lists/*;

# DPDK
RUN curl -f -s https://packagecloud.io/install/repositories/github/unofficial-dpdk-stable/script.deb.sh | bash
RUN apt-get update && apt-get install --no-install-recommends -y build-essential dpdk dpdk-dev wget pkg-config libjansson-dev libsystemd-dev && rm -rf /var/lib/apt/lists/*;

# iptables / DKMS
RUN apt-get update && apt-get install --no-install-recommends -y iptables-dev dkms debhelper libxtables-dev && rm -rf /var/lib/apt/lists/*;

# golang
RUN wget --quiet https://golang.org/dl/go1.14.8.linux-amd64.tar.gz -O- | tar -C /usr/local -zxvf -
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"

# fpm for packaging
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev rubygems build-essential && rm -rf /var/lib/apt/lists/*;
# pin fpm 1.11.0 until https://github.com/jordansissel/fpm/pull/1752 is fixed
RUN gem install --no-ri --no-rdoc rake fpm:1.11.0

# patch DKMS for source package generation https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=832558
ADD helpers/dkms.diff /root/dkms.diff
RUN patch -d /usr/sbin </root/dkms.diff

# XDP
# linux-libc-dev must be upgraded to get a bpf.h that matches what we use. the rest match what we do in Vagrant for testing.
RUN apt-get update && apt install --no-install-recommends -y apt-transport-https curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt install --no-install-recommends -y -t stretch-backports linux-image-4.19.0-0.bpo.9-amd64-unsigned linux-headers-amd64 iproute2 libbpf-dev linux-libc-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && sudo ./llvm.sh 10
ENV KVER 4.19.0-0.bpo.9-amd64