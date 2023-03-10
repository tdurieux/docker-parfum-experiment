#
# Crawler fetcher
#

FROM gcr.io/mcback/common:latest

# Copy sources
COPY src/ /opt/mediacloud/src/crawler-fetcher/
ENV PERL5LIB="/opt/mediacloud/src/crawler-fetcher/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/crawler-fetcher/python:${PYTHONPATH}"

# Copy worker script