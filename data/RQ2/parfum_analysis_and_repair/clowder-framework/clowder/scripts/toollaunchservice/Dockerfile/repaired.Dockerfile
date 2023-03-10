FROM ubuntu:16.04

# environemnt variables
ARG BRANCH="unknown"
ARG VERSION="unknown"
ARG BUILDNUMBER="unknown"
ARG GITSHA1="unknown"
ENV BRANCH=${BRANCH} \
    VERSION=${VERSION} \
    BUILDNUMBER=${BUILDNUMBER} \
    GITSHA1=${GITSHA1}

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install curl unzip docker.io python python-dev python-pip \
    && pip install --no-cache-dir flask-restful \
    && pip install --no-cache-dir arrow \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;
COPY FILES.toolserver /
ENV TOOLSERVER_PORT 8082
CMD /usr/local/bin/usage

