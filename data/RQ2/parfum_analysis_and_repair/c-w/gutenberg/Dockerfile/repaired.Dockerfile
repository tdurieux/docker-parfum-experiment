ARG PYTHON_VERSION=3.7
FROM python:${PYTHON_VERSION}

RUN apt-get update \
 && apt-get install --no-install-recommends -y libdb-dev && rm -rf /var/lib/apt/lists/*;

ENV BERKELEYDB_DIR=/usr

WORKDIR /app

ADD requirements-dev.pip /app/requirements-dev.pip
RUN pip install --no-cache-dir -r /app/requirements-dev.pip

ADD . /app
RUN pip install --no-cache-dir .

ENV GUTENBERG_DATA=/data

CMD ["nose2"]
