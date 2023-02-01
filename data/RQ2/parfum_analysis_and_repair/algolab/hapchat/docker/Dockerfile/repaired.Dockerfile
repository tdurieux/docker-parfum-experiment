FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    coreutils \
    g++ \
    git-core \
    gosu \
    python3-biopython-sql \
    python3-dev \
    python3-networkx \
    samtools \
    snakemake \
    virtualenv \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

VOLUME ["/data"]

RUN git clone https://github.com/AlgoLab/HapCHAT.git && \
    cd HapCHAT && \
    ./setup.sh

COPY gosu.sh /usr/local/bin/gosu.sh
WORKDIR  "/HapCHAT/example"
ENTRYPOINT ["/usr/local/bin/gosu.sh"]
CMD ["/usr/bin/snakemake"]
