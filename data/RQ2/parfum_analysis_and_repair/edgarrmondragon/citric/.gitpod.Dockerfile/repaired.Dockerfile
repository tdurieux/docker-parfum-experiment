FROM python:3.10-slim-buster

ENV POETRY_HOME /etc/poetry
ENV PATH "${POETRY_HOME}/bin:${PATH}"

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y curl \
    && curl -f -sSL https://install.python-poetry.org | python3 - \
    && ${POETRY_HOME}/bin/poetry config virtualenvs.create "true" \
    && ${POETRY_HOME}/bin/poetry config virtualenvs.in-project "true" && rm -rf /var/lib/apt/lists/*;

COPY .github/workflows/constraints.txt .
RUN pip install --no-cache-dir --constraint=constraints.txt pip
