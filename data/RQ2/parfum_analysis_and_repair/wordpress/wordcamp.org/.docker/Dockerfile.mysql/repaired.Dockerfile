FROM mysql:5.7

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        nano \
        vim && rm -rf /var/lib/apt/lists/*;

# Set default password
ENV MYSQL_ROOT_PASSWORD=mysql
ENV MYSQL_DATABASE=wordcamp_dev

ADD data/wordcamp_dev.sql /docker-entrypoint-initdb.d/data.sql

EXPOSE 3306
