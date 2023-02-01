FROM ubuntu

ARG DEBIAN_FRONTEND=nointeractive
ENV TZ=Asia/Shanghai

RUN sed -i s@/archive.ubuntu.com/@/mirrors.cloud.tencent.com/@g /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y \
        zsh git git-lfs \
        m4 libtool ninja-build cmake \
        python python3 gcc g++ nasm \
        clang clang-tidy clang-format \
        default-jdk golang \
        man zip zlib1g-dev lzip \
        curl wget \
        vim && rm -rf /var/lib/apt/lists/*;

#nodejs npm golang rustc default-jdk php subversion ruby clang-format clang-tidy \
# curl -s https://get.sdkman.io | bash sdk install kotlin

RUN apt-get install --no-install-recommends -y \
        asciinema && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        ccache distcc && rm -rf /var/lib/apt/lists/*;

COPY .bashrc /root/.bashrc
COPY .inputrc /root/.inputrc
COPY .vimrc /root/.vimrc

CMD ["/bin/bash"]

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && \
    pip install --no-cache-dir coverage

RUN pip install --no-cache-dir pex
RUN apt-get install --no-install-recommends -y maven scala && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;
