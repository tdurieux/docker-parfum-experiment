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

# Docker image that installs mariadb (mysql) and creates an empty nibrs staging database
# Typically, this image is only used in demostate and for testing.  In a real jurisdiction, there
# will be a nibrs staging database elsewhere.

# Before building this image, you need to copy ../../db/schema-mysql.sql into the files/ directory

FROM alpine

RUN apk add --update bash mariadb mariadb-client

WORKDIR /usr

RUN bin/mysql_install_db --user=root

COPY files/server-config.sh /tmp/
COPY files/schema-mysql.sql /tmp/
RUN chmod a+x /tmp/server-config.sh && /tmp/server-config.sh

RUN sed -i s/skip-networking/#skip-networking/g /etc/my.cnf.d/mariadb-server.cnf

CMD ["bin/mysqld_safe", "--user=root"]
