FROM ubuntu:18.04

MAINTAINER Rebecca Louise Evans (rebecca.louise.evans@gmail.com)

LABEL Description="This image is used to run JAFFA" Version="1.09"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        bowtie2 \
        bzip2 \
        g++ \
        git \
        gzip \
        libncurses5-dev \
        libpng-dev \
        lmod \
        make \
        openjdk-8-jdk \
        python \
        r-base \
        r-base-dev \
        time \
        trimmomatic \
        unzip \
        wget \
        zlib1g-dev \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

VOLUME /data/batch

WORKDIR /opt

# Set Standard settings
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV CLASSPATH .
ENV CP ${CLASSPATH}
ENV BASH_ENV /usr/share/lmod/lmod/init/bash
ENV PATH /usr/bin:/bin:/usr/local/bin:/opt/bin:/opt/bbmap
#ENV MODULEPATH

# setup lmod
RUN ln -s /usr/share/lmod/lmod/init/profile /etc/profile.d/modules.sh
RUN ln -s /usr/share/lmod/lmod/init/cshrc /etc/profile.d/modules.csh

# install samtools/1.1 (due to backwards incompatibility)
RUN wget --max-redirect 5 https://sourceforge.net/projects/samtools/files/samtools/1.1/samtools-1.1.tar.bz2 -O - | tar -xj
RUN make prefix=/usr/local install -C samtools-1.1

# install bbmap
RUN wget --max-redirect 5 https://sourceforge.net/projects/bbmap/files/latest/download?source=files -O - | tar -xz
RUN make -C bbmap/jni -f makefile.linux
RUN find /opt/bbmap -type f -exec ln -s '{}' /usr/local/bin/ \;

# install oases and velvet
RUN git clone --recursive https://github.com/dzerbino/oases.git
RUN make -C oases/velvet/ MAXKMERLENGTH=37 LONGSEQUENCES=1
RUN make -C oases/ MAXKMERLENGTH=37 LONGSEQUENCES=1 'VELVET_DIR=velvet'
RUN cp oases/velvet/velvetg /usr/bin/
RUN cp oases/velvet/velveth /usr/bin/
RUN cp oases/oases /usr/bin
RUN rm -rf oases

# install blat
RUN wget https://users.soe.ucsc.edu/~kent/src/blatSrc35.zip
RUN unzip blatSrc35.zip
RUN rm blatSrc35.zip
ENV MACHTYPE=x86_64
RUN mkdir -p ${HOME}/bin/${MACHTYPE}
RUN make -C blatSrc
RUN mv ${HOME}/bin/${MACHTYPE}/* /usr/bin
RUN rmdir ${HOME}/bin/${MACHTYPE}
RUN rmdir ${HOME}/bin
RUN rm -rf blatSrc

# install bpipe
RUN git clone https://github.com/ssadedin/bpipe.git
# gradle properties holds http.proxyHost and http.proxyPort
# COPY gradle.properties bpipe/gradle.properties
# RUN bpipe/gradlew -p bpipe dist
RUN cd bpipe; ./gradlew dist
RUN mv bpipe/build/stage/bpipe* .
RUN rm -rf bpipe
RUN mv bpipe* bpipe
RUN chmod 755 /opt/bpipe/bin/*
RUN find /opt/bpipe/bin -type f -exec ln -s '{}' /usr/local/bin/ \;

# install R dependencies (required by JAFFA)
RUN Rscript -e 'source("http://bioconductor.org/biocLite.R")' -e 'biocLite("IRanges")'

# install jaffa
RUN wget https://github.com/Oshlack/JAFFA/releases/download/version-1.09/JAFFA-version-1.09.tar.gz -O - | tar -xz
RUN mv JAFFA-version-1.09 JAFFA

# set the tools
COPY tools.groovy JAFFA/tools.groovy
RUN chmod 644 JAFFA/tools.groovy

COPY convert_jaffa_to_bedpe.py /usr/local/bin/convert_jaffa_to_bedpe.py
RUN chmod 755 /usr/local/bin/convert_jaffa_to_bedpe.py

WORKDIR /data/batch

CMD ["bpipe", "run", "-p", "fastqInputFormat='%_*.fastq.gz'", "-p", "refBase=/data/reference", "-p", "genome=hg38", "-p", "annotation=genCode22", "/opt/JAFFA/JAFFA_direct.groovy", "/data/example/BT474-demo_1.fastq.gz", "/data/example/BT474-demo_2.fastq.gz"]
