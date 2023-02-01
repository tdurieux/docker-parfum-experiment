FROM debian

MAINTAINER Tamas Kohegyi <tkohegyi2@gmail.com>

RUN \
  mkdir /data && \
  mkdir /data/wilma && \
  cd /data/wilma && \
  apt-get update && \
  apt-get install --no-install-recommends -y apt-utils && \
  apt-get install --no-install-recommends -y unzip && \
  apt-get install --no-install-recommends -y wget && \
  apt-get install --no-install-recommends -y procps && \
  apt-get install --no-install-recommends -y openjdk-17-jre && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/epam/Wilma/releases/download/V2.3.480/wilma-application-2.3.480.zip && \
  unzip wilma-application-2.3.480.zip && \
  mv wilma-2.3.480.jar wilma.jar && \
  rm -f wilma-application-2.3.480.zip

COPY start_wilma.sh /data/
RUN \
  cd /data && \
  chmod 777 *.sh

WORKDIR /data

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV WILMA_CONFIGURATION wilma.conf.properties
#ENV WILMA_MX_SIZE - it has no default value
#ENV WILMA_KEYSTORE - it has no default value
#ENV WILMA_KEYSTORE_PASSWORD - it has no default value
#ENV WILMA_JMX_PORT 9011 - note, if you use it, the port should be exposed too!

# you may start wilma with default settings by /data/start_wilma.sh
CMD ["bash","./start_wilma.sh"]

# expose UI port and proxy port
EXPOSE 1234 9092
