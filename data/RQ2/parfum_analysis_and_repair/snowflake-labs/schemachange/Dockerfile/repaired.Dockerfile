FROM python:3.9

RUN pip install --no-cache-dir schemachange

ENTRYPOINT schemachange
