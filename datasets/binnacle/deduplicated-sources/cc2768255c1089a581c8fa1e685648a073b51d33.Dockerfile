FROM alephdata/memorious:master

COPY setup.py /crawlers/
COPY src /crawlers/src
RUN pip3 install -q -e /crawlers
COPY config /crawlers/config

ENV MEMORIOUS_CONFIG_PATH=/crawlers/config \
    MEMORIOUS_BASE_PATH=/data \
    MEMORIOUS_DEBUG=false \
    REDIS_URL=redis://redis:6379/0 \
    ARCHIVE_PATH=archive
