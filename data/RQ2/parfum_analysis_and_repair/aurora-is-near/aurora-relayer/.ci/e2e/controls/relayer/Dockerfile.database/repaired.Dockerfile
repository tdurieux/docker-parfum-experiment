ARG RAW_DATABASE_IMAGE_NAME
FROM ${RAW_DATABASE_IMAGE_NAME}

COPY test/fixtures/mocks_init.sh /docker-entrypoint-initdb.d/