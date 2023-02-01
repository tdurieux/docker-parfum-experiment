FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y -q curl bzip2 git && \
    rm -rf /var/lib/apt/lists/*

# Install CDH5 in a single node: Pseudo Distributed
# Docs: http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cdh_qs_yarn_pseudo.html
ADD docker-files/cloudera.pref /etc/apt/preferences.d/cloudera.pref
RUN curl -s http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key | apt-key add - && \
    echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh trusty-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list && \
    echo 'deb-src http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh trusty-cdh5 contrib' >> /etc/apt/sources.list.d/cloudera.list && \
    apt-get update && \
    apt-get install -y -q openjdk-7-jre-headless hadoop-conf-pseudo && \
    sudo -u hdfs hdfs namenode -format -force && \
    for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done && \
    bash /usr/lib/hadoop/libexec/init-hdfs.sh && \
    rm -rf /var/lib/apt/lists/*

# Needed for hdfs3
ENV LIBHDFS3_CONF /etc/hadoop/conf/hdfs-site.xml

# Install conda & build conda environments:
# py35 is root environment
# py27 gets own environment
RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda install -y -q libhdfs3 pytest flake8 -c conda-forge && \
    /opt/conda/bin/conda create -y -n py27 python=2.7 && \
    /opt/conda/bin/conda install -y -q -n py27 libhdfs3 pytest -c conda-forge

ENV PATH /opt/conda/bin:$PATH

EXPOSE 8020 50070

VOLUME /hdfs3
WORKDIR /hdfs3

ADD docker-files/start.sh /tmp/start.sh
CMD ["bash", "/tmp/start.sh", "-d"]
