FROM debian:stretch

LABEL maintainer="Fuzzit.dev, inc."

RUN apt-get -qqy update && apt-get install --no-install-recommends -y wget gnupg2 unzip && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" >> /etc/apt/sources.list
RUN echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" >> /etc/apt/sources.list
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y libllvm-8-ocaml-dev libllvm8 llvm-8 llvm-8-dev llvm-8-doc llvm-8-examples llvm-8-runtime && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/lib/llvm-8/bin/llvm-symbolizer /bin/llvm-symbolizer

WORKDIR /app
