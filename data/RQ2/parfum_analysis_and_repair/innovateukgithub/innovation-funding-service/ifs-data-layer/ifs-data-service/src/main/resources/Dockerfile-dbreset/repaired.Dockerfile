FROM boxfuse/flyway:5.2.4
VOLUME /tmp
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update -y && apt-get install --no-install-recommends -y mysql-client ldap-utils uuid-runtime && rm -rf /var/lib/apt/lists/*;
COPY db/ /flyway/sql/db
COPY db/*.sh /

RUN touch /flyway/flyway.conf && chgrp -R 0 /flyway/flyway.conf && chmod -R g+rwX /flyway/flyway.conf

RUN chgrp -R 0 /*.sh && chmod -R g+rwX /*.sh && \
    chgrp -R 0 /usr/local/bin/flyway && chmod -R g+rwX /usr/local/bin/flyway && \
    chgrp -R 0 /flyway && chmod -R g+rwX /flyway

RUN echo 'TLS_REQCERT allow' >> /etc/ldap/ldap.conf
