FROM ubuntu:18.04

# Setup environment for roll_up

RUN apt-get update && \
    apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository ppa:ethereum/ethereum -y && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    wget unzip curl \
    build-essential cmake git libgmp3-dev libprocps-dev python-markdown libboost-all-dev libssl-dev pkg-config python3-pip solc && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/roll_up

COPY depends/roll_up .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN cd build \
    && cmake .. \
    && make \
    && DESTDIR=/usr/local make install \
        NO_PROCPS=1 \
        NO_GTEST=1 \
        NO_DOCS=1 \
        CURVE=ALT_BN128 \
        FEATUREFLAGS="-DBINARY_OUTPUT=1 -DMONTGOMERY_OUTPUT=1 -DNO_PT_COMPRESSION=1"

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

# Setup environment for thin rpyc server

WORKDIR /root/rpyc

COPY SparseMerkleTree.py requirements.txt classes.py main.py prover.py ./

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "main.py"]
