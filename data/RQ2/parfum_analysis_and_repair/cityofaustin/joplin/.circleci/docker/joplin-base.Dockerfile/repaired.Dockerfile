# joplin-base

FROM python:3.7.5-slim-stretch as joplin-base

# jq for sanitizing backup data on hosted container
RUN apt-get update && apt-get install --no-install-recommends -y gnupg curl jq git && rm -rf /var/lib/apt/lists/*;
# dependencies required for psycopg2
RUN apt-get install --no-install-recommends -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv

# PostgreSQL 10
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list \
    && curl -f -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

# Set Port
ENV PORT ${PORT:-80}
EXPOSE $PORT
