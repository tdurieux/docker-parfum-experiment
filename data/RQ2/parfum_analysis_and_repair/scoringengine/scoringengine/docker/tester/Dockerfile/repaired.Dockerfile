FROM scoringengine/base

USER root

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  rm -rf /var/lib/apt/lists/* && \
  curl -f -s -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 -o /usr/bin/cc-test-reporter && \
  chmod +x /usr/bin/cc-test-reporter

COPY bin /app/bin
COPY .flake8 /app/.flake8

# Set permissions for volume to be mounted
RUN \
  mkdir /app/artifacts && \
  chown engine:engine /app/artifacts

USER engine

COPY scoring_engine /app/scoring_engine
RUN pip install --no-cache-dir -e .
COPY tests /app/tests
RUN pip install --no-cache-dir -r /app/tests/requirements.txt

