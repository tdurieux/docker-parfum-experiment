FROM python:3.9

COPY ./poetry.lock /app/poetry.lock
COPY ./pyproject.toml /app/pyproject.toml

WORKDIR /app
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry install
RUN rm -rf ~/.cache
