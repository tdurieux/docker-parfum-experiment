FROM mdillon/postgis:11

ENV POSTGRES_USER safecast

RUN echo "listen_addresses = '*'" >> /etc/postgresql/postgresql.conf