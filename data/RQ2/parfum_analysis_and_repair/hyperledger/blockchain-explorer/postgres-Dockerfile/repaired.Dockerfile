# Copyright Tecnalia Research & Innovation (https://www.tecnalia.com)
# Copyright Tecnalia Blockchain LAB
#
# SPDX-License-Identifier: Apache-2.0

FROM postgres:10.4-alpine

# default database name for HLF Explorer db connection
ENV DATABASE_DATABASE 	fabricexplorer

# default username for HLF Explorer db connection
ENV DATABASE_USERNAME 	hppoc

# default password for HLF Explorer db connection
ENV DATABASE_PASSWORD 	password

RUN apk update \
 && apk add --no-cache jq \
 && apk add --no-cache nodejs \
 && apk add --no-cache sudo \
 && rm -rf /var/cache/apk/*

WORKDIR /opt

# Copy files
COPY app/persistence/fabric/postgreSQL/db/explorerpg.sql  /opt/explorerpg.sql
COPY app/persistence/fabric/postgreSQL/db/updatepg.sql    /opt/updatepg.sql
COPY app/persistence/fabric/postgreSQL/db/createdb.sh     /docker-entrypoint-initdb.d/createdb.sh
COPY app/persistence/fabric/postgreSQL/db/processenv.js   /opt/processenv.js