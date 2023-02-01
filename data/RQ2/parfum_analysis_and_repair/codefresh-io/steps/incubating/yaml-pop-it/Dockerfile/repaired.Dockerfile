FROM python:3.8.5-alpine3.12

RUN pip install --no-cache-dir pyyaml

COPY templates /

COPY lib/yaml-pop-it.py /yaml-pop-it.py
