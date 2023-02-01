FROM alpine:3.10

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.roslin-qc="0.6.4" \
      version.getbasecountsmultisample="1.2.2" \
      version.bamtools="2.5.1" \
      version.alpine="3.10" \
      source.roslin-qc="https://github.com/mskcc/roslin-qc/releases/tag/0.6.4" \
      source.getbasecountsmultisample="https://github.com/zengzheng123/GetBaseCountsMultiSample" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.bamtools="https://github.com/pezmaster31/bamtools"

ENV ROSLIN_QC_VERSION 0.6.4
ENV GETBASECOUNTSMULTISAMPLE_VERSION 1.2.2
ENV BAMTOOLS_VERSION 2.5.1

ENV PATH "$PATH:/bin"

COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --no-cache --update \
    # for wget
    && apk add --no-cache ca-certificates openssl \
    # for compilation
    && apk add --no-cache build-base musl-dev python py-pip python-dev py-setuptools git cmake jsoncpp zlib-dev \
    && cd /tmp \
        # install mysql connector
        && pip install --no-cache-dir mysql-connector-python \
        # install texlive
        && apk add --no-cache texlive \
        # install texmf-dist
        && apk add --no-cache texmf-dist \
        # install texmf-dist-latexextra
        && apk add --no-cache texmf-dist-latexextra \
        # install pandas
        && pip install --no-cache-dir django==1.11 \
        && pip install --no-cache-dir dbconfig \
        # install R
        && apk add --no-cache R R-dev \
        # install pylatex
        && pip install --no-cache-dir pylatex \
        # install python dependencies
        && pip install --no-cache-dir fnmatch2 argparse \
        # install java and perl
        && apk add --no-cache openjdk8-jre-base perl \
        && wget https://github.com/zengzheng123/GetBaseCountsMultiSample/archive/v${GETBASECOUNTSMULTISAMPLE_VERSION}.tar.gz \
        && tar xvzf v${GETBASECOUNTSMULTISAMPLE_VERSION}.tar.gz \
        # copy current roslin-qc
        && git clone https://github.com/mskcc/roslin-qc.git -b ${ROSLIN_QC_VERSION} \
        && cp -R roslin-qc/* /usr/bin/ \
        # FIX ALL THESE WRONG FILE PATHS
        && cd /usr/bin/ \
        && sed -i "s/opt\/common\/CentOS_6-dev\//usr\//g" *.pl \
        && sed -i "s/opt\/common\/CentOS_6\/R\/R-3.2.0\//usr\//g" *.R \
        && R -e "install.packages('corrplot', repos='http://cran.wustl.edu')" \
        && R -e "install.packages('ggplot2', repos='http://cran.wustl.edu')" \
        && R -e "install.packages(c('gplots','scales','reshape','plyr','RColorBrewer','optparse','ggforce'), repos='http://cran.us.r-project.org')" \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
        && pip install --no-cache-dir numpy \
        && pip install --no-cache-dir pandas==0.23.4 \
        # Install perl dependency needed
        && perl -MCPAN -e 'install Tie::IxHash' \
        # build and install bamtools
        && cd /tmp/GetBaseCountsMultiSample-${GETBASECOUNTSMULTISAMPLE_VERSION}/bamtools-master \
        && rm -r build/ \
        && mkdir build \
        && cd build/ \
        && cmake -DCMAKE_CXX_FLAGS=-std=c++03 .. \
        && make \
        && make install \
        # copy libbamtools to /usr/lib/
        && cp ../lib/libbamtools.so.2.3.0 /usr/lib/ \
        # install getbasecountsmultisample
        && cd /tmp/GetBaseCountsMultiSample-${GETBASECOUNTSMULTISAMPLE_VERSION} \
        && make \
        && mv GetBaseCountsMultiSample /usr/bin/ \
        # clean up
        && rm -rf /tmp/* \
        && chmod +x /usr/bin/runscript.sh \
        && exec /run_test.sh && rm v${GETBASECOUNTSMULTISAMPLE_VERSION}.tar.gz

ENV PYTHONNOUSERSITE set

ENV LANG "C.UTF-8"

ENTRYPOINT ["sh","/usr/bin/runscript.sh"]
CMD ["help"]
