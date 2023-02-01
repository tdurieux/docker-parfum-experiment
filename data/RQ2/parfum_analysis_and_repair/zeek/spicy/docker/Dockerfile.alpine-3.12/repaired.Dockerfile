FROM alpine:3.12

WORKDIR /root

RUN apk update

# Install development tools.
RUN apk add --no-cache ccache cmake curl g++ gcc gdb git make ninja python3 vim linux-headers openssl-dev zlib-dev

# Install Spicy dependencies.
RUN apk add --no-cache bash bison flex flex-dev flex-libs libucontext-dev py3-pip py3-sphinx py3-sphinx_rtd_theme doxygen
RUN pip3 install --no-cache-dir "btest>=0.66"

WORKDIR /root
