FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -yqq \
    cmake wget bzip2

RUN apt-get update -qq && apt-get install -yqq \
    qt5-default \
    valgrind \
    xorg xvfb xauth xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

RUN apt-get update -qq && apt-get install -yqq \
    clang-3.9 lldb-3.9

ENV CXX=/usr/bin/clang++
ENV CC=/usr/bin/clang
RUN ln -s /usr/bin/clang-3.9 /usr/bin/clang
RUN ln -s /usr/bin/clang++-3.9 /usr/bin/clang++
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
ENV BOOST_ROOT=/usr/local
ADD util/build_prep/bootstrap_boost.sh bootstrap_boost.sh

RUN ./bootstrap_boost.sh -m -c

RUN rm bootstrap_boost.sh