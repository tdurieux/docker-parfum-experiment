FROM quay.io/pypa/manylinux2014_aarch64

SHELL ["/bin/bash", "-c"]   # Use Bash as shell

# Install all basic requirements
RUN \
    yum update -y && \
    yum install -y tar unzip wget xz git centos-release-scl-rh yum-utils && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    yum update -y && \
    yum install -y devtoolset-7 && \
    # Python
    wget --no-verbose -O conda.sh https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh && \
    bash conda.sh -b -p /opt/miniforge-python && rm -rf /var/cache/yum

ENV PATH=/opt/miniforge-python/bin:$PATH
ENV CC=/opt/rh/devtoolset-7/root/usr/bin/gcc
ENV CXX=/opt/rh/devtoolset-7/root/usr/bin/c++
ENV CPP=/opt/rh/devtoolset-7/root/usr/bin/cpp
ENV GOSU_VERSION 1.10

# Create new Conda environment
COPY conda_env/aarch64_test.yml /scripts/
RUN conda env create -n aarch64_test --file=/scripts/aarch64_test.yml

# Install lightweight sudo (not bound to TTY)
RUN set -ex; \
    wget --no-verbose -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-arm64" && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Default entry-point to use if running locally
# It will preserve attributes of created files
COPY entrypoint.sh /scripts/

WORKDIR /workspace
ENTRYPOINT ["/scripts/entrypoint.sh"]
