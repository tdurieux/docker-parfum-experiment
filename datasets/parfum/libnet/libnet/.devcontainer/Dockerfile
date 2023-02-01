ARG VARIANT="ubuntu-20.04"
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

RUN apt-get update                                                      \
    && export DEBIAN_FRONTEND=noninteractive                            \
    && apt-get -y install --no-install-recommends                       \
        sudo                                                            \
        vim                                                             \
        make                                                            \
        autotools-dev                                                   \
        autoconf                                                        \
        automake                                                        \
        doxygen                                                         \
        perl                                                            \
        build-essential                                                 \
        gcc                                                             \
        clang                                                           \
        clangd-10                                                       \
        bear                                                            \
        libtool                                                         \
        net-tools                                                       \
        iproute2                                                        \
        indent                                                          \
        libcmocka-dev                                                   \
        cscope                                                          \
        clangd-10                                                       \
        clang-format-10                                                 \
        python3-pip                                                     \
        indent                                                          \
    && rm -rf /var/lib/apt/lists/*
