# The MIT License (MIT)
#
# Copyright 2019 Shift Cryptosecurity AG
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
# OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# Run with Docker:
# docker build --tag shift/mcu-base -f Dockerfile.dev .
#

FROM debian:stretch

RUN apt update && apt-get install --no-install-recommends -y cmake git wget locales python python-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir ~/Downloads && cd ~/Downloads && wget -O gcc.tar.bz2 https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2
RUN cd ~/Downloads && tar -xjvf gcc.tar.bz2 && rm gcc.tar.bz2
RUN cd ~/Downloads && rsync -a gcc-arm-none-eabi-8-2019-q3-update/ /usr/local/
RUN apt install --no-install-recommends -y libbz2-1.0 libncurses5 libz1 valgrind astyle clang libudev-dev python-urllib3 libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libbz2-dev libbz2-dev libbz2-1.0 libncurses5 libz1 valgrind astyle clang libudev-dev python-urllib3 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --prefix /usr/local cpp-coveralls
RUN locale-gen UTF-8
ENV CC gcc

CMD ["bash"]
