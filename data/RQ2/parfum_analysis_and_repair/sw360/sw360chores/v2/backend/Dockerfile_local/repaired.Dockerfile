# Copyright Bosch Software Innovations GmbH, 2017.
# Part of the SW360 Portal Project.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM tomcat:9-jdk11
RUN apt-get update && apt-get install --no-install-recommends -y gettext patch && rm -rf /var/lib/apt/lists/*

# TOMCAT SETTINGS
COPY catalina.properties.patch /usr/local/tomcat/conf/catalina.properties.patch
RUN cd /usr/local/tomcat/conf/ && patch -b < catalina.properties.patch
RUN sed -i -e 's/<Engine/<Engine startStopThreads="0" /g' -e 's/<Host/<Host startStopThreads="0" /g' /usr/local/tomcat/conf/server.xml
COPY  build/tomcat/slim-wars/* /usr/local/tomcat/webapps/
COPY  build/tomcat/libs/* /usr/local/tomcat/shared/

# COUCH DB SETTINGS
ENV COUCHDB_URL="http://172.17.0.1:5984"
ENV COUCHDB_USER=""
ENV COUCHDB_PASSWORD=""
ENV COUCHDB_DBNAME_SW360="sw360db"
ENV COUCHDB_DBNAME_USERDB="sw360users"
ENV COUCHDB_DBNAME_ATTACHMENTS="sw360attachments"
ENV COUCHDB_DBNAME_FOSSOLOGYKEYS="sw360fossologykeys"
ENV COUCHDB_DBNAME_VULNERABILITY_MANAGEMENT="sw360vm"
COPY couchdb.properties.template /etc/sw360/couchdb.properties.template
COPY entrypoint.sh entrypoint.sh
CMD ["bash","entrypoint.sh"]