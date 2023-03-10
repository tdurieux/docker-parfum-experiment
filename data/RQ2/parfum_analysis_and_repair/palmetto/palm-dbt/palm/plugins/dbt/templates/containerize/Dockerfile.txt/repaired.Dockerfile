FROM fishtownanalytics/dbt:{{dbt_version}}
COPY . /app/
WORKDIR /app
ENV PYTHONPATH=${PYTHONPATH}:${PWD}

RUN ./scripts/entrypoint.sh
RUN dbt clean && dbt deps

ENTRYPOINT [ "" ]