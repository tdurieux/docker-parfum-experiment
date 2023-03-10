FROM python:3.9-slim-buster
COPY openaq_fastapi/requirements.txt /workspace/requirements.txt
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
WORKDIR /workspace
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg wget \
    && wget -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" >/etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client-13 pgdg-keyring \
    && chmod +x /wait \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*
EXPOSE 8888
CMD pip install . && openaqapi