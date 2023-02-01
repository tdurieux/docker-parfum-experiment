FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED=1
ENV ROOT=/usr/src/app

WORKDIR ${ROOT}

COPY stilio/config.py stilio/config.py
COPY stilio/__init__.py stilio/__init__.py
COPY stilio/crawler stilio/crawler
COPY stilio/persistence stilio/persistence

RUN apt-get update \
    # psycopg2 dependencies
    && apt-get install -y gcc python3-dev musl-dev

RUN pip install poetry
COPY pyproject.toml .
COPY poetry.lock .
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-dev
RUN rm -rf /pyproject.toml \
    && rm -rf /poetry.lock

RUN apt-get remove -y build-essential \
    && apt-get -y autoremove

COPY docker/crawler/entrypoint.sh entrypoint.sh
RUN sed -i 's/\r$//g' entrypoint.sh

ENTRYPOINT ["bash", "entrypoint.sh"]

CMD ["python", "-m", "stilio.crawler.main"]
