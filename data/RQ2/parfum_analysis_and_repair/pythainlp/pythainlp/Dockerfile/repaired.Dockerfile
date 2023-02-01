FROM python:3.7-slim-buster

COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends build-essential libicu-dev libicu63 pkg-config && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN if [ -f docker_requirements.txt ]; then \
 pip3 install --no-cache-dir -r docker_requirements.txt; fi
RUN pip3 install --no-cache-dir -e .[full] && pip3 cache purge
