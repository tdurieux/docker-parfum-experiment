#
# Export tables to run backup crawler
#

FROM gcr.io/mcback/common:latest

# Copy sources
COPY src/ /opt/mediacloud/src/export-tables-to-backup-crawler/
ENV PERL5LIB="/opt/mediacloud/src/export-tables-to-backup-crawler/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/export-tables-to-backup-crawler/python:${PYTHONPATH}"

# Copy exporter script