FROM python:3.7

RUN mkdir -p /app
WORKDIR /app

RUN pip install --no-cache-dir poetry

COPY . /app/

RUN poetry install

CMD ./produce-report.sh
