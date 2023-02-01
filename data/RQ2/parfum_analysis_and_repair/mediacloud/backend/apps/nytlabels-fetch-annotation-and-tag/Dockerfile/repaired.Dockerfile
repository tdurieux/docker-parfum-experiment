#
# NYTLabels fetch annotation + tag worker
#

FROM gcr.io/mcback/common:latest

# Copy sources
COPY src/ /opt/mediacloud/src/nytlabels-fetch-annotation-and-tag/
ENV PERL5LIB="/opt/mediacloud/src/nytlabels-fetch-annotation-and-tag/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/nytlabels-fetch-annotation-and-tag/python:${PYTHONPATH}"

# Copy worker script
COPY bin /opt/mediacloud/bin

# Make worker script executable 