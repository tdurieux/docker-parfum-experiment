FROM olbase

WORKDIR /openlibrary

# Setup db
USER postgres
RUN /etc/init.d/postgresql start \
  && createuser -s openlibrary \
  && createdb openlibrary \
  && psql openlibrary < openlibrary/core/users.sql \
  && psql openlibrary < openlibrary/core/schema.sql \
  && createdb coverstore \
  && psql coverstore < openlibrary/coverstore/schema.sql \
  && psql openlibrary < scripts/dev-instance/dev_db.pg_dump \
  && pg_ctlcluster 9.5 main stop

USER root

# oldev currently runs coverstore in the same container:
RUN mkdir -p /var/lib/coverstore \
    && chown openlibrary:openlibrary /var/lib/coverstore

COPY requirements*.txt ./
RUN pip install --disable-pip-version-check -r requirements_test.txt

COPY package*.json ./
RUN npm install

# Expose Open Library, Infobase, and Coverstore
EXPOSE 80 7000 8081 3000

# runs as root in order to access su to run as openlibrary and postgres users
CMD docker/ol-docker-start.sh
