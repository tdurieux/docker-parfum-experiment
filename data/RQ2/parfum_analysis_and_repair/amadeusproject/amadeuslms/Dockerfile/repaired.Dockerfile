FROM python:3.8-slim

WORKDIR /code
ADD requirement_files/development.txt requirement_files/development.txt

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    libpq-dev \
    gcc \
    gettext \
    cron \
    && pip install --no-cache-dir -r /code/requirement_files/development.txt && rm -rf /var/lib/apt/lists/*;

ADD . .

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
