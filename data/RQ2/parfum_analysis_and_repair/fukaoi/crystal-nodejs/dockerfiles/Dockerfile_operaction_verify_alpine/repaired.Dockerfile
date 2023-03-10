FROM crystallang/crystal:0.35.1-alpine as builder

RUN apk add --update --no-cache \
    curl \
    make \
    python \
    g++ \ 
    gcc \
    gcc-doc \
    linux-headers \
    libc6-compat

# optional:need install that to run spec/  
RUN apk add --no-cache \
    libtool \
    automake \
    autoconf

RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
RUN git clone https://github.com/fukaoi/crystal-nodejs.git

WORKDIR /crystal-nodejs

RUN shards install

# No need this 'make'  code if call  from  your shard.yml, 
# because exectute 'make' in postinstall  
RUN make

RUN crystal spec