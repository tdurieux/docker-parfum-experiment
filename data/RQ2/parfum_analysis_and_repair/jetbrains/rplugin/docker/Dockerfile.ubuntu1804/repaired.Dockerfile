FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y curl gnupg apt-transport-https ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu bionic main" >> /etc/apt/sources.list
RUN curl -f https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F
RUN apt-get update
RUN apt-get -y install g++-7 clang-9 clang-tools-9 --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/cc cc   /usr/bin/clang-9  50
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-9  50
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 50
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 50
# install R dependencies
RUN apt-get -y --no-install-recommends install libxml2-dev libssl-dev libcairo2-dev patch curl libcurl4-gnutls-dev make gfortran git unzip libreadline-dev libicu-dev libpcre2-dev && rm -rf /var/lib/apt/lists/*;
# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]