# This docker image is meant for executing our database migrations.
# All of the migrations code and seed data must be mounted into the container
# as a volume for the migrations to run.

FROM python:3.9-slim-buster

WORKDIR /migrations

# install dependency to run the makefile
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# install python dependencies to run our database migrations with alembic
COPY ./setup.py ./setup.cfg makefile make.xsh ./
RUN mkdir -p ./src/migrations
RUN python -m pip install -e .

WORKDIR /migrations/src/

ENTRYPOINT [ "alembic" ]
