ARG BASE_IMAGE=gcr.io/kf-feast/feast-ci:latest

FROM ${BASE_IMAGE}

RUN mkdir -p /src/ /src/spark/ingestion

COPY python /src/python

COPY README.md /src/README.md

WORKDIR /src

RUN pip install --no-cache-dir -r python/requirements-ci.txt

RUN git init .
RUN pip install --no-cache-dir -e python -U
RUN pip install --no-cache-dir "s3fs" "boto3" "urllib3>=1.25.4"

COPY tests /src/tests

RUN pip install --no-cache-dir -r tests/requirements.txt

COPY infra/scripts /src/infra/scripts
COPY spark/ingestion/target /src/spark/ingestion/target
