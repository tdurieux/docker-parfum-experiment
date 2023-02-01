FROM python:3.6
LABEL maintainer="LSST Alert Production; https://dm.lsst.org/"

# Pip installs.
RUN pip install --no-cache-dir 'confluent-kafka>=0.11.4'
RUN pip install --no-cache-dir avro-python3
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir fastavro
RUN pip install --no-cache-dir numpy

# Get schemas and template data.
WORKDIR /home
RUN git clone https://github.com/lsst-dm/sample-avro-alert.git

# Add code.
RUN mkdir alert_stream
ADD . /home/alert_stream
ENV PYTHONPATH=/home/alert_stream/python:/home/sample-avro-alert/python

WORKDIR /home/alert_stream
