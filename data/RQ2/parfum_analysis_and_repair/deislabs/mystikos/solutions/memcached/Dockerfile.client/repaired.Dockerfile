FROM python:3-alpine

RUN pip install --no-cache-dir pymemcache

RUN mkdir -p /app
ADD memcached_test.py /app
ENTRYPOINT ["/usr/local/bin/python","/app/memcached_test.py"]
