ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

WORKDIR /app

COPY docker.d/image_setup.sh /app/

RUN /app/image_setup.sh

COPY MANIFEST.in setup.py tox.ini /app/
COPY requirements/ /app/requirements/

ARG PYTHON_REQ_SUFFIX
RUN pip install --no-cache-dir -r requirements/local${PYTHON_REQ_SUFFIX}.txt

COPY src/ /app/src/

ENTRYPOINT ["/usr/local/bin/tox", "-e"]
