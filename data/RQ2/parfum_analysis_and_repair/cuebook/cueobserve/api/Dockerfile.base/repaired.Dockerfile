FROM python:3.9-slim-buster AS compile-image

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y --no-install-recommends build-essential gcc default-libmysqlclient-dev libodbc1 unixodbc unixodbc-dev && rm -rf /var/lib/apt/lists/*;


RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.9-slim-buster
ENV PYTHONUNBUFFERED=1
COPY --from=compile-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y --no-install-recommends unixodbc msodbcsql17 mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends nginx default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
