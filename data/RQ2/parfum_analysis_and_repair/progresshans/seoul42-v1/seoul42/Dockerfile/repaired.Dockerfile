FROM    python:3.8

ENV     PYTHONUNBUFFERED 1

WORKDIR /seoul42
ADD     requirements.txt /seoul42/
RUN pip install --no-cache-dir -r requirements.txt