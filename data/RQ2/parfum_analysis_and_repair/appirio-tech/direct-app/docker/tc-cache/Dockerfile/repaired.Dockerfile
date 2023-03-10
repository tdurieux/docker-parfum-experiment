FROM centos:6

RUN yum install -y \
  java-1.7.0-openjdk-devel.x86_64 \
  unzip \
  tar \
  wget && rm -rf /var/cache/yum

WORKDIR /data

RUN ["wget", "-O", "/data/jboss-4.2.3.zip", "http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjboss%2Ffiles%2FJBoss%2FJBoss-4.2.3.GA"]

RUN ["unzip", "/data/jboss-4.2.3.zip"]

ENV JAVA_HOME /usr/lib/jvm/jre-1.7.0-openjdk.x86_64
ENV JBOSS_HOME /data/jboss-4.2.3.GA

# updated for ip bind
COPY start-jboss.sh /data/jboss-4.2.3.GA/bin/
COPY cache /data/jboss-4.2.3.GA/server/cache/

RUN rm /data/jboss-4.2.3.zip

CMD ["/data/jboss-4.2.3.GA/bin/start-jboss.sh"]

EXPOSE 22
