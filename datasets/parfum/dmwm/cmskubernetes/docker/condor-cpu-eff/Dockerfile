FROM registry.cern.ch/cmsmonitoring/cmsmon-hadoop-base:spark3-20220606
MAINTAINER Ceyhun Uzunoglu ceyhunuzngl@gmail.com

# set working directory
ENV WDIR=/data
WORKDIR $WDIR

# For python click ASCII problem: https://click.palletsprojects.com/en/8.1.x/unicode-support/
ENV LC_ALL=en_US.utf-8 LANG=en_US.utf-8
ENV HADOOP_CONF_DIR=/etc/hadoop/conf
ENV PATH="${PATH}:${WDIR}:/usr/hdp/hadoop/bin/hadoop:/usr/hdp/spark3/bin:/usr/hdp/sqoop/bin:${WDIR}/CMSSpark/bin"
ENV PYTHONPATH "${PYTHONPATH}:${WDIR}/CMSSpark/src/python"

# LCG101 uses this cvmfs python
ENV PYSPARK_PYTHON=/cvmfs/sft.cern.ch/lcg/releases/Python/3.9.6-b0f98/x86_64-centos7-gcc8-opt/bin/python3

# Local
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python

RUN pip install --no-cache-dir pandas pyspark click && \
    git clone https://github.com/dmwm/CMSSpark.git && \
    hadoop-set-default-conf.sh analytix && source hadoop-setconf.sh analytix 3.2 spark3

WORKDIR $WDIR
# Run crond
CMD ["crond", "-n", "-s", "&"]
