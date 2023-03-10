FROM python:3.8

RUN  mkdir /tmp/output && \
     mkdir /var/log/oasis

RUN apt-get update && apt-get install -y --no-install-recommends \ 
            vim libspatialindex-dev python-dev && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir tox flake8 coverage

WORKDIR /home
COPY . .
CMD ./docker/entrypoint_unittest.sh
