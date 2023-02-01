# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)

############################### Dockerfile for Elasticsearch version 7.0.1 ##################################
#
# This Dockerfile builds a basic installation of Elasticsearch.
#
# Elasticsearch is a search server based on Lucene. It provides a distributed, multitenant-capable
# full-text search engine with an HTTP web interface and schema-free JSON documents.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# Start Elasticsearch container using the below command
# docker run --name <container_name> -p 9200:9200 -d <image_name>
#
# Start Elastic search with configuration file
# For ex. docker run --name <container_name> -v <path_on_host>/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -p <port>:9200 -d <image_name>
#
##############################################################################################################

# Base Image
FROM  s390x/ubuntu:16.04

ARG ELASTICSEARCH_VER=7.0.1

# The Author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"

# Set Environment Variables

ENV LANG="en_US.UTF-8" JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8" _JAVA_OPTIONS="-Xmx10g" SOURCE_DIR="/tmp/"
ENV JAVA_HOME=/usr/share/jdk-12.0.1+12
ENV PATH=$JAVA_HOME/bin:$PATH
ENV PATCH_URL="https://raw.githubusercontent.com/linux-on-ibm-z/scripts/master/Elasticsearch/{ELASTICSEARCH_VER}/patch/"
WORKDIR $SOURCE_DIR

# Install Dependencies
RUN apt-get update &&  apt-get install -y \
    ant \
    autoconf \
    automake \
    curl \
    git \
    libtool \
    libx11-dev \
    libxt-dev \
    locales-all \
    make \
    maven \
    patch \
    pkg-config \
    tar \
    texinfo \
    unzip \
    wget \
    sudo \
	patch \
# Download AdoptJDK11
 && cd $SOURCE_DIR \
 && wget https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B12/OpenJDK12U-jdk_s390x_linux_hotspot_12.0.1_12.tar.gz \
 && tar -C /usr/share/ -xzvf OpenJDK12U-jdk_s390x_linux_hotspot_12.0.1_12.tar.gz \
# Download and build source code of elastic search
 && cd $SOURCE_DIR && git clone https://github.com/elastic/elasticsearch && cd elasticsearch && git checkout v${ELASTICSEARCH_VER} \
 && sed -i "170s/linux-x86_64/linux-s390x/" $SOURCE_DIR/elasticsearch/distribution/archives/build.gradle \
 && echo "xpack.ml.enabled: false" >> $SOURCE_DIR/elasticsearch/distribution/src/config/elasticsearch.yml \
 && curl -o BuildPlugin.diff $PATCH_URL/BuildPlugin.diff \
 && patch --ignore-whitespace $SOURCE_DIR/elasticsearch/buildSrc/src/main/groovy/org/elasticsearch/gradle/BuildPlugin.groovy BuildPlugin.diff \
 && ./gradlew assemble \
 && cd $SOURCE_DIR/elasticsearch/distribution/archives/linux-tar/build/distributions/ \
 && tar -C /usr/share/ -xf elasticsearch-${ELASTICSEARCH_VER}-SNAPSHOT-linux-s390x.tar.gz \
 && mv /usr/share/elasticsearch-${ELASTICSEARCH_VER}-SNAPSHOT /usr/share/elasticsearch \
# Clean up cache data and remove dependencies that are not required
 && apt-get remove -y \
    ant \
    automake \
    git \
    maven \
    patch \
    pkg-config \
    unzip \
    wget \
	patch \
 && apt-get autoremove -y \
 && apt autoremove -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /root/.gradle/* /tmp/elasticsearch \
# Create elaticsearch user
 && /usr/sbin/groupadd elasticsearch \
 && /usr/sbin/useradd -g elasticsearch elasticsearch \
 && usermod -aG sudo elasticsearch \
 && chown elasticsearch:elasticsearch -R /usr/share/elasticsearch

# Expose the default port
USER elasticsearch

EXPOSE 9200 9300

ENV PATH=/usr/share/elasticsearch/bin:$PATH

# Start the elasticsearch server
CMD ["elasticsearch"]

# End of Dockerfile
