FROM kartoza/postgis:11.5-2.8

ADD auth_system/certs_keys_2048/postgres.crt /etc/ssl/certs/postgres.crt
ADD auth_system/certs_keys_2048/postgres.key /etc/ssl/private/postgres.key
ADD auth_system/certs_keys_2048/qgis_ca.crt /etc/ssl/certs/qgis_ca.crt

RUN chmod 400 /etc/ssl/private/postgres.key