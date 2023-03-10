FROM debian:testing

MAINTAINER Miguel Arroyo miguel@cs.columbia.edu version: 0.1

#RUN echo "deb http://emdebian.org/tools/debian/ testing main" >> /etc/apt/sources.list

RUN dpkg --add-architecture arm64 && apt-get update && apt-get install --no-install-recommends -y \
build-essential:amd64 \
lsb-release:amd64 \
git:amd64 \
gdb:amd64 \
gosu:amd64 \
wget:amd64 \
libc6-dbg:amd64 \
libncurses5:amd64 \
libpython2.7:amd64 \
qemu-user-static:amd64 \
libcapstone-dev:arm64 \
libreadline-dev:arm64 \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#Install Linaro Cross Compile Toolchain
RUN cd / && \
wget https://releases.linaro.org/components/toolchain/binaries/latest/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz && \
tar xvf gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz && rm gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz

RUN mkdir -p /eg-deps && cp -r /usr/include/capstone /eg-deps && cp -r /usr/lib/libcapstone.* /eg-deps

CMD ["/bin/bash"]
