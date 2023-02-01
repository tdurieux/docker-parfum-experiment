FROM buildpack-deps:bionic

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt update
RUN apt install -y cmake make
RUN apt install -y mingw-w64 unzip
COPY ./cmake/toolchain-mingw64.cmake /
RUN curl -L -o /tmp/libev-v1.23.0.tar.gz https://github.com/libuv/libuv/archive/v1.23.0.tar.gz
RUN tar xvf /tmp/libev-v1.23.0.tar.gz -C /tmp
# I can't `make install` by using cmake, so ...
# RUN cd /tmp/libuv-1.23.0/build \
#     && cmake -DCMAKE_TOOLCHAIN_FILE=/toolchain-mingw64.cmake -DCMAKE_INSTALL_PREFIX=/usr/x86_64-w64-mingw32/ ..
ENV HOST=x86_64-w64-mingw32
ENV TARGET=x86_64-w64-mingw32
ENV PREFIX=/usr/x86_64-w64-mingw32/
RUN cd /tmp/libuv-1.23.0 \
    && ./autogen.sh \
    && ./configure --host=$HOST --target=$TARGET --prefix=$PREFIX --disable-shared --enable-static \
    && make -j$(nproc) \
    && make install
