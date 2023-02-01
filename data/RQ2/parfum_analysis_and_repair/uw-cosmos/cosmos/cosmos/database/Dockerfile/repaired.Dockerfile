FROM python:3.7

RUN apt-get update && apt-get install --no-install-recommends -y gcc default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir mysqlclient sqlalchemy requests alembic click

RUN mkdir /app
WORKDIR /app
COPY schema.py /app
COPY alembic.ini /app
COPY migrations /app/migrations

