FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y curl python-pip unzip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir requests >=2.20.0 && pip install --no-cache-dir psycopg2-binary==2.7.4 && pip install --no-cache-dir le-utils >=0.1.19

COPY ./deploy/cloudprober.cfg /deploy/
COPY ./deploy/send_metrics_newrelic.py /deploy/
COPY ./deploy/prober-entrypoint.sh /deploy/
COPY ./deploy/probers /deploy/probers/
