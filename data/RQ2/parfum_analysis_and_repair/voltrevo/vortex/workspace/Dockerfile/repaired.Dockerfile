FROM ubuntu:18.04

RUN apt update

RUN printf "Australia\nSydney\n" | apt install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    zsh \
    tmux && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y \
    zip \
    g++ \
    zlib1g-dev \
    unzip \
    python && rm -rf /var/lib/apt/lists/*;

ADD ./docker-workspace-init.sh /tmp/.
RUN /tmp/docker-workspace-init.sh

ADD .vimrc /root/.vimrc
RUN vim +PlugInstall +qall

ADD .zshrc /root/.zshrc
