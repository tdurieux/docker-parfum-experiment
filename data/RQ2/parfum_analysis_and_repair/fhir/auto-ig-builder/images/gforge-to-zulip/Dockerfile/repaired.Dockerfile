FROM python:2.7
MAINTAINER Josh Mandel

RUN pip install --no-cache-dir requests zulip unicodecsv
ADD sync.py /usr/local/bin/sync.py

ENTRYPOINT python -u /usr/local/bin/sync.py
