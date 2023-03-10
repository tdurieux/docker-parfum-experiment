FROM fishtownanalytics/dbt:1.0.0
COPY --from=airbyte/base-airbyte-protocol-python:0.1.1 /airbyte /airbyte

# Install SSH Tunneling dependencies
RUN apt-get update && apt-get install --no-install-recommends -y jq sshpass && rm -rf /var/lib/apt/lists/*;

WORKDIR /airbyte
COPY entrypoint.sh .
COPY build/sshtunneling.sh .

WORKDIR /airbyte/normalization_code
COPY normalization ./normalization
COPY setup.py .
COPY dbt-project-template/ ./dbt-template/
COPY dbt-project-template-mysql/* ./dbt-template/

# Install python dependencies
WORKDIR /airbyte/base_python_structs
RUN pip install --no-cache-dir .

WORKDIR /airbyte/normalization_code
RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir dbt-mysql==1.0.0

WORKDIR /airbyte/normalization_code/dbt-template/
# Download external dbt dependencies
RUN dbt deps

WORKDIR /airbyte
ENV AIRBYTE_ENTRYPOINT "/airbyte/entrypoint.sh"
ENTRYPOINT ["/airbyte/entrypoint.sh"]

LABEL io.airbyte.name=airbyte/normalization-mysql
