#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
FROM hyperledger/fabric-baseimage:_BASE_TAG_

ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/go/bin/:${PATH}"
ENV GOPATH "/opt/gopath"
ENV PGDATA "/usr/local/pgsql/data/"
ENV PGUSER "postgres"
ENV PGPASSWORD "postgres"
ENV PGVER _PGVER_
ENV HOSTADDR "127.0.0.1"
ENV LDAPPORT "389"
ENV LDAPUSER "admin"
ENV LDAPPASWD "adminpw"

# Avoid ERROR:
#   invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Update system
RUN apt-get -y update && apt-get -y install --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/^[[:blank:]]*#[[:blank:]]*en_US.UTF-8[[:blank:]]*UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN printf "LANG=en_US.UTF-8\nLANGUAGE=en_US.UTF-8\n" > /etc/default/locale
RUN dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8

# Install more test depedencies
RUN echo "mysql-server mysql-server/root_password password mysql" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password mysql" | debconf-set-selections
RUN apt-get -y install --no-install-recommends bc vim lsof sqlite3 haproxy postgresql-$PGVER \
                       postgresql-client-common postgresql-contrib-$PGVER isag jq git html2text \
                       debconf-utils zsh htop python2.7-minimal libpython2.7-stdlib \
                       mysql-client mysql-common mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y autoremove

# Configure and start postgres
RUN echo $PGUSER:$PGUSER | chpasswd
RUN mkdir -p $PGDATA && chown postgres:postgres $PGDATA
RUN su $PGUSER -c "/usr/lib/postgresql/$PGVER/bin/initdb -D $PGDATA"
RUN su $PGUSER -c "/usr/lib/postgresql/$PGVER/bin/pg_ctl start -D $PGDATA" &&\
                   sleep 10 &&\
                   psql -U postgres -h localhost -c "ALTER USER $PGUSER WITH PASSWORD '$PGPASSWORD';" &&\
                   su postgres -c "/usr/lib/postgresql/$PGVER/bin/pg_ctl stop"
RUN echo "host all  all    0.0.0.0/0  trust" >> ${PGDATA}/pg_hba.conf
RUN echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf

# Install slapd
RUN ls /tmp
COPY payload/*ldif /etc/ldap/
RUN printf  "slapd slapd/internal/generated_adminpw password $LDAPPASWD\n\
slapd slapd/password2 password $LDAPPASWD\n\
slapd slapd/internal/adminpw password $LDAPPASWD\n\
slapd slapd/password1 password $LDAPPASWD\n\
slapd slapd/domain string example.com\n\
slapd shared/organization string example.com" | debconf-set-selections && \
   sudo apt-get -y install --no-install-recommends slapd ldap-utils && rm -rf /var/lib/apt/lists/*;
RUN sed -i \
   "s@^[[:blank:]]*SLAPD_SERVICES=.*@SLAPD_SERVICES=\"ldap://$HOSTADDR:$LDAPPORT/ ldaps:/// ldapi:///\"@"\
   /etc/default/slapd
RUN /etc/init.d/slapd start && \
    ldapadd -h localhost -p 389 -D cn=$LDAPUSER,dc=example,dc=com -w $LDAPPASWD -f /etc/ldap/base.ldif && \
    ldapadd -h localhost -p 389 -D cn=$LDAPUSER,dc=example,dc=com -w $LDAPPASWD -f /etc/ldap/add-users.ldif && \
    /etc/init.d/slapd stop

# Install fabric-ca dependencies
RUN go get github.com/go-sql-driver/mysql
RUN go get github.com/lib/pq

# Use python2, not 3
RUN ln -s /usr/bin/python2.7 /usr/local/bin/python && chmod 777 /usr/local/bin/python

# Generate version-agnostic postgres command
RUN ln -s /usr/lib/postgresql/$PGVER/bin/postgres /usr/local/bin/postgres && chmod 777 /usr/local/bin/postgres

# Add docker-built execs for (potentially) alternative architecture
COPY payload/fabric-ca-client /usr/local/bin
RUN chmod +x /usr/local/bin/fabric-ca-client
COPY payload/fabric-ca-server /usr/local/bin
RUN chmod +x /usr/local/bin/fabric-ca-server

# Add start script to initialize adjunct servers
COPY payload/start.sh /start.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR ${GOPATH}/src/github.com/tjfoc/gmca
ENTRYPOINT [ "/start.sh" ]
CMD ["make", "fvt-tests"]
