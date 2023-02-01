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

# Docker image that installs mariadb (mysql) and loads the data into the db
# user is analytics

# to connect to the db from localhost, assuming you've mapped host port 23306 to container 3306, like this:
#   docker run -d --rm --name nibrs-analytics-db -p 23306:3306 searchncjis/nibrs-analytics-db
# run:
#   mysql -u analytics -h localhost -P 23306 --protocol=tcp

FROM alpine

# by default, the image includes a demo dataset so that containers can start with a test/demo set of data, ready to go.
# however, in a production environment, you typically want to bring up an empty database that will subsequently be loaded
# with real NIBRS data, using the loading process in the nibrs-load image. passing any value other than Y via --build-arg
# will skip the loading of the demo/test database.
ARG preload=Y

RUN apk add --update bash mariadb mariadb-client

WORKDIR /usr

RUN bin/mysql_install_db --user=root

COPY files/server-config.sh /tmp/
COPY files/search_nibrs_dimensional.sql.gz /tmp/
RUN chmod a+x /tmp/server-config.sh
RUN /tmp/server-config.sh ${preload}

RUN sed -i s/skip-networking/#skip-networking/g /etc/my.cnf.d/mariadb-server.cnf

CMD ["bin/mysqld_safe", "--user=root"]
