# Build container conda env
FROM python:3.7

ENV LIBRARY_VERSION 0.5.2
RUN pip install --no-cache-dir "fh-immuta-utils==${LIBRARY_VERSION}"

ENTRYPOINT "fh-immuta-utils"
