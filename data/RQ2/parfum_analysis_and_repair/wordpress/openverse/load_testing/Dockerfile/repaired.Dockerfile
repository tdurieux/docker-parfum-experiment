FROM python:3.10-slim

RUN apt-get update && apt-get install --no-install-recommends -y wamerican apache2-utils && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
