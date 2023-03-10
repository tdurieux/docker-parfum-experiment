ARG PY_VERSION=${PY_VERSION:-latest}
FROM python:${PY_VERSION}

RUN adduser --disabled-password --disabled-login --gecos "python user" --home /home/python python
USER python
WORKDIR /home/python/code
RUN pip install --no-cache-dir --user tox
COPY . .
ENTRYPOINT "/home/python/.local/bin/tox"
