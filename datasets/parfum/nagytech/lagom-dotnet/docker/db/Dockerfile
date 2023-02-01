FROM microsoft/mssql-server-linux:2017-latest
WORKDIR /app

COPY ./entrypoint.sh ./migrate.sh ./
RUN chmod +x ./*.sh

ENV PATH="/opt/mssql-tools/bin:${PATH}"

ENTRYPOINT [ "/app/entrypoint.sh" ]
