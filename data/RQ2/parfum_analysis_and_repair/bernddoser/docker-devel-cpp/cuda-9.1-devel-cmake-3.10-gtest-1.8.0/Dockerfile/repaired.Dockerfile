FROM bernddoser/docker-devel-cpp:cuda-9.1-devel-cmake-3.10

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

WORKDIR /tmp

RUN wget https://github.com/google/googletest/archive/release-1.8.0.tar.gz \
 && tar xf release-1.8.0.tar.gz \
 && rm release-1.8.0.tar.gz \
 && cd googletest-release-1.8.0 \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/googletest-1.8.0 .. \
 && make -j \
 && make install \
 && rm -r /tmp/googletest-release-1.8.0

WORKDIR /

ENV GTEST_ROOT /opt/googletest-1.8.0