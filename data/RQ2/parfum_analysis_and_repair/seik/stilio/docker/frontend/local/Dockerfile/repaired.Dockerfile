FROM python:3.8-slim

ENV PYTHONUNBUFFERED=1
ENV ROOT=/usr/src/app

WORKDIR ${ROOT}

COPY . ${ROOT}

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir poetry
COPY pyproject.toml .
COPY poetry.lock .
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction
RUN rm -rf /pyproject.toml \
    && rm -rf /poetry.lock

RUN apt-get remove -y build-essential \
    && apt-get -y autoremove

CMD ["uvicorn", "--reload", "--host", "0.0.0.0", "stilio.frontend.main:app"]
