FROM restic/restic:0.9.6

RUN apk update && apk add --no-cache python3 dcron mariadb-client postgresql-client

ADD . /restic-compose-backup
WORKDIR /restic-compose-backup
RUN pip3 install --no-cache-dir -U pip setuptools wheel && pip3 install --no-cache-dir -e .
ENV XDG_CACHE_HOME=/cache

ENTRYPOINT []
CMD ["./entrypoint.sh"]
