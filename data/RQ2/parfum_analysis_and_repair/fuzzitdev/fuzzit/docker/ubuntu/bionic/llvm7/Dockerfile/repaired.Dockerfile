FROM ubuntu:bionic

LABEL maintainer="Fuzzit.dev, inc."

RUN apt-get -qqy update && apt-get install --no-install-recommends -y wget gnupg2 unzip && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" >> /etc/apt/sources.list
RUN echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" >> /etc/apt/sources.list
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
RUN apt update && apt-get install --no-install-recommends -y libllvm-7-ocaml-dev libllvm7 llvm-7 llvm-7-dev llvm-7-doc llvm-7-examples llvm-7-runtime && rm -rf /var/lib/apt/lists/*;
RUN apt update && apt-get install --no-install-recommends -y clang-7 clang-tools-7 clang-7-doc libclang-common-7-dev libclang-7-dev libclang1-7 clang-format-7 python-clang-7 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/lib/llvm-7/bin/llvm-symbolizer /bin/llvm-symbolizer
