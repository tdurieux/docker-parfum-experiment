FROM python:3.8.5-alpine3.12

RUN pip install --no-cache-dir pyyaml

COPY lib/composition-editor.py /composition-editor.py
