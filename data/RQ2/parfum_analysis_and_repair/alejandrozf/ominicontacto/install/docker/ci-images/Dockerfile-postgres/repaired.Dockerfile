# para usarlo individualmente, 'docker pull alejandrozf/docker-stuff:postgres-plpython-template1'
FROM postgres:11

RUN apt-get update && apt-get -y --no-install-recommends install python-pip postgresql-plperl-11 && rm -rf /var/lib/apt/lists/*;

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN pip install --no-cache-dir flake8

COPY install_language.sh /docker-entrypoint-initdb.d

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
