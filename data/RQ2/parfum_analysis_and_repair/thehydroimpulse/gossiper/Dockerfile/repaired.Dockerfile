FROM rail44/rust
MAINTAINER Daniel Fagnan

RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/src
RUN cd /usr/local/src && \
    wget -O gossiper.tar.gz https://github.com/thehydroimpulse/gossiper/archive/master.tar.gz && \
    tar zxvf gossiper.tar.gz && \
    mv gossiper-master gossiper && \
    cd gossiper && rm gossiper.tar.gz

RUN cd /usr/local/src/gossiper && cargo build
CMD ./usr/local/src/gossiper/target/network
