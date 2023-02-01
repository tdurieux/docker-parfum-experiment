#AlignQC Development Environment
FROM ubuntu:16.04
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
               python-pip \
               r-base \
               nano \
               wget \
               git \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir seq-tools==1.0.10

VOLUME /temp
VOLUME /root

RUN pip install --no-cache-dir AlignQC==2.0.5

ENV HOME /root
WORKDIR /root
