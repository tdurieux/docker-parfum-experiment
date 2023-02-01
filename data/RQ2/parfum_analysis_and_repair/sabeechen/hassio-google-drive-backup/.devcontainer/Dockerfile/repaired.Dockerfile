FROM python:3.9-buster

WORKDIR /usr/src/install
RUN apt-get update && apt-get install -y --no-install-recommends fping && rm -rf /var/lib/apt/lists/*;
COPY requirements-dev.txt ./
RUN pip install --no-cache-dir -r requirements-dev.txt