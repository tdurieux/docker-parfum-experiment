FROM alpine

RUN apk add --update \
    git \
    cmake \
    build-base \
    openssl-dev \
    bash \
  && rm -rf /var/cache/apk/*

RUN git clone https://github.com/h2o/picotls

# Draft -18
#ARG REVISION=a6c1c65

# Draft -22
ARG REVISION=843ccdc

RUN cd picotls && git fetch && git checkout $REVISION

RUN cd picotls && git submodule update --init
RUN cd picotls && cmake . && make

ADD httpreq.txt /httpreq.txt
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
