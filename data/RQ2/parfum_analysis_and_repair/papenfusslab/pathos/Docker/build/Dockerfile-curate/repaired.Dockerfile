FROM tomcat:7-jre7

ADD tomcat-users.xml    /usr/local/tomcat/conf/
ADD PathOS.war          /usr/local/tomcat/webapps/
ADD pathos.properties   /etc/pathos/
ADD links.config        /etc/pathos/
ADD FilterRules.groovy  /etc/
RUN mkdir -p /Report /Pathology /Panels /var/pathos/cache
ADD Template_default_var.docx  /Report
ADD Template_default_neg.docx  /Report
ADD Template_default_fail.docx /Report
ENV JAVA_OPTS="-server -Dgrails.env=pa_local -Dpathos.config=/etc/pathos/pathos.properties"