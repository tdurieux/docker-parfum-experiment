FROM dockcross/linux-arm64-musl:latest AS builder-from-amd64-to-arm64v8

# Install Go
RUN curl -f https://go.dev/dl/go1.17.6.linux-amd64.tar.gz -Lo ./go.linux-amd64.tar.gz \
 && curl -f https://go.dev/dl/go1.17.6.linux-amd64.tar.gz.asc -Lo ./go.linux-amd64.tar.gz.asc \
 && curl -f https://dl.google.com/dl/linux/linux_signing_key.pub -Lo linux_signing_key.pub \
 && gpg --batch --import linux_signing_key.pub && gpg --batch --verify ./go.linux-amd64.tar.gz.asc ./go.linux-amd64.tar.gz \
 && rm -rf /usr/local/go && tar -C /usr/local -xzf go.linux-amd64.tar.gz && rm go.linux-amd64.tar.gz
ENV PATH "$PATH:/usr/local/go/bin"

# Compile libpcap from source
RUN curl -f https://www.tcpdump.org/release/libpcap-1.10.1.tar.gz -Lo ./libpcap.tar.gz \
 && curl -f https://www.tcpdump.org/release/libpcap-1.10.1.tar.gz.sig -Lo ./libpcap.tar.gz.sig \
 && curl -f https://www.tcpdump.org/release/signing-key.asc -Lo ./signing-key.asc \
 && gpg --batch --import signing-key.asc && gpg --batch --verify libpcap.tar.gz.sig libpcap.tar.gz \
 && tar -xzf libpcap.tar.gz && mv ./libpcap-* ./libpcap && rm libpcap.tar.gz
WORKDIR /work/libpcap
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=arm && make \
 && cp /work/libpcap/libpcap.a /usr/xcc/aarch64-linux-musl-cross/lib/gcc/aarch64-linux-musl/*/
WORKDIR /work

# Build and install Capstone from source
RUN curl -f https://github.com/capstone-engine/capstone/releases/download/5.0-rc2/capstone-5.0-rc2.tar.xz -Lo ./capstone.tar.xz \
 && tar -xf capstone.tar.xz && mv ./capstone-* ./capstone && rm capstone.tar.xz
WORKDIR /work/capstone
RUN CAPSTONE_ARCHS="aarch64" CAPSTONE_STATIC=yes ./make.sh \
&& cp /work/capstone/libcapstone.a /usr/xcc/aarch64-linux-musl-cross/lib/gcc/aarch64-linux-musl/*/

# Install eBPF related dependencies
RUN apt-get -y --no-install-recommends install clang llvm libbpf-dev && rm -rf /var/lib/apt/lists/*;
