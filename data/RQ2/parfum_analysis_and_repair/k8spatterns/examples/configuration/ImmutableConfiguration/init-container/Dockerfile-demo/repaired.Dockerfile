FROM tomcat:8.0
# Fix for OpenShift restricted permissions
RUN chmod -R g+rw /usr/local/tomcat
ADD demo.war /usr/local/tomcat/webapps/demo.war