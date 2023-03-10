FROM quintenk/jdk7-oracle
MAINTAINER Chris Fregly "chris@fregly.com"

# install tomcat:7
RUN apt-get -y --no-install-recommends install tomcat7 && rm -rf /var/lib/apt/lists/*;
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/default/tomcat7

# install git  
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# install gradle
RUN apt-get -y --no-install-recommends install gradle && rm -rf /var/lib/apt/lists/*;

# clone the eureka project
RUN git clone https://github.com/Netflix/eureka

# switch into eureka to run gradle
WORKDIR eureka

# build the eureka project
RUN ./gradlew clean build

# copy the war to the tomcat directory
RUN cp ~/eureka/eureka-server/build/libs/*.war /var/lib/tomcat7/webapps/

# start tomcat
EXPOSE 8080
CMD service tomcat7 start && tail -f /var/log/tomcat7/catalina.out
