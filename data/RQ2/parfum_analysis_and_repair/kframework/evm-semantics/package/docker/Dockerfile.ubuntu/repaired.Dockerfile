ARG BASE_IMAGE=focal
FROM ubuntu:${BASE_IMAGE}
ARG BASE_IMAGE=focal

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update                   \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes \
                        build-essential \
                        git \
                        python \
                        python3-pip && rm -rf /var/lib/apt/lists/*;

COPY kevm_amd64_${BASE_IMAGE}.deb /kevm.deb
RUN apt-get update                  \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes /kevm.deb \
    && rm -rf /kevm.deb && rm -rf /var/lib/apt/lists/*;

COPY kevm_pyk/ /kevm_pyk
RUN pip3 install --no-cache-dir /kevm_pyk \
    && rm -rf /kevm_pyk
