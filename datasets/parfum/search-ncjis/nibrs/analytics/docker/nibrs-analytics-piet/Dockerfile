FROM scottcame/piet

RUN curl -OSsL https://downloads.mariadb.com/Connectors/java/connector-java-2.5.4/mariadb-java-client-2.5.4.jar && \
  mv mariadb-java-client-2.5.4.jar /usr/local/tomcat/shared/

COPY mondrian-connections.json /usr/local/tomcat/shared/
COPY NIBRSAnalyticsMondrianSchema.8.xml /usr/local/tomcat/shared/
