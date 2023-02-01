FROM mongo as builder
FROM registry.cern.ch/cmsmonitoring/cmsmon-hadoop-base:spark3-20220606
MAINTAINER Ceyhun Uzunoglu ceyhunuzngl@gmail.com

ENV TAG=v0.0.0
ENV WDIR=/data
ENV HADOOP_CONF_DIR=/etc/hadoop/conf
# mongoimport is in WDIR
ENV PATH="${PATH}:/usr/hdp/hadoop/bin/hadoop:/usr/hdp/spark3/bin:/usr/hdp/sqoop/bin:${WDIR}/CMSSpark/bin:${WDIR}"
# CMSMonitoring folder is in WDIR
ENV PYTHONPATH "${PYTHONPATH}:${WDIR}:${WDIR}/CMSSpark/src/python"
# LCG101 uses this cvmfs python in Spark worker nodes
ENV PYSPARK_PYTHON=/cvmfs/sft.cern.ch/lcg/releases/Python/3.9.6-b0f98/x86_64-centos7-gcc8-opt/bin/python3
# Local
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python

COPY --from=builder /usr/bin/mongoimport $WDIR

# Checkout to specific git tag
RUN git clone https://github.com/dmwm/CMSSpark.git && \
    git checkout tags/$TAG -b "$TAG"-branch && \
    mkdir -p $WDIR/logs && \
    pip install --no-cache-dir pandas click pyspark && \
    hadoop-set-default-conf.sh analytix && source hadoop-setconf.sh analytix 3.2 spark3 && \

# Run crond
CMD ["crond", "-n", "-s", "&"]
