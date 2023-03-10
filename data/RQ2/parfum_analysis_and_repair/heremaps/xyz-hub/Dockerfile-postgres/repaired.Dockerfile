FROM postgres:10

MAINTAINER Benjamin Rögner "benjamin.roegner@here.com"
MAINTAINER Lucas Ceni "lucas.ceni@here.com"
MAINTAINER Dimitar Goshev "dimitar.goshev@here.com"

ENV POSTGRES_PASSWORD password

RUN apt-get update && \
    apt-get -y --no-install-recommends install postgresql-10-postgis-2.5 && rm -rf /var/lib/apt/lists/*;
