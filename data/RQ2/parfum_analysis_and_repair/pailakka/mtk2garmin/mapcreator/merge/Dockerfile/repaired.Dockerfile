FROM ubuntu

WORKDIR /opt/mapmerge
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential curl zlib1g-dev python3 parallel && rm -rf /var/lib/apt/lists/*;

RUN curl --fail --retry 5 --retry-delay 30 https://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert && \
    curl --fail --retry 5 --retry-delay 30 https://m.m.i24.cc/osmfilter.c | cc -x c - -O3 -o osmfilter && \
    chmod +x osmconvert && \
    chmod +x osmfilter

ADD . .
RUN chmod +x merge_files.sh && chmod +x process_osm.sh

