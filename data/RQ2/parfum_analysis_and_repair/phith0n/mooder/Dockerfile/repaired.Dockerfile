FROM python:3.8

WORKDIR /app
COPY requirements.txt /tmp/requirements.txt

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y libpq-dev libjpeg-dev zlib1g-dev libfreetype6-dev wait-for-it \
    && pip install --no-cache-dir -r /tmp/requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY . /app
EXPOSE 80

CMD ["bash", "/app/docker-entrypoint.sh"]
