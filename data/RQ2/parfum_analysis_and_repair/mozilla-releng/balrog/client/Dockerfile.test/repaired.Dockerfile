ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

WORKDIR /app

RUN pip install --no-cache-dir tox

ENTRYPOINT ["/usr/local/bin/tox", "-e"]
