FROM python:3.8-slim

ENV PYTHONUNBUFFERED=1
ENV ROOT=/usr/src/app

WORKDIR ${ROOT}

COPY stilio/config.py stilio/config.py
COPY stilio/__init__.py stilio/__init__.py
COPY stilio/frontend stilio/frontend
COPY stilio/persistence stilio/persistence

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir poetry
COPY pyproject.toml .
COPY poetry.lock .
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-dev
RUN rm -rf /pyproject.toml \
    && rm -rf /poetry.lock

RUN apt-get remove -y build-essential \
    && apt-get -y autoremove

CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000", "stilio.frontend.main:app"]
