FROM python:3.8-slim

ENV PIP_VERSION 20.3.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends make && \
    pip install --no-cache-dir -U pip==${PIP_VERSION} && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY satellite satellite
COPY app.py Makefile pyproject.toml ./

ENTRYPOINT ["make", "lint", "test"]
