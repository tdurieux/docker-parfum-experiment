FROM ubuntu:bionic


RUN apt-get update && apt-get -yy --no-install-recommends install wget curl gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN bash -c "curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add"
RUN add-apt-repository "deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic$LLVM_VERSION_STRING  main"
RUN apt-get update && apt-get install --no-install-recommends -y clang clang-format clang-tidy build-essential git && rm -rf /var/lib/apt/lists/*;

