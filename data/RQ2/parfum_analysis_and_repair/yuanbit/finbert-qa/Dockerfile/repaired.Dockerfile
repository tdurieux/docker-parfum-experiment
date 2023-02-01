FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

MAINTAINER "Bithiah Yuan"

RUN apt-get update

# Install python requirements
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt
COPY . /tmp/


# Install Anserini requirements
RUN apt-get update && \
 apt install --no-install-recommends -y openjdk-11-jdk \
&& apt install --no-install-recommends -y maven \
&& apt install --no-install-recommends -y wget \
&& wget -P /tmp/ https://ftp.halifax.rwth-aachen.de/apache/lucene/java/8.5.0/lucene-8.5.0-src.tgz \
&& tar -xvzf /tmp/lucene-8.5.0-src.tgz \
&& export CLASSPATH=$CLASSPATH:/tmp/lucene-8.5.0/core/lucene-core-8.5.0.jar:/tmp/lucene-8.5.0/demo/lucene-demo-8.5.0.jar:/tmp/lucene-8.5.0/analysis/common/lucene-analyzers-common-8.5.0.jar:/tmp/lucene-8.5.0/queryparser/lucene-queryparser-8.5.0.jar && rm /tmp/lucene-8.5.0-src.tgz && rm -rf /var/lib/apt/lists/*;

# Get project
RUN git clone https://github.com/yuanbit/FinBERT-QA.git

# Set working directory
WORKDIR /workspace/FinBERT-QA
