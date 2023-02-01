FROM ubuntu:14.04
MAINTAINER Simon Sadedin "simon.sadedin@mcri.edu.au"
RUN apt-get update;
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common python-software-properties && \
    apt-get install --no-install-recommends -y curl wget && \
    apt-get install --no-install-recommends -y apt-transport-https && apt-get update && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libcurl4-openssl-dev && apt-get install --no-install-recommends -y libxml2-dev && apt-get install --no-install-recommends -y libmariadbclient-dev && apt-get install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:openjdk-r/ppa && apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jre && apt-get install --no-install-recommends -y libfreetype6-dev pkg-config python-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/ximmer
ADD bin /usr/local/ximmer/bin
ADD src /usr/local/ximmer/src
ADD eval /usr/local/ximmer/eval
RUN cd /usr/local/ximmer && \
    ./bin/install -q && \
    echo 'JAVA="java"' >> /usr/local/ximmer/eval/pipeline/config.groovy && \
    echo 'java { executable="java" }' >> /usr/local/ximmer/eval/pipeline/bpipe.config && \
    cd /usr/local/ximmer; mkdir cache && cd cache && wget 'https://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/dgvMerged.txt.gz' && \
    cd /usr/local/ximmer/cache && wget 'https://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz'
ENV PATH="/usr/local/ximmer/bin:${PATH}"
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"

