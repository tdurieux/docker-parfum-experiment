FROM laudio/pyodbc:1.0.38 AS base

USER root

ENV ACCEPT_EULA=Y

RUN apt-get install --no-install-recommends -y debconf-utils \
  && apt-get update -y \
  && apt-get -y --no-install-recommends install mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;

ENV PATH="$PATH:/opt/mssql-tools/bin"

FROM base AS test

WORKDIR /test

COPY requirements-dev.txt .
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements-dev.txt

COPY test ./test

CMD ["pytest", "-vvv"]
