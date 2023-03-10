FROM debian:buster

ARG user
RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN adduser ${user:-user} && \
    echo "${user:-user} ALL=(root) NOPASSWD:ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers
RUN mkdir -p /usr/local/src && chown root:user /usr/local/src && \
   chmod g+w /usr/local/src
USER ${user:-user}
RUN sudo mkdir -p /usr/lib/meta && sudo chown root:staff /usr/lib/meta && \
   sudo chmod g+w /usr/lib/meta
RUN sudo apt-get install --no-install-recommends -y git git build-essential libelf-dev libdw-dev binutils-dev \
       autoconf automake libtool pkg-config autoconf-archive \
       g++ ocaml ocamlbuild ocaml-findlib \
       default-jdk-headless python3 python3-distutils python \
       make gawk gdb wget \
       libunwind-dev libc6-dev-i386 zlib1g-dev libc6-dbg \
       libboost-iostreams-dev libboost-regex-dev libboost-serialization-dev libboost-filesystem-dev git && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/local/src && git clone https://github.com/stephenrkell/liballocs.git
RUN cd /usr/local/src/liballocs && \
   git submodule update --init --recursive && \
   make -C contrib -j4
RUN cd /usr/local/src/liballocs && \
   ./autogen.sh && \
   ( . contrib/env.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local) && \
   make -j4
RUN sudo mkdir -p /usr/lib/meta && sudo chown root:user /usr/lib/meta && \
   sudo chmod g+w /usr/lib/meta
RUN cd /usr/local/src/liballocs && \
   make -f tools/Makefile.meta /usr/lib/meta/lib/x86_64-linux-gnu/libc-2.28.so-meta.so
