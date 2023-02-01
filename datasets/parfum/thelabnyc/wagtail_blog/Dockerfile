FROM python:3.8-slim
ENV PYTHONUNBUFFERED=1 \
  POETRY_VERSION=1.0.2 \
  POETRY_VIRTUALENVS_CREATE=false

RUN mkdir /code
WORKDIR /code

RUN pip install "poetry==$POETRY_VERSION"
COPY poetry.lock pyproject.toml /code/
RUN poetry install --no-interaction --no-ansi --no-root

ADD . /code/
