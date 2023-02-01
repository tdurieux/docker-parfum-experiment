FROM python:3.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y gcc python-dev gettext-base && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

COPY test-requirements.txt /app/test-requirements.txt

RUN pip install --no-cache-dir -r /app/test-requirements.txt

COPY kinesis /app/kinesis/

COPY tests.py /app/tests.py

WORKDIR /app/
