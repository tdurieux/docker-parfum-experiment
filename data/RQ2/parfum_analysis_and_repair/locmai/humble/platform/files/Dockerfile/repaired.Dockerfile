FROM python:3.10-slim-buster

WORKDIR /app

RUN pip install --no-cache-dir kubernetes

RUN pip install --no-cache-dir hvac

CMD python
