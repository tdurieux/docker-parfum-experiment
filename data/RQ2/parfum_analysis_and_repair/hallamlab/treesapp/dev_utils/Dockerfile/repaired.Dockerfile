FROM ubuntu:bionic

ENV TREESAPP_VERSION="0.11.3"\
  MAFFT_VERSION="7.475-1"\
  BWA_VERSION="0.7.17"\
  PRODIGAL_VERSION="2.6.3"\
  HMMER_VERSION="3.3"\
  RAXML_VERSION="1.0.1"\
  EPA_VERSION="0.3.8"\
  VSEARCH_VERSION="2.15.0"\
  MMSEQS_VERSION="12-113e3"

LABEL base.image="ubuntu:bionic"
LABEL container.version="0.3"
LABEL software="TreeSAPP"
LABEL software.version=${TREESAPP_VERSION}
LABEL description="A Python package for gene-centric taxonomic and functional classification using phylogenetic placement"
LABEL website="https://github.com/hallamlab/TreeSAPP"
LABEL license="GNU General Public License v3.0"
LABEL maintainer="Connor Morgan-Lang"
LABEL maintainer.email="c.morganlang@gmail.com"

RUN apt-get update && \
 apt-get -y --no-install-recommends install \
 gcc \
 dpkg-dev \
 curl \
 wget \
 zip \
 git \
 libz-dev \
 default-jdk \
 time \
 libssl-dev \
 libsqlite3-dev \
 autotools-dev \
 libtool \
 flex \
 bison \
 cmake \
 automake \
 autoconf \
 python3 \
 python3-distutils \
 python3-dev && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python
RUN python -V

RUN curl -f -LJ0 --output /usr/local/bin/BMGE.jar https://github.com/hallamlab/TreeSAPP/raw/master/treesapp/sub_binaries/BMGE.jar

RUN curl -f -LJ0 --output mafft.deb https://mafft.cbrc.jp/alignment/software/mafft_${MAFFT_VERSION}_amd64.deb && \
 dpkg -i mafft.deb && \
 rm mafft.deb

RUN wget https://github.com/torognes/vsearch/archive/v${VSEARCH_VERSION}.tar.gz && \
 tar xzf v${VSEARCH_VERSION}.tar.gz && \
 cd vsearch-${VSEARCH_VERSION} && \
 ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cd - && rm v${VSEARCH_VERSION}.tar.gz

RUN curl -f -LJ0 --output mmseqs-linux-sse41.tar.gz https://github.com/soedinglab/MMseqs2/releases/download/${MMSEQS_VERSION}/MMseqs2-Linux-SSE4_1.tar.gz && \
 tar xvzf mmseqs-linux-sse41.tar.gz && \
 cp mmseqs/bin/mmseqs /usr/local/bin && rm mmseqs-linux-sse41.tar.gz

RUN curl -f -LJ0 --output /usr/bin/prodigal https://github.com/hyattpd/Prodigal/releases/download/v${PRODIGAL_VERSION}/prodigal.linux && \
 chmod +x /usr/bin/prodigal

RUN curl -f -LJ0 --output v${BWA_VERSION}.tar.gz https://github.com/lh3/bwa/archive/v${BWA_VERSION}.tar.gz && \
 tar -xzf v${BWA_VERSION}.tar.gz; cd bwa-${BWA_VERSION}/; make; rm *.o; cd -; cp bwa-${BWA_VERSION}/bwa /usr/bin/bwa && \
 rm v${BWA_VERSION}.tar.gz

RUN curl -f -LJ0 --output hmmer-${HMMER_VERSION}.tar.gz https://eddylab.org/software/hmmer/hmmer-${HMMER_VERSION}.tar.gz && \
 tar -xzf hmmer-${HMMER_VERSION}.tar.gz; cd hmmer-${HMMER_VERSION}/; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make -f Makefile && \
 cp src/hmmsearch src/hmmbuild src/hmmalign /usr/bin/ && \
 cd -; rm hmmer-${HMMER_VERSION}.tar.gz

RUN curl -f -LJ0 --output od-seq.tar.gz https://www.bioinf.ucd.ie/download/od-seq.tar.gz; tar -xzf od-seq.tar.gz && rm od-seq.tar.gz
ENV ODSEQ_SOURCES="OD-Seq/AliReader.cpp OD-Seq/Bootstrap.cpp OD-Seq/DistCalc.cpp OD-Seq/DistMatReader.cpp \
OD-Seq/DistWriter.cpp OD-Seq/FastaWriter.cpp OD-Seq/IQR.cpp OD-Seq/ODseq.cpp OD-Seq/PairwiseAl.cpp \
OD-Seq/Protein.cpp OD-Seq/ResultWriter.cpp OD-Seq/runtimeargs.cpp OD-Seq/util.cpp"
RUN g++ -fopenmp -o /usr/bin/OD-seq ${ODSEQ_SOURCES} && \
 rm od-seq.tar.gz

RUN curl -f -LJ0 --output /usr/bin/FastTree https://microbesonline.org/fasttree/FastTreeDbl && \
 chmod +x /usr/bin/FastTree

RUN curl -f -LJ0 --output raxml-ng_v${RAXML_VERSION}.zip https://github.com/amkozlov/raxml-ng/releases/download/${RAXML_VERSION}/raxml-ng_v${RAXML_VERSION}_linux_x86_64.zip && \
 mkdir raxml-ng_v${RAXML_VERSION}; unzip raxml-ng_v${RAXML_VERSION}.zip -d raxml-ng_v${RAXML_VERSION} && \
 cp raxml-ng_v${RAXML_VERSION}/raxml-ng /usr/local/bin/ && \
 rm -r raxml-ng_v${RAXML_VERSION}.zip raxml-ng_v${RAXML_VERSION}

RUN curl -f -LJ0 --output epa-ng.tar.gz https://github.com/Pbdas/epa-ng/archive/v${EPA_VERSION}.tar.gz && \
 tar -xzf epa-ng.tar.gz; cd epa-ng-${EPA_VERSION}/ && \
 make; cp bin/epa-ng /usr/bin/; cd - && \
 rm epa-ng.tar.gz

RUN pip install --no-cache-dir treesapp==${TREESAPP_VERSION} && \
 rm -rf TreeSAPP/

RUN treesapp info -v
