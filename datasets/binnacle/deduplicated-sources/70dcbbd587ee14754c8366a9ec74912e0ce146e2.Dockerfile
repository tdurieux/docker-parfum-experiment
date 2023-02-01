FROM mcr.microsoft.com/mssql/server:2017-latest
WORKDIR /tmp/backup
RUN wget -q  https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak 
COPY restore.sql .
COPY restore.sh .
COPY entrypoint.sh .
CMD ["/bin/bash", "/tmp/backup/entrypoint.sh"]

