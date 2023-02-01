FROM python:3.6

RUN pip install --no-cache-dir opcua

CMD uaserver
