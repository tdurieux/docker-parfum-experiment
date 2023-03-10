FROM parm-lib-base:latest

#RUN apt-get install -y valgrind

RUN git clone https://github.com/dcrankshaw/redox.git \
    && cd redox \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install \
    && echo "/usr/local/lib64/" > /etc/ld.so.conf.d/redox.conf \
    && ldconfig -v \
    && cd ~

RUN git clone https://github.com/opencv/opencv.git \
    && cd opencv \
    && git checkout 3.4.1 \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. \
    && make -j7 \
    && make install \
    && echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf \
    && ldconfig -v \
    && cd ~

# vim: set filetype=dockerfile: