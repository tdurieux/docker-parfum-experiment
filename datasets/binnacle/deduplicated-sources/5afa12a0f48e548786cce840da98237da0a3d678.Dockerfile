FROM cloudsuite/hadoop

ENV MAHOUT_VERSION 0.12.2
ENV MAHOUT_HOME /opt/mahout-${MAHOUT_VERSION}

# Install dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
      bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Install Mahout
RUN set -x \
    && MIRROR=$(curl -s http://www.apache.org/dyn/closer.lua?as_json=1 | grep preferred | awk '{print $2}' | sed -e 's/"//g') \
    && URL=${MIRROR}mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && curl ${URL} | tar -xzC /opt \
    && mv /opt/apache-mahout-distribution-${MAHOUT_VERSION} ${MAHOUT_HOME}

# Download dataset
RUN curl https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles1.xml-p10p30302.bz2 | bunzip2 > /root/wiki
COPY files/*-site.xml ${HADOOP_CONF_DIR}/
COPY files/categories /root/
COPY files/benchmark.sh /root/
RUN chmod +x /root/benchmark.sh && ln -s /root/benchmark.sh /bin/benchmark

# Set JVM heap size to 1GB
ENV HADOOP_CLIENT_OPTS -Xmx1024m
