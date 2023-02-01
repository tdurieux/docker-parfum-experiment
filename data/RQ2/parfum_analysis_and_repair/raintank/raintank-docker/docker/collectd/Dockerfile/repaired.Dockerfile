FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://packagecloud.io/raintank/raintank/ubuntu/ trusty main" > /etc/apt/sources.list.d/raintank.list
RUN curl -f https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common supervisor && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
RUN locale-gen $LANG
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN apt-get update
RUN apt-get install --no-install-recommends collectd=5.5.0-zrt12~trusty -y && rm -rf /var/lib/apt/lists/*;

COPY kafka.conf /etc/collectd/collectd.conf.d/kafka.conf
COPY write_graphite.conf /etc/collectd/collectd.conf.d/write_graphite.conf

ADD supervisor/collectd.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n"]
