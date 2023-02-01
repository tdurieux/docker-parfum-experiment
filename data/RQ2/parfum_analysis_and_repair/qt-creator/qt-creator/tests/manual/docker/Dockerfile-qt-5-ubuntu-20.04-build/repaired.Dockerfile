FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y gpg wget software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --batch --dearmor - \
    | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

RUN apt-add-repository -y 'deb https://apt.kitware.com/ubuntu/ focal main'

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    git \
    openssh-client \
    sudo \
    vim \
    cmake \
    qtbase5-dev \
    qtdeclarative5-dev \
    qtquickcontrols2-5-dev \
    qtdeclarative5-dev-tools \
    libqt5core5a \
    libqt5widgets5 \
    libqt5quick5 \
    libqt5quickcontrols2-5 \
    qt5-qmake \
    g++ \
    gdb \
    ninja-build \
    nim \
    linux-tools-common \
    valgrind \
    x11-apps \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# && rm -rf /var/lib/apt/lists/*
