FROM ubuntu:bionic

RUN dpkg --add-architecture i386

# add repositories cache
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    doxygen \
    parallel \
    mingw-w64 \
    wine64 \
    wine32 \
    lcov \
    python3-dev \
    python3-pip \
    gcc-multilib && rm -rf /var/lib/apt/lists/*; # install packages













RUN pip3 install --no-cache-dir cffi autopep8

CMD ["/bin/bash"]
