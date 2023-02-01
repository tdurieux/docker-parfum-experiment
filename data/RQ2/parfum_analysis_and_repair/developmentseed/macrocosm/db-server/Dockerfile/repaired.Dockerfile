FROM fedora:21

# Install PostgreSQL
RUN yum install -y postgresql-server postgresql-contrib && rm -rf /var/cache/yum

# Install PostGIS
RUN yum install -y postgis && rm -rf /var/cache/yum

EXPOSE 5432

COPY docker-start.sh /start.sh
COPY script /install/script

CMD ["/start.sh"]
