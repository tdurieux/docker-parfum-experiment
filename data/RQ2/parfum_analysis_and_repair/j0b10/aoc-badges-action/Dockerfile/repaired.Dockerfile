FROM python:3.8-alpine

RUN pip install --no-cache-dir requests

ADD entrypoint.sh /entrypoint.sh
ADD aoc-badges.py /aoc-badges.py

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
