FROM ubuntu:bionic AS build-base
RUN apt-get --quiet update && apt-get --quiet --no-install-recommends install -y make cmake git gcc g++ flex bison uuid-runtime && rm -rf /var/lib/apt/lists/*;

FORM build-base as build
LABEL author="Kenneth Durbrow" \
      maintainer="kenneth.durbrow@nih.gov" \
      vendor="gov.nih.nlm.ncbi" \
      website="https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software" \
      repository="https://github.com/ncbi/sra-tools/" \
      description="Builds and installs the sratoolkit along with a working default configuration"
ARG NGS_BRANCH=master
ARG VDB_BRANCH=master
ARG SRA_BRANCH=master
ARG BUILD_STYLE=--without-debug
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
RUN mkdir -p /root/.ncbi
RUN printf '/LIBS/GUID = "%s"\n' `uuidgen` > /root/.ncbi/user-settings.mkfg
RUN printf '/libs/cloud/report_instance_identity = "true"\n' >> /root/.ncbi/user-settings.mkfg
RUN printf '/libs/cloud/accept_aws_charges = "true"\n/libs/cloud/accept_gcp_charges = "true"\n' >> /root/.ncbi/user-settings.mkfg

FROM ubuntu:latest
COPY --from=build /etc/ncbi /etc/ncbi
COPY --from=build /usr/local/ncbi /usr/local/ncbi
COPY --from=build /root/.ncbi /root/.ncbi
ENV PATH=/usr/local/ncbi/sra-tools/bin:${PATH}
RUN echo "BY USING THIS DOCKER IMAGE IN A CLOUD ENVIRONMENT, YOU WILL BE SENDING YOUR CLOUD INSTANCE IDENTITY TO NCBI, AND YOU AGREE TO ACCEPT ANY CHARGES WHICH MIGHT OCCUR DUE TO TRANSFERING DATA FROM NCBI."
