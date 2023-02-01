# Dockerfile for grumpycoders/pcsx-redux-code-server

FROM codercom/code-server:3.4.0

USER root

# The tzdata package isn't docker-friendly, and something pulls it.
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/GMT

RUN apt update

# Utility packages
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Clang setup
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main"
RUN apt update

# Compilers & base libraries
RUN apt install --no-install-recommends -y clang-10 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y g++-8 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y g++-mipsel-linux-gnu && rm -rf /var/lib/apt/lists/*;

# Development packages
RUN apt install --no-install-recommends -y libavcodec-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libavformat-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libavutil-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglfw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libsdl2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libswresample-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libuv1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

USER coder

ENV CC clang-10
ENV CXX clang++-10
ENV LD clang++-10
