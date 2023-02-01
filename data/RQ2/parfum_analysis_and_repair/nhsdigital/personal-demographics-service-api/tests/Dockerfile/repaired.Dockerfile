FROM python:3.8.2-slim

# Maintainers
LABEL maintainer="Personal Demographics Team"

RUN apt-get update && apt-get install -y --no-install-recommends make && apt-get install --no-install-recommends curl -y && apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir poetry

# Create working directory
RUN mkdir -p /tests/

# Set up test environment
COPY . /tests/

WORKDIR /tests/
