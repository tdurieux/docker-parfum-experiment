FROM postgres:9.6

LABEL maintainer = "HMCTS Evidence Team <https://github.com/hmcts>"

COPY init-db.sh /docker-entrypoint-initdb.d

EXPOSE 5432