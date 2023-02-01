FROM alpine:latest
MAINTAINER "The Alpine Project" <admin@jiobxn.com>
ARG LATEST="0"
ARG TOMCAT="8.0"
ARG JDK="8"

RUN apk update --no-cache && apk add openjdk${JDK} git subversion curl openssl tzdata bash --no-cache
RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN cd /tmp \
        && V=$(echo $TOMCAT |sed 's/\.//' |sed 's/5/0/') \
        && wget -c $(curl -s http://tomcat.apache.org/download-${V}.cgi |grep tar.gz |egrep "${TOMCAT}" |awk -F\" 'NR==1{print $2}') \
        && wget -c https://github.com/ran-jit/tomcat-cluster-redis-session-manager/releases/download/$(curl -s https://github.com/ran-jit/tomcat-cluster-redis-session-manager/tags |grep "releases/tag/" |head -1 |awk -F\" '{print $2}' |awk -F/ '{print $NF}')/tomcat-cluster-redis-session-manager.zip \
        && tar zxf apache-tomcat-*.tar.gz \
        && unzip tomcat-cluster-redis-session-manager.zip \
        && \rm apache-tomcat-*.tar.gz \
        && mv apache-tomcat-* /tomcat \
        && mv tomcat-cluster-redis-session-manager/lib/* /tomcat/lib/ \
        && mv tomcat-cluster-redis-session-manager/conf/* /tomcat/conf/ \
        && ln -s /tomcat/bin/* /usr/local/bin/ \
        && rm -rf /tmp/* \
        && \cp -a /tomcat/webapps /mnt/

RUN cd /tomcat/lib \
        && wget -c https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$(curl -s https://dev.mysql.com/downloads/connector/j/ |grep 'Connector/J' |awk 'END {print $2}').tar.gz \
        && jstl="https://repo1.maven.org/maven2/jstl/jstl/" && jstl_v=$(curl -s $jstl |grep "                   -" |awk -F\" 'END{print $2}' |awk -F/ '{print $1}') && wget -c "$jstl$jstl_v/jstl-$jstl_v.jar" \
        && c3p0="https://repo1.maven.org/maven2/com/mchange/c3p0/" && c3p0_v=$(curl -s $c3p0 |grep "                   -" |awk -F\" 'END{print $2}' |awk -F/ '{print $1}') && wget -c "$c3p0$c3p0_v/c3p0-$c3p0_v.jar" \
        && tomcat_v=$(version.sh |grep "Server version" |awk -F/ '{print $2}') \
        && wget -c https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/${tomcat_v}/tomcat-catalina-jmx-remote-${tomcat_v}.jar \
        && wget -c https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-catalina-ws/${tomcat_v}/tomcat-catalina-ws-${tomcat_v}.jar \
        && wget -c https://repo1.maven.org/maven2/org/apache/tomcat/tomcat-juli/${tomcat_v}/tomcat-juli-${tomcat_v}.jar \
        && wget -c https://repo1.maven.org/maven2/com/mchange/mchange-commons-java/0.2.10/mchange-commons-java-0.2.10.jar \
        && wget -c https://github.com/jiobxn/one/raw/master/Script/hello.jsp -O /mnt/webapps/ROOT/hello.jsp \
        && cp /mnt/webapps/ROOT/hello.jsp /tomcat/webapps/ROOT/ \
        && tar zxf mysql-connector-java-*.tar.gz \
        && mv mysql-connector-java-*/mysql-connector-java-*.jar new-mysql-connector-java-bin.jar \
        && rm -rf mysql-connector-java-* \
        && mv new-mysql-connector-java-bin.jar mysql-connector-java-bin.jar

VOLUME /tomcat/webapps

COPY tomcat.sh /tomcat.sh
RUN chmod +x /tomcat.sh

ENTRYPOINT ["/tomcat.sh"]

EXPOSE 8080 8443

CMD ["catalina.sh", "run"]

# docker build --build-arg TOMCAT=8.0 --build-arg JDK=8 -t tomcat .
# docker run -d --restart unless-stopped -v /docker/webapps:/tomcat/webapps -p 18080:8080 -p 18443:8443 -e TOM_USER=tom -e TOM_PASS=pass -e REDIS_SERVER=redhat.xyz --hostname tomcat tomcat
# docker run -it --rm tomcat --help
