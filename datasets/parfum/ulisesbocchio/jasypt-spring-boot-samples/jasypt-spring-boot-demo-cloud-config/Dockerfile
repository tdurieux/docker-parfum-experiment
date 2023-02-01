FROM openjdk:12

ENV JAVA_CONF_DIR=$JAVA_HOME/conf

RUN yum install -y nmap-ncat.x86_64
RUN bash -c '([[ ! -d $JAVA_SECURITY_DIR ]] && ln -s $JAVA_HOME/lib $JAVA_HOME/conf) || (echo "Found java conf dir, package has been fixed, remove this hack"; exit -1)'

ADD ./target/jasypt-spring-boot-demo-cloud-config-0.1-SNAPSHOT.jar app.jar
ADD ./entrypoint.sh entrypoint.sh
VOLUME /tmp
VOLUME /target
RUN bash -c 'touch /app.jar'
EXPOSE 8888
ENTRYPOINT ["./entrypoint.sh"]