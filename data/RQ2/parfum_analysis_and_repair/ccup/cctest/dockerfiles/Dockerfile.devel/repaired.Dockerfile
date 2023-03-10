FROM ubuntu:18.04 as base_build

LABEL maintainer=liu.guangcong@aliyun.com

# apt source
RUN sed -i s@/archive.ubuntu.com/@/mirrors.163.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update

# basic packages
RUN apt-get install -y --no-install-recommends \
        pkg-config \
        automake \
        build-essential \
        ca-certificates \
        wget \
        zip \
        zlib1g-dev \
        unzip \
        python \
        zsh \
        vim \
        git \
        curl \
        openssh-server \
        cmake && rm -rf /var/lib/apt/lists/*;

# oh my zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# bazel
ENV BAZEL_VERSION 0.28.1
ENV BAZEL_NAME bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -f -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -SL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh --progress && \
    curl -f -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -SL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# google test
WORKDIR /

RUN git clone https://github.com/google/googletest.git && \
    cd googletest && mkdir build && cd build && \
    cmake -Dgtest_disable_pthreads=on .. && make && make install && \
    sudo ldconfig && rm -rf /googletest


# xunit cctest
WORKDIR /

RUN git clone https://github.com/wisdomcoda/cctest.git && \
    cd cctest && mkdir build && cd build && \
    cmake .. && make && make install && \
    sudo ldconfig && rm -rf /cctest

# vim
WORKDIR /

RUN rm -rf /root/.vim && \
    git clone https://github.com/horance-liu/vim-plugins.git /root/.vim && \
    cd /root/.vim && mv .vimrc /root

# others
# RUN apt-get install -y --no-install-recommends \
#   others

# clean all
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["/bin/zsh"]

