FROM ubuntu:14.04
RUN apt-get update && apt-get -y --no-install-recommends install libssl-dev curl build-essential libjansson-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://www.aerospike.com/download/client/c/3.1.24/artifact/ubuntu12 > aerospike-client-c.tgz
RUN tar xzf aerospike-client-c.tgz && rm aerospike-client-c.tgz
RUN dpkg -i aerospike-client-c-3.1.24.ubuntu12.04.x86_64/aerospike-client-c-devel-3.1.24.ubuntu12.04.x86_64.deb
ENV CFLAGS -std=gnu99
ADD . /code
WORKDIR /code
RUN make
ENTRYPOINT ["/code/OBJS/yelp_load"]