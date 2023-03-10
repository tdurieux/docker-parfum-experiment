# Copyright 2020 Google Inc.
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

FROM perl:slim

ARG ORA2PG_VERSION=21.0
ARG ORACLE_ODBC_VERSION=12.2

# Install general requirements
RUN apt-get update \
    && apt-get install --no-install-recommends wget -y \
    && apt-get install --no-install-recommends unzip -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install Ora2Pg
RUN wget --output-document=/tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v${ORA2PG_VERSION}.zip
RUN unzip -d /tmp/ /tmp/ora2pg.zip
RUN cd /tmp/ora2pg-${ORA2PG_VERSION}/ && perl Makefile.PL && make && make install

# Install Oracle ODBC required packages
ENV ORACLE_SID oracle
ENV ORACLE_HOME /usr/lib/oracle/${ORACLE_ODBC_VERSION}/client64

RUN apt-get -y --no-install-recommends install --fix-missing --upgrade vim alien unixodbc-dev wget libaio1 libaio-dev && rm -rf /var/lib/apt/lists/*;

COPY oracle/*.rpm ./
RUN alien -i *.rpm && rm *.rpm \
    && echo "/usr/lib/oracle/${ORACLE_ODBC_VERSION}/client64/lib/" > /etc/ld.so.conf.d/oracle.conf \
    && ln -s /usr/include/oracle/${ORACLE_ODBC_VERSION}/client64 $ORACLE_HOME/include \
    && ldconfig -v

# Instal DBI module with Oracle, Postgres, and Compress::Zlib module
RUN perl -MCPAN -e 'install DBI' &&\
    perl -MCPAN -e 'install DBD::Pg' &&\
    perl -MCPAN -e 'install DBD::Oracle' &&\
    perl -MCPAN -e 'install Bundle::Compress::Zlib'


# Create directories
RUN mkdir /config /data
RUN ln -s /config/ora2pg.conf /etc/ora2pg/ora2pg.conf

VOLUME /config
VOLUME /data

WORKDIR /

CMD ["ora2pg"]
