FROM ubuntu
RUN apt update && apt -y --no-install-recommends install g++ git make libreadline-dev wget snapcraft snapd autoconf automake autopoint autotools-dev libltdl-dev libltdl7 libsigsegv2 libtool m4 vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/snaps/naken_asm/snap
ADD snapcraft.yaml /root/snaps/naken_asm/snap
ADD build.sh /root
RUN cd /root
RUN bash build.sh

