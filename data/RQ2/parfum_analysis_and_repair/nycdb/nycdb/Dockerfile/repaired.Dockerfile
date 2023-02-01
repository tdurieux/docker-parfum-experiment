ARG PYTHON_VERSION=latest
FROM python:${PYTHON_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client libpq-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /nycdb/src
COPY ./src/ /nycdb/src/
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir -e .
ENTRYPOINT [ "python", "-m", "nycdb.cli" ]
CMD [ "--list-datasets" ]
