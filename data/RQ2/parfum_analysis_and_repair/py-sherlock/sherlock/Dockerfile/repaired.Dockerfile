FROM python:3.7

WORKDIR /sherlock

# Memcached
RUN apt-get update -y && apt-get install --no-install-recommends -y libmemcached-dev gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pytz ipython ipdb

COPY requirements-ci.txt /sherlock/requirements-ci.txt
RUN pip install --no-cache-dir -r /sherlock/requirements-ci.txt && \
    rm /sherlock/requirements-ci.txt
