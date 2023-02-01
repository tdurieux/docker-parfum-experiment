FROM ubuntu:latest
ARG VERSION=current
RUN apt-get update && apt-get --quiet --no-install-recommends install --yes curl uuid-runtime && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${VERSION}/sratoolkit.${VERSION}-centos_linux64-cloud.tar.gz | tar xz -C /
ENV PATH=/usr/local/ncbi/sra-tools/bin:${PATH}
RUN mkdir -p /root/.ncbi && \
    printf '/LIBS/IMAGE_GUID = "%s"\n' `uuidgen` > /root/.ncbi/user-settings.mkfg && \
    printf '/libs/cloud/report_instance_identity = "true"\n' >> /root/.ncbi/user-settings.mkfg
