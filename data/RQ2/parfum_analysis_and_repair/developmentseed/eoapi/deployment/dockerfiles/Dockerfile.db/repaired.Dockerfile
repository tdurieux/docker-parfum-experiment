FROM lambci/lambda:build-python3.8

ARG PGSTAC_VERSION

WORKDIR /tmp

RUN echo "Using PGSTAC Version ${PGSTAC_VERSION}"
RUN pip install --no-cache-dir requests psycopg["binary"] pypgstac==${PGSTAC_VERSION} -t /asset

COPY deployment/handlers/db_handler.py /asset/handler.py

# https://stackoverflow.com/a/61746719
# Turns out, asyncio is part of python
RUN rm -rf /asset/asyncio*

CMD ["echo", "hello world"]
