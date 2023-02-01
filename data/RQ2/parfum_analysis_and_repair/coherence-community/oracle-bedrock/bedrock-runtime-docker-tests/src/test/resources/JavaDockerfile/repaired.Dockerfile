FROM oraclelinux:7.1

RUN yum -y install tar && rm -rf /var/cache/yum

COPY jre.tar.gz jre.tar.gz

RUN mkdir java \
    && tar --strip-components 1 -xf jre.tar.gz -C java \
    && rm jre.tar.gz

ENV JAVA_HOME=/java
