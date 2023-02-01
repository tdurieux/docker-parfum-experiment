ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}-slim

WORKDIR /tmp

COPY titiler/ titiler/
COPY setup.py setup.py
COPY setup.cfg setup.cfg
COPY README.md README.md

RUN pip install --no-cache-dir --upgrade .["psycopg-binary"] uvicorn
RUN rm -rf titiler/ setup.py setup.cfg README.md

# http://www.uvicorn.org/settings/
ENV HOST 0.0.0.0
ENV PORT 80
CMD uvicorn titiler.pgstac.main:app --host ${HOST} --port ${PORT}