FROM python:3.10.4-slim as requirements-stage

WORKDIR /tmp

RUN pip install --no-cache-dir poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry export --output requirements.txt --without-hashes --extras fast --extras anime

FROM python:3.10.4-slim

WORKDIR /userbot

COPY --from=requirements-stage /tmp/requirements.txt ./requirements.txt

RUN apt update \
    && apt install --no-install-recommends -y python3-opencv \
    && pip install --no-cache-dir --upgrade -r ./requirements.txt \
    && rm -rf /var/lib/apt/lists/*

COPY . .

CMD ["python", "-m", "app"]