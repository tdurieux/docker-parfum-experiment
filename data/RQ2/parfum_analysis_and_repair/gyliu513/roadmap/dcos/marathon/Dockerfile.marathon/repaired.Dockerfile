MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

## Install OpenJDK 8
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:openjdk-r/ppa

RUN apt-get update

RUN apt-get -y --no-install-recommends install openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN update-java-alternatives -s $(update-java-alternatives -l | grep "java-1.8" | cut -f3 -d" ")

# Copy pre-build marathon to image
#COPY ./marathon /opt

WORKDIR /opt

ADD http://downloads.mesosphere.com/marathon/v0.11.1/marathon-0.11.1.tgz /opt/

RUN tar zxvf marathon-0.11.1.tgz && rm marathon-0.11.1.tgz

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so

WORKDIR /opt/marathon-0.11.1

COPY log4j.properties /opt/marathon-0.11.1/

RUN mkdir -p /opt/marathon-0.11.1/log

ENV JAVA_OPTS -Dlog4j.configuration=file:///opt/marathon-0.11.1/log4j.properties

ENTRYPOINT ["./bin/start"]
