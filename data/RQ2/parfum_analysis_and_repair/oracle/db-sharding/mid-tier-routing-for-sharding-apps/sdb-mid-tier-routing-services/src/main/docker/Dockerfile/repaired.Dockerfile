# /*
# ** Oracle Sharding Tools Library
# **
# ** Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
# ** Licensed under the Universal Permissive License v 1.0 as shown at 
# **   http://oss.oracle.com/licenses/upl 
# */

FROM tomcat:9.0-slim
VOLUME /tmp
ARG WAR_FILE
COPY ${WAR_FILE} /usr/local/tomcat/webapps/sdb-mid-tier-routing-services.war
RUN sh -c 'touch /usr/local/tomcat/webapps/sdb-mid-tier-routing-services.war'


# Define environment variables