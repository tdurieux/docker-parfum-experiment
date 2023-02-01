FROM python:2

RUN apt-get update && apt-get install --no-install-recommends -y graphviz r-base r-base-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/grocsvs/idba/archive/1.1.3g1.tar.gz \
     && tar -xf 1.1.3g1.tar.gz \
     && cd idba-1.1.3g1 \
     && ./build.sh \
     && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
     && make \
     && mv bin/idba_ud /bin && rm 1.1.3g1.tar.gz

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

RUN pip install --no-cache-dir -U pip

RUN pip install --no-cache-dir -U rpy2

RUN mkdir grocsvs_src && cd grocsvs_src \
     && wget https://github.com/grocsvs/grocsvs/archive/v0.2.6.1.tar.gz -O grocsvs.tar.gz \
     && tar -xf grocsvs.tar.gz --strip-components 1 \
     && pip install --no-cache-dir -r requirements.txt \
     && pip install --no-cache-dir -vvv . && rm grocsvs.tar.gz

CMD grocsvs