FROM mongo:4.4

COPY /src/test/resources/db/*.js /docker-entrypoint-initdb.d/