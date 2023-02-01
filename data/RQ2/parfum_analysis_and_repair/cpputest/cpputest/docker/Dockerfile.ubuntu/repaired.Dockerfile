FROM ubuntu

RUN apt-get update && \
    apt-get install -y -q --no-install-recommends file git gcc g++ make automake autoconf libtool && rm -rf /var/lib/apt/lists/*;

WORKDIR /cpputest_build

CMD autoreconf -i ../cpputest && ../cpputest/configure && make tdd
