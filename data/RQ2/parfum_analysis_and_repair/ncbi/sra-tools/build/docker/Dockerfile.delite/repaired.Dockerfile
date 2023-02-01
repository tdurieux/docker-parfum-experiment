# Example:
# % docker build -f Dockerfile.delite -t sratoolkit:delite .
# % docker run --rm sratoolkit:delite vdb-dump --info SRR000123
# acc    : SRR000123
# path   : https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-5/SRR000123/SRR000123.3
# size   : 2,975,717
# type   : Table
# platf  : SRA_PLATFORM_454
# SEQ    : 4,583
# SCHEMA : NCBI:SRA:_454_:tbl:v2#1.0.7
# UPD    : vdb-copy
# UPDVER : 2.1.7
# UPDDATE: Mon Nov  7 18:13:09 2011 (11/7/2011 18:13)
# % mkdir ~/output
# % docker run -v ~/output/:/output:rw --rm sratoolkit:delite delite_docker.sh SRR000001 SRR000002
# % docker run -v ~/output/:/output:rw --rm sratoolkit:delite vdb-dump -R 1 /output/SRR000001/new.kar
# % docker run -v ~/output/:/output:rw --rm sratoolkit:delite delite_docker.sh --skiptest SRR000001
# % docker run -v ~/output/:/output:rw --rm sratoolkit:delite delite_test_docker.sh SRR000001
# If docker container run at AWS, "-v /etc/pki:/etc/pki:ro -v /etc/ssl:/etc/ssl:ro" should be added to command line.
# % docker run -v ~/output/:/output:rw -v /etc/pki:/etc/pki:ro -v /etc/ssl:/etc/ssl:ro --rm sratoolkit:delite delite_docker.sh SRR000001
#

# bionic is 18.04 LTS
FROM ubuntu:bionic AS build
RUN apt-get --quiet update && apt-get --quiet --no-install-recommends install -y make cmake git gcc g++ flex bison uuid-runtime && rm -rf /var/lib/apt/lists/*;
ARG BUILD_STYLE=--without-debug
ARG NGS_BRANCH=engineering
ARG VDB_BRANCH=engineering
ARG SRA_BRANCH=engineering
RUN git clone -b ${NGS_BRANCH} --depth 1 https://github.com/ncbi/ngs.git
RUN git clone -b ${VDB_BRANCH} --depth 1 https://github.com/ncbi/ncbi-vdb.git
RUN git clone -b ${SRA_BRANCH} --depth 1 https://github.com/ncbi/sra-tools.git
WORKDIR /ncbi-vdb
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${BUILD_STYLE} && make -s >/dev/null 2>&1 || { echo "make failed"; exit 1; }
WORKDIR /ngs
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${BUILD_STYLE} && make -s -C ngs-sdk >/dev/null 2>&1 || { echo "make failed"; exit 1; }
WORKDIR /sra-tools
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${BUILD_STYLE} && make -s >/dev/null 2>&1 || { echo "make failed"; exit 1; }
RUN make install

FROM build AS delited
### Install delite process binaries and script
RUN cp -a /root/ncbi-outdir/sra-tools/*/*/*/*/bin/kar+* /root/ncbi-outdir/sra-tools/*/*/*/*/bin/make-read-filter* /sra-tools/tools/kar/sra_delite.sh /sra-tools/tools/kar/sra_delite.kfg /sra-tools/tools/kar/delite_docker.sh /sra-tools/tools/kar/delite_docker_local.sh /sra-tools/tools/kar/delite_test_docker.sh /usr/local/ncbi/sra-tools/bin
RUN chmod ugo+x /usr/local/ncbi/sra-tools/bin/delite_docker.sh /usr/local/ncbi/sra-tools/bin/delite_test_docker.sh /usr/local/ncbi/sra-tools/bin/delite_docker_local.sh
### Copy schema files
WORKDIR /ncbi-vdb/interfaces
RUN rm -rf csra2 sra/pevents.* ; for i in */*.vschema ; do mkdir -p /schema/`dirname $i` ; cp $i /schema/`dirname $i` ; done
### Generate installation stamp
RUN mkdir -p /root/.ncbi
RUN printf '/LIBS/GUID = "%s"\n' `uuidgen` > /root/.ncbi/user-settings.mkfg
RUN printf '/libs/cloud/report_instance_identity = "true"\n' >> /root/.ncbi/user-settings.mkfg
RUN printf '/libs/cloud/accept_aws_charges = "true"\n/libs/cloud/accept_gcp_charges = "true"\n' >> /root/.ncbi/user-settings.mkfg
RUN printf 'DELITE_GUID=%s\n' `uuidgen` >> /usr/local/ncbi/sra-tools/bin/sra_delite.kfg

FROM ubuntu:bionic
COPY --from=delited /etc/ncbi /etc/ncbi
COPY --from=delited /usr/local/ncbi /usr/local/ncbi
#COPY --from=delited /build-id /root/.ncbi/build-id
COPY --from=delited /schema /etc/ncbi/schema
COPY --from=delited /root/.ncbi/user-settings.mkfg /root/.ncbi/user-settings.mkfg

ENV PATH=/usr/local/ncbi/sra-tools/bin:${PATH}
# ENV SCHEMA_PATH=/etc/ncbi/schema
