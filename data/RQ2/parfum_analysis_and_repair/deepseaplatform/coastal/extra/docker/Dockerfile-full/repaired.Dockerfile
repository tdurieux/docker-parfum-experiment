#==============================================================================
# Docker image for running COASTAL
#==============================================================================

FROM ubuntu:bionic AS base
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install wget m4 git make python g++ perl openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

#--- Z3 ---
RUN git clone https://github.com/Z3Prover/z3.git
WORKDIR /z3/
RUN python scripts/mk_make.py --java --prefix=/usr/local
WORKDIR /z3/build/
RUN make && make test && make install
WORKDIR /

#--- LATTE ---
##RUN wget --no-check-certificate https://github.com/latte-int/latte/releases/download/version_1_7_5/latte-integrale-1.7.5.tar.gz && tar xzf latte-integrale-1.7.5.tar.gz
#RUN wget https://github.com/latte-int/latte/releases/download/version_1_7_5/latte-integrale-1.7.5.tar.gz && tar xzf latte-integrale-1.7.5.tar.gz
#WORKDIR /latte-integrale-1.7.5/
#RUN ./configure --prefix=/usr/local && make
#WORKDIR /

#--- BARVINOK ---
#RUN wget http://barvinok.gforge.inria.fr/barvinok-0.41.tar.gz && tar xzf barvinok-0.41.tar.gz
#WORKDIR /barvinok-0.41/
#RUN ./configure --prefix=/usr/local --with-gmp-prefix=/usr/local --without-pic --with-gnu-ld --disable-gold --enable-shared=no && make && make check && make install
#WORKDIR /

#--- COASTAL ---
ARG update=0
RUN echo $update > /dev/null && git clone https://github.com/DeepseaPlatform/coastal.git
WORKDIR /coastal/
RUN ./gradlew dependencies -Phttp.socketTimeout=1000000 -Phttp.connectionTimeout=1000000
RUN ./gradlew build -Phttp.socketTimeout=1000000 -Phttp.connectionTimeout=1000000
RUN ./gradlew installDist
WORKDIR /

#--- FINAL ---
FROM ubuntu:bionic
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install openjdk-8-jdk openjfx && rm -rf /var/lib/apt/lists/*;
COPY --from=base /usr/local /usr/local
COPY --from=base /coastal/build/install/coastal/bin/coastal /usr/bin
COPY --from=base /coastal/build/install/coastal/lib /usr/lib
COPY ./coastal-in-docker.sh /
ENTRYPOINT ["/coastal-in-docker.sh"]
CMD []
