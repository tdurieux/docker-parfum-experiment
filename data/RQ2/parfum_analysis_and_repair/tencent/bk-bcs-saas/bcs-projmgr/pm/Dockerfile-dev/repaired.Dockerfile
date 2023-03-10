FROM gradle:4.8.1-jre8-slim
USER root
WORKDIR /data

RUN apt-get update && apt-get install --no-install-recommends -y procps curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir /usr/local/java && wget -qO- https://bkopen-1252002024.file.myqcloud.com/bcs/jdk-8u192-linux-x64.tar.gz | tar xzf - -C /usr/local/java/
ENV JAVA_HOME="/usr/local/java/jdk1.8.0_192"
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV CLASSPATH="$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar"

ADD . .
RUN gradle -DmysqlURL=svr-mariadb:3306 -DmysqlUser=root -DmysqlPasswd='open-bcs-saas' :service:service-project:copyToRelease