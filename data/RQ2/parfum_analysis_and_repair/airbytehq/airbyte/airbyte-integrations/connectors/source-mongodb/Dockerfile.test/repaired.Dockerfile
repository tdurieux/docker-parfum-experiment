FROM mongo:4.0.23

COPY ./integration_tests /integration_tests

RUN echo "mongorestore --archive=integration_tests/dump/analytics.archive" > /docker-entrypoint-initdb.d/init.sh

LABEL io.airbyte.version=0.1.0
LABEL io.airbyte.name=airbyte/mongodb-integration-test-seed