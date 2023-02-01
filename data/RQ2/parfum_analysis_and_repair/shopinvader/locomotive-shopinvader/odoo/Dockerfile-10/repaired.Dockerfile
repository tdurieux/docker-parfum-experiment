FROM quay.io/acsone/odoo-bedrock:10.0-py27-latest

RUN set -e \
  && apt update \
  && apt -y install --no-install-recommends postgresql-client \
  && apt -y clean \
  && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint-db /odoo/start-entrypoint.d/

COPY ./requirements-10.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

