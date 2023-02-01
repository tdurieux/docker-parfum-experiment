FROM java
RUN apt-get install --no-install-recommends -y -qq tomcat7 && rm -rf /var/lib/apt/lists/*;
CMD JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 CATALINA_BASE=/var/lib/tomcat7 CATALINA_HOME=/usr/share/tomcat7 /usr/share/tomcat7/bin/catalina.sh run
EXPOSE 8080