FROM ubuntu:18.04
ARG JDK_VERSION=8
ARG SPARK_VERSION=3.0.0

# Environment
ENV DEBIAN_FRONTEND noninteractive

# Install all basic requirements
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y tar unzip wget openjdk-$JDK_VERSION-jdk libgomp1 && \
    # Python
    wget -O Miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3.sh -b -p /opt/python && \
    /opt/python/bin/pip install awscli && \
    # Maven
    wget https://archive.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz && \
    tar xvf apache-maven-3.6.1-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.6.1/ /opt/maven && \
    # Spark
    wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
    tar xvf spark-$SPARK_VERSION-bin-hadoop2.7.tgz -C /opt && \
    ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark && rm apache-maven-3.6.1-bin.tar.gz && rm -rf /var/lib/apt/lists/*;

ENV PATH=/opt/python/bin:/opt/spark/bin:/opt/maven/bin:$PATH

# Install Python packages
RUN \
    pip install --no-cache-dir numpy scipy pandas scikit-learn

ENV GOSU_VERSION 1.10

# Install lightweight sudo (not bound to TTY)
RUN set -ex; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Set default JDK version
RUN update-java-alternatives -v -s java-1.$JDK_VERSION.0-openjdk-amd64

# Default entry-point to use if running locally
# It will preserve attributes of created files
COPY entrypoint.sh /scripts/

WORKDIR /workspace
ENTRYPOINT ["/scripts/entrypoint.sh"]
