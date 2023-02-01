FROM scottcame/piet

WORKDIR /tmp

#### todo: remove this once piet is rebuilt w new mondrian-rest on 2/14
COPY mondrian-rest.war /usr/local/tomcat/webapps/

RUN cd /usr/local/tomcat/webapps && unzip -d mondrian-rest mondrian-rest.war

RUN curl -O https://www-us.apache.org/dist/drill/drill-1.17.0/apache-drill-1.17.0.tar.gz

RUN tar -xvf apache-drill-1.17.0.tar.gz && \
  mv apache-drill-1.17.0/jars/jdbc-driver/drill-jdbc-all-1.17.0.jar /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/ && \
  mv apache-drill-1.17.0/jars/3rdparty/*.jar /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/ && \
  mv apache-drill-1.17.0/jars/classb/*.jar /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/ && \
  rm -rf apache-drill-1.17.0 && rm apache-drill-1.17.0.tar.gz

RUN curl -O https://repo1.maven.org/maven2/com/sun/jersey/jersey-server/1.19.4/jersey-server-1.19.4.jar && \
  curl -O https://repo1.maven.org/maven2/com/sun/jersey/jersey-core/1.19.4/jersey-core-1.19.4.jar && \
  mv jersey-*.jar  /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/

RUN curl -O https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.4.26.v20200117/jetty-server-9.4.26.v20200117.jar && \
  mv jetty*.jar /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/

RUN rm /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/gson-2.2.4.jar && \
  curl -O https://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.6/gson-2.8.6.jar && \
  mv gson-2.8.6.jar /usr/local/tomcat/webapps/mondrian-rest/WEB-INF/lib/

COPY files/application.properties /usr/local/tomcat/shared/config/

COPY files/*.json /usr/local/tomcat/shared/

COPY files/catalina.sh /usr/local/tomcat/bin/

RUN mkdir -p /usr/local/tomcat/webapps/piet-static
COPY files/ncsxlogo.* /usr/local/tomcat/webapps/piet-static/

COPY files/NIBRSAnalyticsMondrianSchema.8.xml /usr/local/tomcat/shared/
RUN sed -Ei "s/Table(.+)\//Table\1 schema=\"dfs.nibrs\"\//g" /usr/local/tomcat/shared/NIBRSAnalyticsMondrianSchema.8.xml
