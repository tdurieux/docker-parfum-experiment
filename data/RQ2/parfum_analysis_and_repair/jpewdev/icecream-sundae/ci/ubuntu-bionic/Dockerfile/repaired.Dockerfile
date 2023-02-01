FROM ubuntu:bionic

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    clang \
    g++ \
    libcap-ng-dev \
    libglib2.0-dev \
    libicecc-dev \
    liblzo2-dev \
    libncursesw5-dev \
    meson \
    ninja-build && rm -rf /var/lib/apt/lists/*;

# For coveralls
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        git-core \
        lcov \
        python-pip && \
    pip install --no-cache-dir --user cpp-coveralls && rm -rf /var/lib/apt/lists/*;
ENV PATH ~/.local/bin:$PATH

RUN mkdir -p /root/icecream-sundae/builddir
COPY . /root/icecream-sundae/
WORKDIR /root/icecream-sundae/builddir/

