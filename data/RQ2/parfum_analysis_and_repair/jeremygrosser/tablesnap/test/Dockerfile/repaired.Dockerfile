FROM cassandra:2.2
RUN apt-get update && apt-get install --no-install-recommends -y python-pyinotify python-boto python-argparse python-dateutil python-eventlet && rm -rf /var/lib/apt/lists/*;
ADD boto.cfg /etc/
ADD tablesnap tableslurp tablechop test_verify_and_delete.py /usr/local/bin/
