FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        apt-transport-https \
        curl \
        git \
        language-pack-en \
        make \
        nodejs \
        npm \
        pandoc \
        pkg-config \
        python3 \
        python3-pip \
        software-properties-common \
        unzip \
        valgrind \
        xxd \
        autoconf \
        automake \
        dos2unix \
        pngcrush \
        nano \
        texinfo && rm -rf /var/lib/apt/lists/*;

# unprivileged user
RUN mkdir -p /code && \
    (groupadd -g $HOST_GID user || true) && \
    (useradd -r -u $HOST_UID -g $HOST_GID user || true) && \
    chown $HOST_UID:$HOST_GID /code && \
    mkdir -p /home/user && \
    chown $HOST_UID:$HOST_GID /home/user

# cpplint
RUN pip3 install --no-cache-dir cpplint

# doctoc
RUN npm install -g doctoc && npm cache clean --force;

# clang
RUN curl -f -L https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-10 main" && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y clang clang-format clang-tidy && rm -rf /var/lib/apt/lists/*;

# tmbasic dependencies
COPY libclipboard-CMakeLists.txt.diff /tmp/
COPY deps.mk /tmp/deps.mk
COPY deps.tar /tmp/
RUN mkdir -p /tmp/downloads && \
    tar xf /tmp/deps.tar -C /tmp/downloads && \
    mkdir -p /usr/local/$(uname -m)-linux-gnu/include && \
    mkdir -p /tmp/deps && \
    cd /tmp/deps && \
    export NATIVE_PREFIX=/usr && \
    export TARGET_PREFIX=/usr/local/$(uname -m)-linux-gnu \
    export ARCH=$ARCH \
    export LINUX_DISTRO=ubuntu \
    export LINUX_TRIPLE=$(uname -m)-linux-gnu \
    export TARGET_OS=linux \
    export DOWNLOAD_DIR=/tmp/downloads && \
    make -j$(nproc) -f /tmp/deps.mk && \
    rm -rf /tmp/deps /tmp/deps.mk && rm /tmp/deps.tar

# for the benefit of vscode, symlink /usr/local/target to /usr/local/ARCH-linux-gnu
RUN ln -s /usr/local/$(uname -m)-linux-gnu /usr/local/target

# environment
COPY devPrompt.sh /home/user/
RUN echo "export ARCH=\"$ARCH\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export IMAGE_NAME=\"$IMAGE_NAME\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export PS1=\"[$IMAGE_NAME] \w\$ \"" >> /etc/profile.d/tmbasic.sh && \
    echo "export MAKEFLAGS=\"-j$(nproc)\"" >> /etc/profile.d/tmbasic.sh && \
    echo "export TARGET_OS=linux" >> /etc/profile.d/tmbasic.sh && \
    echo "export LINUX_DISTRO=ubuntu" >> /etc/profile.d/tmbasic.sh && \
    echo "export LINUX_TRIPLE=$(uname -m)-linux-gnu" >> /etc/profile.d/tmbasic.sh && \
    echo "export PREFIX=/usr/local/$(uname -m)-linux-gnu" >> /etc/profile.d/tmbasic.sh && \
    echo "export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/usr/local/$(uname -m)-linux-gnu/lib" >> /etc/profile.d/tmbasic.sh && \
    echo "alias dev='/home/user/devPrompt.sh'" >> /etc/profile.d/tmbasic.sh && \
    echo "export TERM=xterm-256color" >> /etc/profile.d/tmbasic.sh && \
    echo "export EDITOR=\"nano -w\"" >> /etc/profile.d/tmbasic.sh && \
    echo "mkdir -p /code/bin/ghpages && cd /code/bin/ghpages && >/dev/null python3 -m http.server 5000 &" >> /etc/profile.d/tmbasic.sh && \
    echo "echo HTTP server running on port 5000." >> /etc/profile.d/tmbasic.sh && \
    echo "make -f /code/Makefile help" >> /etc/profile.d/tmbasic.sh && \
    chmod +x /etc/profile.d/tmbasic.sh

USER $HOST_UID
RUN git config --global user.name "$GIT_NAME" && \
    git config --global user.email "$GIT_EMAIL"
ENTRYPOINT ["/bin/bash", "-l"]
