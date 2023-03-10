From ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev build-essential libyaml-dev git wget xml-twig-tools libsort-naturally-perl default-jre sox cmake mercurial automake libtool libboost-all-dev libpstreams-dev libpthread-stubs0-dev libxml2-dev libcurl4-openssl-dev git libssl-dev language-pack-en && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && \
    git clone https://github.com/isl-mt/SLT.KIT.git

RUN cd /opt && git clone https://github.com/dwd/rapidxml.git

RUN cd /opt && \
    git clone https://github.com/moses-smt/mosesdecoder.git && \
    sed -i 's/my $sentence_start = 1;/my $sentence_start = 1;\n$|++;/g' /opt/mosesdecoder/scripts/recaser/truecase.perl

#RUN cd /opt/ && git clone https://github.com/google/sentencepiece.git && apt-get install -y pkg-config libgoogle-perftools-dev cmake&& \
#    cd /opt/sentencepiece && mkdir build && \
#    cd build && \
#    cmake .. && \
#    make -j 16 && \
#    make install && \
#    ldconfig -v

RUN cd /opt && \
    git clone https://github.com/rsennrich/subword-nmt.git


#LMDB
RUN apt-get install --no-install-recommends -y liblmdb-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/lib && cd /opt/lib && \
    git clone https://github.com/bendiken/lmdbxx.git && \
    cd lmdbxx/ && make install

#MONGODB

RUN cd /opt/lib && \
    git clone git://github.com/mongodb/mongo-c-driver.git && \
    cd mongo-c-driver && git reset --hard bfcbed2aaed6082f6eaacf490858bb73eb1c042b && ./autogen.sh && make install -j 16 && cd .. && \
    git clone https://github.com/mongodb/mongo-cxx-driver.git  --branch releases/stable && \
    cd mongo-cxx-driver/build && git reset --hard 8c6aa6d37f0cf2d00eef83d98bf69ca088dee035 && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && make EP_mnmlstc_core && make && make install


#MEDIATOR LIBRARY
RUN cd /opt/ && git clone https://github.com/ELITR/pv-platform-sample-connector.git

RUN cd /opt/SLT.KIT/src/server && autoreconf -i && \
    mkdir -p /opt/SLT.KIT/build && cd /opt/SLT.KIT/build && \
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/:/opt/pv-platform-sample-connector//Linux/lib64/ && \
    ../src/server/configure --with-rapidxml=/opt/rapidxml --with-mongo=/usr/local/ --enable-lmdb --with-mediator=/opt/pv-platform-sample-connector/ && make && make install

CMD /opt/SLT.KIT/src/server/RUN.sh