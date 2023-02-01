FROM python:3.7

WORKDIR /usr/src/app/

COPY . .

RUN pip3 install --no-cache-dir redis

RUN pip3 install --no-cache-dir sqlalchemy

RUN pip3 install --no-cache-dir requests

RUN pip3 install --no-cache-dir psycopg2

ENV INVENIO_POSTGRESQL_HOST=postgresql

ENV INVENIO_POSTGRESQL_DBNAME=invenio

ENV INVENIO_POSTGRESQL_DBPASS=dbpass123

ENV INVENIO_POSTGRESQL_DBUSER=invenio

CMD ["python", "app.py"]