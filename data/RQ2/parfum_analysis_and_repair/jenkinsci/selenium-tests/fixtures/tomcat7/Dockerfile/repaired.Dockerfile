#
# Runs Tomcat7 on Ubuntu at port 8080, with the admin app
#
# The admin user has username 'admin' and password 'tomcat'
#

FROM ubuntu

# Tomcat7 is from Universe
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y tomcat7 tomcat7-admin && rm -rf /var/lib/apt/lists/*;

# configure the admin user
RUN echo '<tomcat-users><role rolename="tomcat"/><role rolename="manager-gui"/><role rolename="admin-gui"/><role rolename="manager-script"/><user username="admin" password="tomcat" roles="tomcat,admin-gui,manager-gui,manager-script"/></tomcat-users>' > /etc/tomcat7/tomcat-users.xml

EXPOSE 8080
CMD CATALINA_BASE=/var/lib/tomcat7/ /usr/share/tomcat7/bin/catalina.sh run
