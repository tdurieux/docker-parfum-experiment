FROM python:3.7-buster as base

COPY requirements.txt /tmp/
COPY requirements-test.txt /tmp/

RUN apt-get update && apt-get install -y --no-install-recommends sqlite3 && pip install --no-cache-dir -r /tmp/requirements.txt && rm -rf /var/lib/apt/lists/*;

# for testing
RUN pip install --no-cache-dir -r /tmp/requirements-test.txt

COPY . /app/

WORKDIR /app

ENV MLFLOW_TRACKING_URI http://localhost:5000

RUN bash create_dev_environment.sh
RUN bash run_tests.sh

ENTRYPOINT ["bash", "/app/bootstrap.sh"]