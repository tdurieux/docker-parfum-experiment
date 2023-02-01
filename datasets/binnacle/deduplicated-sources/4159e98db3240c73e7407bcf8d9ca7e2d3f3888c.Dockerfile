ARG GPU_SUFFIX=''
ARG FROM_VERSION
ARG GRADLE_VERSION
FROM harbor.h2o.ai/opsh2oai/h2o-3/dev-build-hadoop-gradle-${GRADLE_VERSION}${GPU_SUFFIX}:${FROM_VERSION}

# Install s3cmd
ENV S3_CMD_VERSION '2.0.1'
RUN \
    cd /opt/ && \
    wget http://netix.dl.sourceforge.net/project/s3tools/s3cmd/${S3_CMD_VERSION}/s3cmd-${S3_CMD_VERSION}.tar.gz && \
    tar xzf s3cmd-${S3_CMD_VERSION}.tar.gz && \
    rm s3cmd-${S3_CMD_VERSION}.tar.gz && \
    cd s3cmd-${S3_CMD_VERSION} && \
    python setup.py install

# Install conda
RUN \
    curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -bfp /usr/local && \
    rm /tmp/miniconda.sh && \
    conda install -y anaconda-client conda-build && \
    conda update conda && \
    conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH
ENV GRADLE_USER_HOME=/home/jenkins/.gradle
