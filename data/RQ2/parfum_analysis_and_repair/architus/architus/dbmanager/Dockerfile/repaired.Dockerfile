FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
RUN mkdir /app/current_migration

VOLUME /app/current_migration

WORKDIR /app
COPY dbmanager/dbmanager.py .
COPY dbmanager/migrations ./migrations
COPY dbmanager/cleanup ./cleanup

ENTRYPOINT ["python3", "-u", "dbmanager.py"]
