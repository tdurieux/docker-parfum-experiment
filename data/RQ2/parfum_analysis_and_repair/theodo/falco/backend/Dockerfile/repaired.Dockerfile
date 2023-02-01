FROM python:3.8
ENV PYTHONPATH /code
# This is to print directly to stdout instead of buffering output
ENV PYTHONUNBUFFERED 1

WORKDIR /code

RUN pip install --no-cache-dir pipenv

COPY Pipfile ./
COPY Pipfile.lock ./
RUN pipenv install --dev --system --deploy
