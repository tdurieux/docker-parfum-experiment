FROM postgres:12

RUN apt-get update && apt-get -y --no-install-recommends install postgresql-plpython3-12 && rm -rf /var/lib/apt/lists/*;

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
