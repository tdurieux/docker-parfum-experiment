FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y curl bzip2 build-essential \
    && curl -f https://root.cern.ch/download/cling/cling_2018-07-31_ubuntu16.tar.bz2 > cling.tar.bz2 \
    && tar -xf cling.tar.bz2 -C . \
    && rm cling.tar.bz2 \
    && (cd cling_2018-07-31_ubuntu16 && tar -cf /cling.tar.bz2 .) \
    && tar -xf /cling.tar.bz2 \
    && rm -rf /cling.tar.bz2 cling_2018-07-31_ubuntu16 && rm -rf /var/lib/apt/lists/*;

ADD runcpp.sh runcpp.sh
ENTRYPOINT ["bash","runcpp.sh"]
