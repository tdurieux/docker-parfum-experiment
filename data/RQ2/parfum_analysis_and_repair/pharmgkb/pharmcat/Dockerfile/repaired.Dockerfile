#
# Base Dockerfile for PharmCAT
#
FROM python:3.9

# apt-utils line due to https://github.com/phusion/baseimage-docker/issues/319
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils apt-transport-https gnupg && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install bzip2 build-essential wget && rm -rf /var/lib/apt/lists/*;

# install java
RUN wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
RUN gpg --batch --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
RUN gpg --batch --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg
RUN rm adoptopenjdk-keyring.gpg
RUN mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings && \
    chown root:root /usr/share/keyrings/adoptopenjdk-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main" \
    | tee /etc/apt/sources.list.d/adoptopenjdk.list
RUN apt-get update && \
    apt-get -y install --no-install-recommends adoptopenjdk-16-hotspot && rm -rf /var/lib/apt/lists/*;


RUN mkdir /pharmcat
WORKDIR /pharmcat
# download fasta files
RUN wget https://zenodo.org/record/5572839/files/GRCh38_reference_fasta.tar
RUN tar -xf GRCh38_reference_fasta.tar && rm GRCh38_reference_fasta.tar


ENV BCFTOOLS_VERSION 1.14
ENV HTSLIB_VERSION 1.14
ENV SAMTOOLS_VERSION 1.14

# download the suite of tools
WORKDIR /usr/local/bin/
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2

# extract files for the suite of tools
RUN tar -xjf /usr/local/bin/htslib-${HTSLIB_VERSION}.tar.bz2 -C /usr/local/bin/ && rm /usr/local/bin/htslib-${HTSLIB_VERSION}.tar.bz2
RUN tar -xjf /usr/local/bin/bcftools-${BCFTOOLS_VERSION}.tar.bz2 -C /usr/local/bin/ && rm /usr/local/bin/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN tar -xjf /usr/local/bin/samtools-${SAMTOOLS_VERSION}.tar.bz2 -C /usr/local/bin/ && rm /usr/local/bin/samtools-${SAMTOOLS_VERSION}.tar.bz2

# compile tools
RUN cd /usr/local/bin/htslib-${HTSLIB_VERSION}/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd /usr/local/bin/htslib-${HTSLIB_VERSION}/ && make && make install
RUN cd /usr/local/bin/bcftools-${BCFTOOLS_VERSION}/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd /usr/local/bin/bcftools-${BCFTOOLS_VERSION}/ && make && make install
RUN cd /usr/local/bin/samtools-${SAMTOOLS_VERSION}/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd /usr/local/bin/samtools-${SAMTOOLS_VERSION}/ && make && make install

# cleanup
RUN rm  -f /usr/local/bin/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/bcftools-${BCFTOOLS_VERSION}
RUN rm  -f /usr/local/bin/htslib-${HTSLIB_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/htslib-${HTSLIB_VERSION}
RUN rm  -f /usr/local/bin/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN rm -rf /usr/local/bin/samtools-${SAMTOOLS_VERSION}


WORKDIR /pharmcat
# setup python env
COPY src/scripts/preprocessor/PharmCAT_VCF_Preprocess_py3_requirements.txt ./
RUN pip3 install --no-cache-dir -r PharmCAT_VCF_Preprocess_py3_requirements.txt

# add pharmcat scripts
COPY src/scripts/preprocessor/*.py ./
COPY src/scripts/pharmcat ./
RUN chmod 755 *.py
RUN chmod 755 pharmcat
COPY pharmcat_positions.vcf* ./
COPY build/pharmcat.jar ./
