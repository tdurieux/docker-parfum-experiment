FROM ubuntu:12.04

RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/mapsplice/
RUN mkdir /MapSplice-v2.1.8
ADD MapSplice-v2.1.8 /MapSplice-v2.1.8
RUN mv MapSplice-v2.1.8/ /opt/mapsplice/
ADD wrapper.sh /opt/mapsplice/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["sh", "/opt/mapsplice/wrapper.sh"]