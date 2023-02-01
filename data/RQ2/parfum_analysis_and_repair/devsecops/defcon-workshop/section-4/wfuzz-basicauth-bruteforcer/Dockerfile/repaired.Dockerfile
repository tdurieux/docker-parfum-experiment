FROM golang:1.8-onbuild

MAINTAINER Anshuman Bhartiya (anshuman.bhartiya@gmail.com)

RUN mkdir /data
WORKDIR /data

ADD wfuzz/ /data/wfuzz/
RUN apt-get update && apt-get install --no-install-recommends -y python-pip \
    libcurl4-gnutls-dev \
    librtmp-dev \
    python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pycurl

ENTRYPOINT ["app"]