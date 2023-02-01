FROM ubuntu:trusty

RUN apt-get upgrade -yq
RUN sudo rm /var/lib/apt/lists/* -rvf
RUN sudo apt-get update -y
RUN apt-get install --no-install-recommends -yq \
    curl \
    git \
    vim \
    build-essential && rm -rf /var/lib/apt/lists/*;

# Install vimified
RUN curl -f -L https://raw.githubusercontent.com/hanqin/vimified/master/install.sh | sh

# Install git-extras
RUN curl -f -sSL https://git.io/git-extras-setup | sudo bash /dev/stdin

# Install alias
RUN curl -f -L https://raw.githubusercontent.com/hanqin/git-alias/master/install.sh | sh

# Credential store
RUN git config --global credential.helper cache
RUN git config --global credential.helper 'cache --timeout=3600'
