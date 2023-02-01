FROM sequoiatools/pillowfight

RUN apt-get update
RUN apt-get install --no-install-recommends -y python-dev python-pip && rm -rf /var/lib/apt/lists/*;

# python deps
RUN pip install --no-cache-dir gevent==1.2.1

WORKDIR /root

WORKDIR /root
RUN pip install --no-cache-dir pyyaml && \
    pip install --no-cache-dir eventlet && \
    pip install --no-cache-dir requests

RUN pip install --no-cache-dir git+git://github.com/couchbase/couchbase-python-client

# src
RUN git clone https://github.com/couchbaselabs/gideon.git
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
WORKDIR gideon
RUN git pull

COPY spec.yaml /spec.yaml
COPY views.json views.json
COPY addviews.sh addviews.sh
COPY run.sh run.sh
ENTRYPOINT ["./run.sh"]
