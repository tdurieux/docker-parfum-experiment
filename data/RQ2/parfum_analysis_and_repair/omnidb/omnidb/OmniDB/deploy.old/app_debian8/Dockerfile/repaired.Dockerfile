FROM debian:jessie-slim
MAINTAINER William Ivanski <william.ivanski@gmail.com>

USER root
ENV HOME /root
WORKDIR /root
SHELL ["/bin/bash", "-c"]

ENV PYTHON_VERSION=3.6.5

RUN apt-get update -y \
 && apt-get install --no-install-recommends -y git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils libgconf-2-4 gnome-core unzip \
 && git clone --depth 1 https://github.com/pyenv/pyenv.git ~/.pyenv \
 && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
 && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
 && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
 && source ~/.bashrc \
 && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install $PYTHON_VERSION \
 && pyenv global $PYTHON_VERSION \
 && curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY clone.sh $HOME/
