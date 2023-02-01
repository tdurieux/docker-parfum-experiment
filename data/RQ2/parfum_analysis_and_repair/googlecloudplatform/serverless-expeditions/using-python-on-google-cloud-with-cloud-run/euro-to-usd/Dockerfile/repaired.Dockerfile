FROM python:3.8-slim

WORKDIR /app

COPY . ./

RUN pip install --no-cache-dir flask gunicorn CurrencyConverter

CMD gunicorn --bind :$PORT app:app