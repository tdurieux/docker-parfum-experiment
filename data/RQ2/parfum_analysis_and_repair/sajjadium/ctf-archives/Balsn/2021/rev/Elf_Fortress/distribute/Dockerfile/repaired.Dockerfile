FROM ubuntu:latest
MAINTAINER James

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends xinetd qemu-system-x86 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m ElfFortress

CMD ["/usr/sbin/xinetd","-dontfork"]
