FROM tomcat:6

RUN usermod -u {{ cpc_user_id.stdout }} www-data

COPY solr_cpc.xml /usr/local/tomcat/conf/Catalina/localhost/solr_cpc.xml