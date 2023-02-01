FROM ubuntu:20.04

ARG PG_VERSION
ARG DEBIAN_FRONTEND=noninteractive

# Install PostgreSQL
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget ca-certificates gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get --yes remove postgresql\*
RUN apt-get -y --no-install-recommends install postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} && rm -rf /var/lib/apt/lists/*;

# Configure locale
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8

# Install Python modules
RUN apt -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir sqlparse && \
	pip3 install --no-cache-dir requests && \
	pip3 install --no-cache-dir pyzipper && \
	pip3 install --no-cache-dir coverage && \
	pip3 install --no-cache-dir coveralls

# Add db_converter
ADD ./db_converter /usr/share/db_converter

# Reduce images size
RUN rm -rf /tmp/*
RUN apt-get purge -y --auto-remove
RUN apt-get clean -y autoclean
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 5432

ENV PG_VERSION=${PG_VERSION}

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD motd /etc/motd

WORKDIR /usr/share/db_converter

ENTRYPOINT exec /entrypoint.sh
