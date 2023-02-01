FROM ubuntu:18.04
LABEL maintainer="akhtyamovpavel@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y cmake build-essential vim tmux git wget automake libtool autopoint graphviz && rm -rf /var/lib/apt/lists/*;

RUN wget https://ftp.gnu.org/gnu/bison/bison-3.5.2.tar.gz && tar -zxvf bison-3.5.2.tar.gz && rm bison-3.5.2.tar.gz
RUN cd bison-3.5.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j9 && make install && cd ..

RUN apt-get install --no-install-recommends -y flex && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash ubuntu
USER ubuntu
WORKDIR /home/ubuntu
