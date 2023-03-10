FROM python:3.7.6-slim-buster as base

# required to install packages from github
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app ./app

# -- Test stage --
FROM base as test

RUN apt -y --no-install-recommends install docker.io && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.dev.txt requirements.dev.txt
RUN pip install --no-cache-dir -r requirements.dev.txt

COPY ./tests ./tests
COPY ./.env.test ./.env
COPY ./pytest.ini ./pytest.ini
# RUN mkdir test-reports
# RUN PYTHONPATH="." MOCK_DEPENDENCIES=1 pytest \
#     --junitxml=test-reports/junit.xml \
#     --cov \
#     --cov-report=xml:test-reports/coverage.xml \
#     --cov-report=html:test-reports/coverage.html \
#     ./tests; \
#     echo $? > test-reports/pytest.exitcode

# -- Deploy stage --
FROM base as build

COPY logging.conf logging.conf

EXPOSE 7000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7000", "--log-config", "logging.conf"]
