FROM postgres:10

ENV POSTGRES_USER postgres

ADD ./config/sql /config/sql
ADD ./docker/entrypoint.postgres.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "postgres" ]
