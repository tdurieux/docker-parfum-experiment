FROM ubuntu:bionic

RUN apt update
RUN apt install --no-install-recommends -y gnupg2 curl apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
RUN curl -f -sL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" > /etc/apt/sources.list.d/llvm.list
RUN apt-get update
RUN apt install --no-install-recommends -y crystal libclang-7-dev clang-7 && rm -rf /var/lib/apt/lists/*;
COPY bin/libclang.so.gz /tmp/libclang.so.gz
RUN gzip -d /tmp/libclang.so.gz
RUN cp /tmp/libclang.so /usr/lib/x86_64-linux-gnu/libclang-7.so.1
RUN cp /tmp/libclang.so /usr/lib/libclang.so.7
