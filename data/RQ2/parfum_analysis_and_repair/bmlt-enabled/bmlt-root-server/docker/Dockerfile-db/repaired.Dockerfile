FROM public.ecr.aws/bitnami/mariadb:10.2.36

ADD docker/sample-bmlt-schema.sql /docker-entrypoint-initdb.d/sample-bmlt-schema.sql