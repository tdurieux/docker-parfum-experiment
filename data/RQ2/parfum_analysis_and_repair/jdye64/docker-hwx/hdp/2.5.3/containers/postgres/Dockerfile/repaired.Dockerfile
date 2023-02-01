FROM postgres
MAINTAINER Jeremy Dyer <jdye64@gmail.com>

ARG DDL_URL
ADD scripts/* /docker-entrypoint-initdb.d/
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget ${DDL_URL}
ADD pg_hba.conf /
