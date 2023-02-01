FROM python:3

RUN pip install --no-cache-dir zc.buildout psycopg2-binary

WORKDIR /app
COPY . .

RUN buildout install prod postgresql

ENTRYPOINT ["bin/gtfsdb-load"]
