FROM  ubuntu:20.04 AS builder
RUN apt update && apt install -y --no-install-recommends\
    ca-certificates \ 
    git \ 
    gcc \ 
    make \ 
    python \ 
    libstdc++-10-dev \ 
    libcurl4-openssl-dev \ 
    zlib1g-dev \ 
    libbigwig-dev \ 
    libhts-dev \ 
    libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://github.com/Ensembl/WiggleTools.git
WORKDIR WiggleTools
RUN   make LIBS='-lwiggletools -lBigWig -lcurl -lz -lhts -lm -lgsl -lpthread'
RUN   make test

FROM ubuntu:20.04
RUN apt update && apt install -y --no-install-recommends \
    libbigwig0 \
    libhts3 \ 
    libgsl23 && rm -rf /var/lib/apt/lists/*;
COPY   --from=builder /WiggleTools/bin/wiggletools /usr/local/bin/
WORKDIR /mnt
ENTRYPOINT ["wiggletools"]
CMD ["--help"]

