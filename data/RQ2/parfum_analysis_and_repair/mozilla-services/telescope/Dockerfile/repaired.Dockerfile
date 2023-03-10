FROM python:3.10-slim-buster

WORKDIR /app

RUN groupadd --gid 10001 app \
    && useradd -m -g app --uid 10001 -s /usr/sbin/nologin app

RUN apt-get update && \
    apt-get install --no-install-recommends --yes build-essential curl && \
    pip install --no-cache-dir --progress-bar=off -U pip && \
    pip install --no-cache-dir poetry && \
    apt-get -q --yes autoremove && \
    apt-get clean && \
    rm -rf /root/.cache && rm -rf /var/lib/apt/lists/*;

COPY ./pyproject.toml /app
COPY ./poetry.lock /app

COPY . /app

ENV HOST=0.0.0.0
ENV PORT=8000
EXPOSE 8000

# run as non priviledged user
USER app

RUN poetry install --extras=remotesettings --extras=taskcluster --no-dev --no-interaction --verbose

ENTRYPOINT ["/app/scripts/run.sh"]
CMD ["server"]
