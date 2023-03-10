# This is meant to be used to create a Docker-based development environment such
# that you can compile inside this container but edit files outside.
#
# Use `make env` to activate this environment.
FROM ubuntu:18.04

# We need these user IDs and group IDs in order to give the same permissions to
# the user inside the container as outside.
ARG USER_ID=1000
ARG GROUP_ID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && apt-get install --no-install-recommends -y \
    clang++-6.0 \
    clang-6.0 \
    clang-format-6.0 \
    clang-tidy-6.0 \
    cpio \
    fuse \
    git \
    less \
    libacl1-dev \
    libarchive-dev \
    libbz2-dev \
    libfuse-dev \
    liblz4-dev \
    liblzma-dev \
    liblzo2-dev \
    libseccomp-dev \
    libssl-dev \
    libxml2-dev \
    lld-6.0 \
    lldb-6.0 \
    make \
    nettle-dev \
    openssh-server \
    pkg-config \
    python3 \
    software-properties-common \
    strace \
    sudo \
    valgrind && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 60 \
    --slave /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 \
    --slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-6.0 \
    --slave /usr/bin/lldb lldb /usr/bin/lldb-6.0 \
    --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-6.0 \
    --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-6.0

RUN groupadd --force --gid ${GROUP_ID} dev && \
    useradd --shell /bin/bash --create-home --uid=${USER_ID} -G sudo --gid ${GROUP_ID} dev

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dev

RUN echo 'export PS1="dev-env:\w \[\033[1;36m\]$ \[\033[0m\]"' >> /home/dev/.bashrc

WORKDIR /code
