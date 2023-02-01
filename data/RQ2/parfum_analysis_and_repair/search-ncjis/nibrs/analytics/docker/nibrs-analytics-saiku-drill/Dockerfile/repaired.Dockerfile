#
# Copyright 2016 SEARCH-The National Consortium for Justice Information and Statistics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ojbc/saiku:ojbc-3.17-saml

# set this arg to dev to create an image where the default (admin) saiku user has admin privileges
# do this by passing --build-arg MODE=dev
ARG MODE=prod


WORKDIR /tmp

COPY files/server-config.sh /tmp/
COPY files/Analytics.connection.json /tmp/

# need to copy this from ../../mondrian/NIBRSAnalyticsMondrianSchema.xml to files/
COPY files/NIBRSAnalyticsMondrianSchema.xml /tmp/

RUN sed -Ei "s/Table(.+)\//Table\1 schema=\"dfs.nibrs\"\//g" /tmp/NIBRSAnalyticsMondrianSchema.xml

### FILE HAS BEEN MOVED - Jd 5/7/21
#RUN curl -O https://www-us.apache.org/dist/drill/drill-1.17.0/apache-drill-1.17.0.tar.gz
RUN curl -f -O https://archive.apache.org/dist/drill/drill-1.17.0/apache-drill-1.17.0.tar.gz


RUN tar -xvf apache-drill-1.17.0.tar.gz && \
  mv apache-drill-1.17.0/jars/jdbc-driver/drill-jdbc-all-1.17.0.jar /opt/saiku-server/tomcat/webapps/saiku/WEB-INF/lib/ && \
  rm -rf apache-drill-1.17.0 && rm apache-drill-1.17.0.tar.gz

RUN chmod a+x /tmp/server-config.sh
RUN /tmp/server-config.sh ${MODE}

COPY files/help.html /opt/saiku-server/tomcat/webapps/ROOT/
RUN sed -i "270i <a href='#' onclick='window.open(\"help.html\");return false;'>About this dataset...</a>" /opt/saiku-server/tomcat/webapps/ROOT/index.html

COPY files/setenv.sh /opt/saiku-server/tomcat/bin/

RUN cd /opt/saiku-server/tomcat

CMD ["/opt/saiku-server/start-saiku.sh"]
