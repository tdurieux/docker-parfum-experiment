# Multi-stage docker build. Builds data first, and then switches to pure MariaDB.

FROM mariadb:10.4 as generate

WORKDIR /usr/app

ENV KNEXFILE=./docker/mariadb/knexfile

# Install node
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Copy and install dependencies
COPY ./package*.json ./
RUN npm ci --no-audit
RUN npm i mysql --no-audit && npm cache clean --force;

# Copy repo
COPY . .

# Build it
COPY docker/mariadb/my.cnf /etc/mysql/my.cnf
RUN chmod +x docker/mariadb/build_db.sh
RUN docker/mariadb/build_db.sh

## Just the DB with data
FROM mariadb:10.4

COPY --from=generate /etc/mysql /etc/mysql
COPY --from=generate /data /data

ENTRYPOINT []
CMD [ "mysqld", "--user=root" ]
