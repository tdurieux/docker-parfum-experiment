# KNEEL and DeepKnee inference packages share the same docker image.
FROM miptmloulu/kneel:gpu

MAINTAINER Aleksei Tiulpin, University of Oulu, Version 1.0

RUN pip install --no-cache-dir pynetdicom

RUN mkdir -p /opt/pkg-deepknee/
COPY . /opt/pkg-deepknee/
RUN pip install --no-cache-dir /opt/pkg-deepknee/