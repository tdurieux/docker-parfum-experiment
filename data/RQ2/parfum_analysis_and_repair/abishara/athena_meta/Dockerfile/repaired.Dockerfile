FROM ubuntu:16.04

RUN apt-get update

RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python2.7 && ln -s /usr/bin/python2.7 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install autotools-dev \
     && apt-get -y --no-install-recommends install automake \
     && apt-get -y --no-install-recommends install autoconf && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install ncurses-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/abishara/idba/archive/1.1.3a1.tar.gz \
     && tar -xf 1.1.3a1.tar.gz \
     && cd idba-1.1.3a1 \
     && ./build.sh \
     && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
     && make \
     && mv bin/idba_subasm /bin && rm 1.1.3a1.tar.gz

RUN wget https://github.com/lh3/bwa/releases/download/v0.7.15/bwa-0.7.15.tar.bz2 \
     && tar -xf bwa-0.7.15.tar.bz2 \
     && cd bwa-0.7.15 \
     && make \
     && mv bwa /bin && rm bwa-0.7.15.tar.bz2

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 \
     && tar -xf samtools-1.3.1.tar.bz2 \
     && cd samtools-1.3.1 \
     && make install && rm samtools-1.3.1.tar.bz2

RUN wget https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 \
     && tar -xf htslib-1.3.2.tar.bz2 \
     && cd htslib-1.3.2 \
     && make install && rm htslib-1.3.2.tar.bz2

RUN wget https://github.com/fenderglass/Flye/archive/2.3.1.tar.gz \
     && tar -xf 2.3.1.tar.gz \
     && cd Flye-2.3.1 \
     && python setup.py build \
     && ln -s $(readlink -f bin/flye) /bin/flye && rm 2.3.1.tar.gz

RUN apt-get -y --no-install-recommends install python-pip && pip install --no-cache-dir pip==9.0.2 && rm -rf /var/lib/apt/lists/*;

RUN mkdir athena_meta_src && cd athena_meta_src \
     && wget https://github.com/abishara/athena_meta/archive/1.3.tar.gz -O athena_meta.tar.gz \
     && tar -xf athena_meta.tar.gz --strip-components 1 \
     && pip install --no-cache-dir -r requirements.txt \
     && pip install --no-cache-dir -vvv . && rm athena_meta.tar.gz

CMD athena-meta

