FROM kartoza/postgis:11.0-2.5

ADD auth_system/certs_keys/postgres.crt /etc/ssl/certs/postgres_cert.crt
ADD auth_system/certs_keys/postgres.key /etc/ssl/private/postgres_key.key
ADD auth_system/certs_keys/issuer_ca_cert.pem /etc/ssl/certs/issuer_ca_cert.pem

RUN chmod 400 /etc/ssl/private/postgres_key.key
