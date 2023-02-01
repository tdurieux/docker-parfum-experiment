FROM python:3.7-slim

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -U -r /tmp/requirements.txt

COPY *.py ./