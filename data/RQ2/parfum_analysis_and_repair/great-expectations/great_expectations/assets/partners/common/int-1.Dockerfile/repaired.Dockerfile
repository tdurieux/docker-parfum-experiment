FROM --platform=linux/amd64 python:3.9-slim
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN great_expectations -y init
COPY . /app/
