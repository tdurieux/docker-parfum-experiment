FROM python:3.7.8-slim

ENV PYTHONUNBUFFERED="true"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y build-essential python3-lxml --no-install-recommends \
  && pip install --no-cache-dir lxml==4.4.1 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/share/doc && rm -rf /usr/share/man \
  && apt-get purge -y --auto-remove build-essential \
  && apt-get clean

COPY requirements.txt .
COPY requirements-dev.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY . .

RUN pip install --no-cache-dir .
