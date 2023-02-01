# Dockerfile for ORE backend

FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install --no-install-recommends -y texlive \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install --no-install-recommends -y python python-pip libboost-dev libboost-graph-dev libboost-date-time-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev cmake gcc libxerces-c-dev xsdcxx \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir requests

COPY backends/docker/startup.sh /startup.sh

EXPOSE 8000
CMD ["bash", "/startup.sh"]
