FROM ubuntu:20.04
ENV PYTHONDONTWRITEBYTECODE true
ENV hts_version 1.11
ENV port_version 1.2.2
ENV dmd_version 2.0.6
ENV prod_version 2.6.3
WORKDIR /usr/local/src
RUN apt update && apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository universe && add-apt-repository multiverse && \
    add-apt-repository restricted && apt update && \
    apt install --no-install-recommends -y zlib1g-dev libboost-dev '^libboost-.*71-dev' build-essential automake autoconf curl \
     libbz2-dev libncurses-dev lzma-dev python3 python3-numpy python3-dev python3-scipy \
	python3-pandas python3-pip libtool liblzma-dev && \
    pip3 install --no-cache-dir wheel && pip3 install --no-cache-dir python-rapidjson && pip3 install --no-cache-dir "Mikado>=2.0" && \
    curl -f -L https://github.com/samtools/samtools/releases/download/${hts_version}/samtools-${hts_version}.tar.bz2 | tar xj && \
    cd samtools-${hts_version} && autoreconf && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j 10 && make install && \
    cd /usr/local/src && curl -f -L https://github.com/maplesond/portcullis/archive/${port_version}.tar.gz | tar -xz && \
    cd portcullis-${port_version} && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j 10 && make -j 10 check && make install && \
    mkdir -p /usr/local/src/ && cd /usr/local/src && \
    curl -f -L https://github.com/bbuchfink/diamond/releases/download/v${dmd_version}/diamond-linux64.tar.gz | tar -xz -C /usr/local/bin/ && \
    curl -f -L https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux > /usr/local/bin/prodigal && \
    chmod +x /usr/local/bin/prodigal && cd /usr/local/ && rm -rf src/* && rm -rf /var/lib/apt/lists/*;
WORKDIR /global
CMD ["mikado"]