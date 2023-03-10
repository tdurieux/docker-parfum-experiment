FROM python:3.9-slim

# Bash is installed for more convenient debugging.
RUN apt-get update && apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*

ENV AIRBYTE_ENTRYPOINT "python /airbyte/integration_code/main.py"

WORKDIR /airbyte/integration_code
COPY source_salesforce ./source_salesforce
COPY setup.py ./
COPY main.py ./
RUN pip install --no-cache-dir .

ENTRYPOINT ["python", "/airbyte/integration_code/main.py"]

LABEL io.airbyte.version=1.0.11
LABEL io.airbyte.name=airbyte/source-salesforce
