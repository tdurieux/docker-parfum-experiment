FROM alpine:3.7
# Update Packages
RUN apk update
# Tools
RUN apk add --no-cache make g++
RUN apk add --no-cache git cmake
# Libs
RUN apk add --no-cache curl-dev
# Install libubox
RUN apk add --no-cache lua-dev lua json-c-dev
RUN git clone git://git.openwrt.org/project/libubox.git
RUN cd libubox && git checkout 6eff829d788b36939325557066f58aafd6a05321 . && cmake . && make && make install
# Create and Set WORKDIR
RUN mkdir -p "c/code.ceptro.br/simet2/tcp-client-c"
WORKDIR c/code.ceptro.br/simet2/tcp-client-c