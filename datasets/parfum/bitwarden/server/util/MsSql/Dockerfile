FROM mcr.microsoft.com/mssql/server:2017-CU18-ubuntu-16.04

LABEL com.bitwarden.product="bitwarden"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY backup-db.sql /
COPY backup-db.sh /
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh \
    && chmod +x /backup-db.sh

# Does not work unfortunately (https://github.com/bitwarden/server/issues/286)
RUN /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false

HEALTHCHECK --start-period=120s --timeout=3s CMD /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U sa -P ${SA_PASSWORD} -Q "SELECT 1" || exit 1

ENTRYPOINT ["/entrypoint.sh"]
