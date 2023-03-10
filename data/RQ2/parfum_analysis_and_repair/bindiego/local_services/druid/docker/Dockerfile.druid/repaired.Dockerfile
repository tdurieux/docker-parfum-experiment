FROM ubuntu:16.04
MAINTAINER Bin Wu <bin.wu@ptengine.com>

USER root

# update ubuntu repo for China
RUN rm /etc/apt/sources.list
ADD ./docker/sources.list.xenial /etc/apt/sources.list
#RUN apt-get clean && \
  #apt-get update --fix-missing

# install ubuntu packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    libkrb5-dev \
    curl \
    python \
    git \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# set jre version
ENV JRE_FILE jre-8u111-linux-x64.tar.gz

# download jre
RUN mkdir -p /opt/tools
RUN cd \
  && curl -f -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" \
    https://download.oracle.com/otn-pub/java/jdk/8u111-b14/$JRE_FILE \
    > $JRE_FILE \
  && tar -xzf "$JRE_FILE" -C /opt/tools/ \
  && rm "$JRE_FILE" \
  && ln -s /opt/tools/jre1.8.0_111 /opt/tools/jre

# set path for node realated commands
ENV JAVA_HOME /opt/tools/jre
ENV PATH $PATH:/opt/tools/jre/bin

# load druid code
ENV DRUID_VER 0.9.2
RUN mkdir -p /opt/druid
ADD ./druid-$DRUID_VER /opt/druid

# setup workspace
WORKDIR /opt/druid

# setup supervisor
ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add supplementary realtime node startup script
ADD docker/realtime.sh /opt/druid/bin/realtime.sh

# Set the timezone to UTC according to druid best practices
RUN echo "Etc/UTC" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
#RUN timedatectl set-timezone Etc/UTC

# expose ports, 8080 for service, 17071 for jmx
EXPOSE 48081 48082 48083 48084 48085 48086 47071 47072

# add realtime node spec file
ADD docker/ptengine_realtime.spec /opt/druid/ptengine_realtime.spec

# start application
# ENTRYPOINT ["/opt/druid/ptrun"]
# CMD ["broker", "start"]
CMD ["/usr/bin/supervisord"]
