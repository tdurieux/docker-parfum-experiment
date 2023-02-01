FROM tomcat:8

ADD conf/ /usr/local/tomcat/conf/

RUN ["rm", "-r", "/usr/local/tomcat/webapps"]

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
