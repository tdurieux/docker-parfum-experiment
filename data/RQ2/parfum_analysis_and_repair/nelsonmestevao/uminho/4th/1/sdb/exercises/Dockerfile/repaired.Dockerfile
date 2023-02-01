FROM ubuntu:18.04

RUN apt-get update && apt-get -yq upgrade

RUN apt-get -y --no-install-recommends install software-properties-common curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz
RUN tar xzf apache-tomcat-7.0.55.tar.gz && rm apache-tomcat-7.0.55.tar.gz

CMD apache-tomcat-7.0.55/bin/startup.sh && tail -f apache-tomcat-7.0.55/logs/catalina.out

COPY myapps /apache-tomcat-7.0.55/webapps/

EXPOSE 8080
