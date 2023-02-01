ARG PY_VERSION=3.7
FROM python:${PY_VERSION}-alpine

RUN pip install --no-cache-dir setuptools wheel twine yolk3k

ENTRYPOINT ["/bin/sh"]
