FROM python:3.9-slim-bullseye
ENV PYTHONUNBUFFERED=1
WORKDIR /backend

RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ml/ml_requirements.txt /backend/
COPY tests/requirements.txt /backend/requirements.dev.txt

RUN pip install --no-cache-dir -r ml_requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements.dev.txt
