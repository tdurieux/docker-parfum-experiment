# Note: be sure the postgres image tag matches
# the one used to run the database
FROM postgres:9.6

# install python and pip
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get install --no-install-recommends -y python3 python3-pip curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

# install script dependencies
RUN python3 -m pip install boto3 xonsh

WORKDIR /app

COPY backup_or_restore.py ./backup_or_restore.py
COPY scripts/restore-database-script.sh ./scripts/restore-database-script.sh
COPY scripts/restore-dev-database-script.sh ./scripts/restore-dev-database-script.sh
COPY scripts/wait-for-postgres-init.sh ./scripts/wait-for-postgres-init.sh
