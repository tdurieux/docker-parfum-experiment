FROM mariadb:10.4.5

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    gettext \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

ADD ./docker/ /

ENTRYPOINT ["/phraseanet-entrypoint.sh"]
CMD ["mysqld","--sql_mode="]
