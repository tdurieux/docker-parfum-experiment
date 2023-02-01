FROM python:stretch

# Default cluster arguments. Override with "-e"
#
# total number of parties:
ENV N 8
# tolerance, usually N/4 in our experiments:
ENV t 2
# maximum number of transactions committed in a block:
ENV B 16

RUN apt-get update && apt-get -y --no-install-recommends install bison flex libgmp-dev libmpc-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz
RUN tar -xvf pbc-0.5.14.tar.gz && rm pbc-0.5.14.tar.gz
RUN cd pbc-0.5.14 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

ENV LIBRARY_PATH /usr/local/lib
ENV LD_LIBRARY_PATH /usr/local/lib

RUN git clone https://github.com/JHUISI/charm.git
RUN cd charm && ./configure.sh && make install

ENV SRC /usr/local/src/HoneyBadgerBFT
WORKDIR $SRC
ADD . $SRC/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -e .[dev]

# Run tests by default
CMD sh test.sh
