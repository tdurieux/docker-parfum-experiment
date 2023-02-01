FROM python:3.7-alpine

RUN pip install --no-cache-dir kondunite

ENTRYPOINT ["kondunite"]
