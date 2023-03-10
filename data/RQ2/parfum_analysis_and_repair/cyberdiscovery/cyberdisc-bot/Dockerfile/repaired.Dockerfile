FROM python:3.9-buster

WORKDIR /app
RUN pip install --no-cache-dir poetry
ADD pyproject.toml poetry.lock /app/
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev --no-interaction --no-ansi
ADD . /app

CMD python -m cdbot
