# This file is used to run component tests on CI. Once the component tests don't rely on the common project, this
# file can be moved to a sub directory.
FROM python:3.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libssl-dev swig pkg-config git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv

WORKDIR /test
COPY . .

WORKDIR /test/integration-tests/integration_tests
RUN pipenv install --dev --deploy --ignore-pipfile

ENTRYPOINT [ "pipenv", "run", "componenttests" ]