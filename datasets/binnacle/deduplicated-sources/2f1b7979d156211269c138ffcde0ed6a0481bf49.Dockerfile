# Note: the Django and psycopg2 versions are repeated in requirements.txt for the benefit
# of the analysis container. The base container and requirements file versions should be kept
# in sync.
FROM quay.io/azavea/django:1.11-python2.7-slim

MAINTAINER Azavea

RUN pip install --upgrade pip

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY . /usr/src
WORKDIR /usr/src

EXPOSE 9202

CMD ["-w", "1", \
     "-b", "0.0.0.0:9202", \
     "--reload", \
     "--log-level", "info", \
     "--error-logfile", "-", \
     "--forwarded-allow-ips", "*", \
     "-k", "gevent", \
     "pfb_network_connectivity.wsgi"]
