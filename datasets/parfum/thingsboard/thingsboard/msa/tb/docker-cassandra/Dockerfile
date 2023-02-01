#
# Copyright © 2016-2022 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM thingsboard/openjdk11

RUN apt-get update
RUN apt-get install -y curl nmap procps gnupg2
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' | tee --append /etc/apt/sources.list.d/pgdg.list > /dev/null
RUN curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo 'deb http://downloads.apache.org/cassandra/debian 40x main' | tee --append /etc/apt/sources.list.d/cassandra.list > /dev/null
RUN curl -L https://downloads.apache.org/cassandra/KEYS | apt-key add -
ENV PG_MAJOR=12
RUN apt-get update
RUN apt-get install -y cassandra cassandra-tools postgresql-12
RUN update-rc.d cassandra disable
RUN update-rc.d postgresql disable
RUN sed -i.old '/ulimit/d' /etc/init.d/cassandra

COPY logback.xml ${pkg.name}.conf start-db.sh stop-db.sh start-tb.sh upgrade-tb.sh install-tb.sh ${pkg.name}.deb /tmp/

RUN chmod a+x /tmp/*.sh \
    && mv /tmp/start-tb.sh /usr/bin \
    && mv /tmp/upgrade-tb.sh /usr/bin \
    && mv /tmp/install-tb.sh /usr/bin \
    && mv /tmp/start-db.sh /usr/bin \
    && mv /tmp/stop-db.sh /usr/bin

RUN dpkg -i /tmp/${pkg.name}.deb
RUN rm /tmp/${pkg.name}.deb

RUN systemctl --no-reload disable --now ${pkg.name}.service > /dev/null 2>&1 || :

RUN mv /tmp/logback.xml ${pkg.installFolder}/conf \
    && mv /tmp/${pkg.name}.conf ${pkg.installFolder}/conf

ENV DATA_FOLDER=/data

ENV HTTP_BIND_PORT=9090
ENV DATABASE_TS_TYPE=cassandra

ENV PGDATA=/data/db
ENV CASSANDRA_DATA=/data/cassandra

ENV SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.PostgreSQLDialect
ENV SPRING_DRIVER_CLASS_NAME=org.postgresql.Driver
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/thingsboard
ENV SPRING_DATASOURCE_USERNAME=${pkg.user}
ENV SPRING_DATASOURCE_PASSWORD=postgres

ENV CASSANDRA_HOST=localhost
ENV CASSANDRA_PORT=9042
ENV CASSANDRA_HOME=/opt/cassandra

ENV PATH=$CASSANDRA_HOME/bin:$PATH
ENV PATH=$PATH:/usr/lib/postgresql/$PG_MAJOR/bin

ENV PGLOG=/var/log/postgres
ENV CASSANDRA_LOG=/var/log/cassandra

# postgres config
RUN mkdir -p $PGLOG
RUN chown -R ${pkg.user}:${pkg.user} $PGLOG
RUN chown -R ${pkg.user}:${pkg.user} /var/log/postgresql
RUN chown -R ${pkg.user}:${pkg.user} /var/run/postgresql

# cassandra config
RUN rm -rf /var/lib/cassandra
RUN chmod a+w /var/lib
RUN chown -R ${pkg.user}:${pkg.user} $CASSANDRA_LOG


RUN mkdir -p $DATA_FOLDER
RUN chown -R ${pkg.user}:${pkg.user} $DATA_FOLDER
RUN chown -R ${pkg.user}:${pkg.user} /var/log/${pkg.name}

RUN chmod 555 ${pkg.installFolder}/bin/${pkg.name}.jar

USER ${pkg.user}

EXPOSE 9090
EXPOSE 1883
EXPOSE 5683/udp
EXPOSE 5685/udp

VOLUME ["/data"]

CMD ["start-tb.sh"]
