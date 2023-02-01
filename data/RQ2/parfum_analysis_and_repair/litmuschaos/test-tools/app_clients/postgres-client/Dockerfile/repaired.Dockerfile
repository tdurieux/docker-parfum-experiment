FROM postgres:latest

RUN apt-get update && \
    apt-get -y --force-yes install --no-install-recommends expect \
        python3 \
        python-pip \
        postgresql \
        python-psycopg2 \
        libpq-dev && \
    pip install --no-cache-dir --upgrade setuptools && \
    pip install --no-cache-dir psycopg2 && \
    python -m pip install psycopg2-binary && rm -rf /var/lib/apt/lists/*;

ADD workloads/test.sh liveness/liveness.py /

RUN chmod +x ./test.sh
