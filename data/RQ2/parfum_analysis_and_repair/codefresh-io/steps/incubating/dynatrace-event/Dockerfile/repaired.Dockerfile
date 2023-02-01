FROM python:3.9.7-alpine3.14

RUN pip install --no-cache-dir requests

COPY lib/dynatrace_event.py /dynatrace_event.py