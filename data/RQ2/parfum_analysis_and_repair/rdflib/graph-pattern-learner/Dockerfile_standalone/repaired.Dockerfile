# standalone (for use with external virtuoso)
FROM python:2

COPY requirements.txt /tmp

RUN pip install --no-cache-dir -r /tmp/requirements.txt
